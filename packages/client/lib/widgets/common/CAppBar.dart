import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  final Widget? title;
  final Color? backgroundColor;
  final bool useBackButton;
  final bool? centerTitle;
  final String? routeOverride;

  const CAppBar(
      {Key? key,
      this.title,
      this.backgroundColor,
      this.useBackButton = true,
      this.centerTitle = false,
      this.routeOverride})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: useBackButton
          ? IconButton(
              iconSize: 30,
              icon:
                  Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
              onPressed: () => routeOverride != null
                  ? context.vRouter.to(routeOverride!)
                  : context.vRouter.historyBack(),
            )
          : null,
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      title: title,
      toolbarHeight: 80,
      centerTitle: centerTitle,
    );
  }
}
