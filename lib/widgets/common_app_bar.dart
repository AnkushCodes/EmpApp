import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

   CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      title: Text(
        title,
        style:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      ),

      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 3,
      actions: actions,
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
