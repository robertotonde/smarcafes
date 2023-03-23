import 'package:smartcafes/utls/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyBottomNavigationBar extends StatefulWidget {
  int selectedIndex;
  void Function(int)? onTap;
  final List<Widget> screenOptions;
  MyBottomNavigationBar(
      {Key? key,
      required this.screenOptions,
      required this.selectedIndex,
      required this.onTap})
      : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: white.withOpacity(0.2),
      selectedItemColor: const Color(0xff2ec2f0),
      unselectedItemColor: white.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_rounded),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_rounded),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_rounded),
          label: 'My Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'My Account',
        ),
      ],
      onTap: widget.onTap,
      currentIndex: widget.selectedIndex,
    );
  }
}
