import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/features/homepage/presentation/pages/home_page.dart';
import 'package:ecommerce_app/features/notification/presentation/pages/notification_page.dart';
import 'package:ecommerce_app/features/order/presentation/pages/order_page.dart';
import 'package:ecommerce_app/features/userdetails/presentation/pages/userdetails_page.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  final List<Widget> _pages = [
    HomePage(),
    NotificationPage(),
    OrderPage(),
    UserdetailsPage(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/home.png", height: 27, width: 27),
            activeIcon: Text(
              "Home",
              style: TextStyle(color: AppcolorPallets.primaryColor),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/noti4.png", height: 33, width: 33,color: Colors.grey.shade500,),
            activeIcon: Text(
              "Notification",
              style: TextStyle(color: AppcolorPallets.primaryColor),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/cart.png", height: 27, width: 27),
            activeIcon: Text(
              "Orders",
              style: TextStyle(color: AppcolorPallets.primaryColor),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/address_1.png",
              height: 32,
              width: 32,
            ),
            activeIcon: Text(
              "Address",
              style: TextStyle(color: AppcolorPallets.primaryColor),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
