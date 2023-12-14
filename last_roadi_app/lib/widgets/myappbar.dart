import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? height;
  final bool? withLeading;
  final Function()? onPressed;
  final List<Widget>? actions;

  const MyAppbar({
    Key? key,
    required this.title,
    this.withLeading = false,
    this.height,
    this.onPressed,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height!);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        // leading: Container(),
        actions: actions,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
