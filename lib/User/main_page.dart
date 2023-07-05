import 'package:cinema_new/User/profile_page.dart';
import 'package:cinema_new/User/reservation_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Billing_information.dart';
import 'Payment/Payment.dart';
import 'consts.dart';
import 'home_page.dart';
import 'how_many_tickets.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key); // Fix the constructor

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<IconData> bottomIcons = [Icons.home_filled, Icons.person_rounded];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Widget body() {
      switch (currentPage) {
        case 0:
          return const HomePage();
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
          return const ProfilePage(); // Display the payment page
        default:
          return Center(
            child: Text(
              'Something Wrong !!',
              style: font.copyWith(fontSize: 32, color: white),
            ),
          );
      }
    }

    return Scaffold(
      backgroundColor: black,
      body: body(),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            bottomIcons.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = index;
                });
              },
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: currentPage == index ? 24 : 0,
                    width: currentPage == index ? 24 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: white.withOpacity(.1),
                          spreadRadius: currentPage == index ? 5 : 0,
                          blurRadius: currentPage == index ? 5 : 0,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    bottomIcons[index],
                    color: currentPage == index ? white : white.withOpacity(.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
