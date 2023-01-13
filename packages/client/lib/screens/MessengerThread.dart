import 'package:bubble/bubble.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:client/entities/Contact.dart';
import 'package:client/graphql/queries/messenger.dart';
import 'package:client/widgets/common/Input.dart';
import 'package:client/widgets/common/RoundButton.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vrouter/vrouter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

import '../entities/Message.dart';
import '../handlers/AuthHandler.dart';
import '../widgets/common/CAppBar.dart';
import '../widgets/common/Snack.dart';

class MessengerThread extends StatefulWidget {
  MessengerThread({Key? key}) : super(key: key);

  static const route = '/messenger-thread/:contactId/:contactFullname';
  static const firstParam = ':contactId';
  static const secondParam = ':contactFullname';

  @override
  State<MessengerThread> createState() => _MessengerThreadState();
}

class _MessengerThreadState extends State<MessengerThread> {
  IO.Socket? socket;
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var reachedEnd = false;
  var loading = false;

  void scrollDown([int? milliseconds]) {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: milliseconds ?? 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      setState(() {
        socket = IO.io(
          dotenv.env["SOCKET_URL"],
          OptionBuilder()
              .disableAutoConnect()
              .setTransports(['websocket']).setExtraHeaders(
            {
              'Authorization':
                  Provider.of<AuthHandler>(context, listen: false).getBearer
            },
          ).build(),
        );
      });

      socket!.connect();

      socket!.onConnectError((data) {
        print("connect error");
        print(data);
      });

      socket!.onConnect((_) {
        print('connected socket io ');
      });

      socket!.on('MESSAGE', (data) {
        print("message");
        print(data);
        setState(() {
          messages.insert(0, Message.fromJson(data));
          print(messages[0].createdAt);
        });
      });
    });

    timeago.setLocaleMessages('fr', timeago.FrMessages());
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    socket!.dispose();

    super.dispose();
  }

  sendMessage(String receivedId) {
    if (messageController.text.isEmpty || messageController.text.length > 250) {
      return;
    }

    socket!.emit(
        "MESSAGE", {"text": messageController.text, "receiverId": receivedId});

    messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    var contactId = context.vRouter.pathParameters["contactId"];
    var contactFullname = context.vRouter.pathParameters["contactFullname"];

    assert(contactId != null && contactFullname != null);

    return Query(
      options: QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(getMessages),
        variables: {
          "data": {"contactId": contactId},
        },
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        FetchMoreOptions opts = FetchMoreOptions(
          variables: {
            "data": {
              "contactId": contactId,
              'skip': (result.data?["getMessages"] != null
                  ? (result.data?["getMessages"] as List).length
                  : 0)
            },
          },
          updateQuery: (previousResultData, fetchMoreResultData) {
            final ids = Set();
            final List<dynamic> repos = [
              ...previousResultData!['getMessages'] as List<dynamic>,
              ...fetchMoreResultData!['getMessages'] as List<dynamic>,
            ];

            setState(() {
              reachedEnd = fetchMoreResultData['getMessages'].isEmpty;
            });

            repos.retainWhere((element) => ids.add(element["id"]));

            fetchMoreResultData['getMessages'] = repos;

            setState(() {
              loading = false;
            });

            return fetchMoreResultData;
          },
        );

        return Scaffold(
          appBar: CAppBar(
            title: Text(
              contactFullname!,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            useBackButton: true,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              NotificationListener<ScrollUpdateNotification>(
                onNotification: (t) {
                  if (t.metrics.pixels >=
                          scrollController.position.maxScrollExtent - 1 &&
                      !loading) {
                    if (fetchMore != null) {
                      setState(() {
                        loading = true;
                      });
                      print("fetching more");
                      fetchMore(opts);
                    }
                  }

                  return true;
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 90),
                  child: ListView(
                    reverse: true,
                    controller: scrollController,
                    children: [
                      if (result.hasException)
                        Text(result.exception.toString()),
                      ...messages.map(
                        (m) => Stack(
                          children: [
                            Bubble(
                              margin: const BubbleEdges.symmetric(
                                  vertical: 20, horizontal: 20),
                              alignment: m.sender.id == contactId
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              nip: m.sender.id == contactId
                                  ? BubbleNip.leftTop
                                  : BubbleNip.rightTop,
                              color: m.sender.id == contactId
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              child: Text(
                                m.text,
                                style: TextStyle(
                                  color: m.sender.id != contactId
                                      ? Colors.white
                                      : Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: m.sender.id == contactId
                                    ? Alignment.bottomLeft
                                    : Alignment.bottomRight,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 50, left: 30, right: 30),
                                  child: Text(
                                    timeago.format(
                                      m.createdAt.toLocal(),
                                      locale: 'fr',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (result.data != null)
                        ...((result.data!["getMessages"] as List)
                            .map(
                              (m) => Stack(
                                children: [
                                  Bubble(
                                    margin: const BubbleEdges.symmetric(
                                        vertical: 20, horizontal: 20),
                                    alignment: m["sender"]["id"] == contactId
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    nip: m["sender"]["id"] == contactId
                                        ? BubbleNip.leftTop
                                        : BubbleNip.rightTop,
                                    color: m["sender"]["id"] == contactId
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                    child: Text(
                                      m["text"],
                                      style: TextStyle(
                                        color: m["sender"]["id"] != contactId
                                            ? Colors.white
                                            : Theme.of(context)
                                                .primaryColorDark,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: m["sender"]["id"] == contactId
                                          ? Alignment.bottomLeft
                                          : Alignment.bottomRight,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 50, left: 30, right: 30),
                                        child: Text(
                                          timeago.format(
                                            DateTime.parse(m["createdAt"])
                                                .toLocal(),
                                            locale: 'fr',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList()),
                      if (result.data == null ||
                          (!reachedEnd &&
                              (result.data!["getMessages"] as List).length >
                                  20))
                        const SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballClipRotate,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Input(
                    context,
                    Icons.message,
                    "Votre message",
                    messageController,
                    (String value) {
                      return null;
                    },
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.3),
                    radius: 4,
                    onTap: scrollDown,
                    hintColor: Theme.of(context).primaryColorDark,
                    requiredField: false,
                    maxLength: 250,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 48,
                right: 30,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () => sendMessage(contactId!),
                    child: Icon(Icons.send),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
