import 'package:client/screens/Ceercles.dart';
import 'package:client/screens/Discover.dart';
import 'package:client/screens/Events.dart';
import 'package:client/screens/Profile.dart';
import 'package:client/screens/ProfileAvatar.dart';
import 'package:client/screens/Shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:client/screens/Auth.dart';
import 'package:client/screens/InfosPerso.dart';
import 'package:client/screens/Login.dart';
import 'package:client/screens/Messenger.dart';
import 'package:client/screens/MessengerThread.dart';
import 'package:client/screens/PasswordReset.dart';
import 'package:client/screens/Register.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/screens/RegisterProfile.dart';
import 'package:client/widgets/common/PrivateScaffold.dart';
import 'package:vrouter/vrouter.dart';
import 'package:client/screens/VerifyEmail.dart';
import 'handlers/AuthHandler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await init();
  var auth = await AuthHandler.getInstance();
  runApp(ChangeNotifierProvider(create: (context) => auth, child: Main()));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  FlutterNativeSplash.remove();
}

init() async {
  await initHiveForFlutter();
  await dotenv.load(fileName: ".env");
}

SlideTransition handleTransition(Animation<double> animation,
    Animation<double> animation2, Widget child, int previousIndex, int index) {
  if (previousIndex > index) {
    return SlideTransition(
      position: Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
          .animate(animation),
      child: child,
    );
  } else {
    return SlideTransition(
      position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
          .animate(animation),
      child: child,
    );
  }
}

final List<String> routes = [
  Messenger.route,
];

class AnimatedPage extends Page {
  final Widget child;

  const AnimatedPage(this.child, LocalKey key, String name)
      : super(key: key, name: name);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var previousIndex =
            routes.indexOf(context.vRouter.previousUrl ?? Messenger.route);
        var selectedIndex = routes.indexOf(context.vRouter.url);

        return handleTransition(
            animation, animation2, child, previousIndex, selectedIndex);
      },
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthHandler>(
      builder: (context, auth, child) {
        Link link;
        final HttpLink httpLink = HttpLink(
          dotenv.env['GQL_URL'] as String,
        );

        if (auth.bearer.isNotEmpty) {
          final AuthLink authLink = AuthLink(
            getToken: () => auth.bearer,
          );

          link = authLink.concat(httpLink);
        } else {
          link = httpLink;
        }

        print("state");
        print(auth.bearer);
        print("emailverif");
        print(auth.emailVerified);
        print("logged");
        print(auth.loggedIn);
        print("hasProfile");
        print(auth.hasProfile);

        final ValueNotifier<GraphQLClient> client = ValueNotifier(
          GraphQLClient(
            link: link,
            cache: GraphQLCache(store: HiveStore()),
          ),
        );

        return GraphQLProvider(
          client: client,
          child: VRouter(
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color.fromRGBO(124, 77, 255, 1),
              primaryColorDark: const Color.fromRGBO(72, 12, 168, 1),
              primaryColorLight: const Color.fromRGBO(192, 186, 217, 1),
              backgroundColor: Colors.white,
              errorColor: const Color.fromARGB(255, 222, 52, 77),
              cardColor: const Color.fromARGB(255, 225, 224, 224),
              textTheme: GoogleFonts.poppinsTextTheme(
                TextTheme(
                  headline1: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 36.0, fontWeight: FontWeight.bold),
                  ),
                  headline2: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                  headline3: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                  headline4: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  headline5: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  headline6: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                  bodyText1: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                  button: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            mode: VRouterMode.history,
            initialUrl: auth.loggedIn ? VerifyEmail.route : Auth.route,
            routes: [
              VGuard(
                beforeEnter: (vRedirector) async =>
                    !auth.loggedIn || !auth.hasProfile || !auth.emailVerified
                        ? vRedirector.to(VerifyEmail.route)
                        : null,
                stackedRoutes: [
                  VNester(
                    path: null,
                    widgetBuilder: (child) => PrivateScaffold(
                      title: null,
                      useAppbar: true,
                      useBackButton: false,
                      body: child,
                    ),
                    nestedRoutes: [
                      VPage(
                        path: Discover.route,
                        widget: const Discover(),
                        pageBuilder:
                            (LocalKey key, Widget child, String? name) =>
                                AnimatedPage(child, key, name ?? "Discover"),
                      ),
                      VPage(
                        path: Events.route,
                        widget: const Events(),
                        pageBuilder:
                            (LocalKey key, Widget child, String? name) =>
                                AnimatedPage(child, key, name ?? "Events"),
                      ),
                      VPage(
                        path: Messenger.route,
                        widget: const Messenger(),
                        pageBuilder:
                            (LocalKey key, Widget child, String? name) =>
                                AnimatedPage(child, key, name ?? "Messenger"),
                      ),
                      VPage(
                        path: Ceercles.route,
                        widget: const Ceercles(),
                        pageBuilder:
                            (LocalKey key, Widget child, String? name) =>
                                AnimatedPage(child, key, name ?? "Ceercles"),
                      ),
                      VPage(
                        path: Shop.route,
                        widget: const Shop(),
                        pageBuilder:
                            (LocalKey key, Widget child, String? name) =>
                                AnimatedPage(child, key, name ?? "Boutique"),
                      ),
                      VPage(
                        path: Profile.route,
                        widget: Profile(),
                        pageBuilder:
                            (LocalKey key, Widget child, String? name) =>
                                AnimatedPage(child, key, name ?? "Profile"),
                      ),
                    ],
                  ),
                  VWidget(
                      path: MessengerThread.route, widget: MessengerThread()),
                  VWidget(path: InfosPerso.route, widget: const InfosPerso()),
                  VWidget(
                      path: ProfileAvatar.route, widget: const ProfileAvatar()),
                ],
              ),
              VGuard(
                beforeEnter: (vRedirector) async =>
                    auth.loggedIn ? vRedirector.to(Messenger.route) : null,
                stackedRoutes: [
                  VWidget(
                    path: Login.route,
                    widget: const Login(),
                  ),
                  VWidget(
                    path: Register.route,
                    widget: const Register(),
                  ),
                  VWidget(path: Auth.route, widget: const Auth()),
                  VWidget(
                    path: PasswordReset.route,
                    widget: const PasswordReset(),
                  ),
                ],
              ),
              VGuard(
                beforeEnter: (vRedirector) async => auth.emailVerified
                    ? vRedirector.to(RegisterProfile.route)
                    : null,
                stackedRoutes: [
                  VWidget(
                    path: VerifyEmail.route,
                    widget: const VerifyEmail(),
                  )
                ],
              ),
              VGuard(
                beforeEnter: (vRedirector) async =>
                    auth.hasProfile ? vRedirector.to(Messenger.route) : null,
                stackedRoutes: [
                  VWidget(
                    path: RegisterProfile.route,
                    widget: RegisterProfile(),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
