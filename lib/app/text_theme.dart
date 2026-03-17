import 'package:daytask_app/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  AppTextTheme._();

  static final TextStyle screenTitle = GoogleFonts.montserrat(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle sectionHeading = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle chatHeaderName = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 15,
  );

  static const TextStyle chatHeaderStatus = TextStyle(
    color: Color(0xFFA9BAC8),
    fontSize: 13,
  );

  static const TextStyle chatInputHint = TextStyle(
    color: Color(0xFF8CA7BA),
    fontSize: 13,
  );

  static const TextStyle chatListName = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const TextStyle chatListSubtitle = TextStyle(
    color: Color(0xFFA7B8C6),
    fontSize: 10,
  );

  static const TextStyle chatListTime = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle chatBubbleMine = TextStyle(
    color: Color(0xFF1A2738),
    fontSize: 12,
  );

  static const TextStyle chatBubbleOther = TextStyle(
    color: Colors.white,
    fontSize: 12,
  );

  static const TextStyle chatSeen = TextStyle(
    color: Color(0xFF1A2738),
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle notificationBase = TextStyle(
    color: Color(0xFF9FB0BF),
    height: 1.25,
    fontSize: 11,
  );

  static const TextStyle notificationName = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  static const TextStyle notificationTask = TextStyle(
    color: AppTheme.accent,
    fontSize: 13,
  );

  static const TextStyle notificationTime = TextStyle(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}
