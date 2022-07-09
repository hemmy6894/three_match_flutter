import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';

class ThreeBottomNavigationBar {
  TextStyle _buildTextStyle(Color color, {double size = 16}) {
    return TextStyle(
        color: color, fontSize: size);
  }

  OutlineInputBorder _buildOutlineInputBorder(Color color, {double size = 20}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(size)),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  IconThemeData _buildIconThem(Color color, {double size = 25, double opacity = 1}){
    return IconThemeData(
        color: color,
        size: size,
        opacity: opacity
    );
  }

  BottomNavigationBarThemeData bottomNavigationBarTheme() => BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,//const Color(Assets.primaryGoldColor),
      selectedIconTheme: _buildIconThem(Colors.white),
      selectedLabelStyle: _buildTextStyle(Colors.white),

      unselectedItemColor: Colors.black, //const Color(Assets.primaryColor),
      unselectedIconTheme: _buildIconThem(Colors.black),
      unselectedLabelStyle: _buildTextStyle(Colors.black),

      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(Assets.primaryGoldColor),
  );
}