import 'package:cinema_new/Admin/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../User/consts.dart';
import 'Add_movie.dart';
import 'add_theater.dart';

import 'history_of_customer.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<IconData> bottomIcons = [
    Icons.movie,
    CupertinoIcons.building_2_fill,
    CupertinoIcons.arrow_counterclockwise_circle,
    Icons.person_rounded,
    Icons.person_2
  ];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    Widget body() {
      switch (currentPage) {
        case 0:
          return const MoviesPage(
           
          );
        case 1:
          return const addtheater();
        case 2:
          return const HistoryOfCustomer();
        case 3:
          return Center(
            child: Text(
              'Profile Page',
              style: font.copyWith(fontSize: 32, color: white),
            ),
          );
        case 4:
          //return MyApp();
        default:
          return Center(
              child: Text(
            'Something Wrong !!',
            style: font.copyWith(fontSize: 32, color: white),
          ));
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
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                                color: white.withOpacity(.1),
                                spreadRadius: currentPage == index ? 5 : 0,
                                blurRadius: currentPage == index ? 5 : 0)
                          ]),
                        ),
                        Icon(
                          bottomIcons[index],
                          color: currentPage == index
                              ? white
                              : white.withOpacity(.3),
                        ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
