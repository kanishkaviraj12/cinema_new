import 'package:cinema_new/User/Billing_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/seats_model.dart';
import '../widgets/seat_status.dart';
import 'consts.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final items = List<DateTime>.generate(15, (index) {
    return DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: index));
  });

  DateTime selectedTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: white,
              size: 20,
            ),
          ),
          title: Text(
            'Select Seats',
            style: font.copyWith(fontSize: 14, color: white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          //scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 0,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                          height: 60,
                          child: Stack(
                            children: [
                              Positioned(
                                top: -5,
                                width: MediaQuery.of(context).size.width - 60,
                                child: ClipPath(
                                  clipper: Clip2(),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                          const Color.fromARGB(255, 0, 140, 5)
                                              .withOpacity(0.3),
                                          transparent
                                        ],
                                            stops: const [
                                          0.35,
                                          1.0
                                        ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -10,
                                width: MediaQuery.of(context).size.width - 60,
                                child: ClipPath(
                                  clipper: Clip(),
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    color:
                                        const Color.fromARGB(255, 23, 81, 24),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          ...List.generate(numRow.length, (colIndex) {
                            int numCol =
                                colIndex == 0 || colIndex == numRow.length - 1
                                    ? 6
                                    : 8;
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      colIndex == numRow.length - 1 ? 0 : 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...List.generate(numCol, (rowIndex) {
                                    String seatNum =
                                        '${numRow[colIndex]}${rowIndex + 1}';
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedSeats.contains(seatNum)) {
                                            selectedSeats.remove(seatNum);
                                          } else if (!reservedSeats
                                              .contains(seatNum)) {
                                            selectedSeats.add(seatNum);
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        margin: EdgeInsets.only(
                                            right: rowIndex == (numCol / 2) - 1
                                                ? 30
                                                : 10),
                                        decoration: BoxDecoration(
                                            color:
                                                reservedSeats.contains(seatNum)
                                                    ? white
                                                    : selectedSeats
                                                            .contains(seatNum)
                                                        ? const Color.fromARGB(
                                                            255, 0, 142, 5)
                                                        : grey,
                                            borderRadius:
                                                BorderRadius.circular(7.5)),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SeatStatus(
                            color: grey,
                            status: 'Available',
                          ),
                          SizedBox(width: 10),
                          SeatStatus(
                            color: Color.fromARGB(255, 0, 145, 5),
                            status: 'Selected',
                          ),
                          SizedBox(width: 10),
                          SeatStatus(
                            color: white,
                            status: 'Reserved',
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 35),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [black, grey],
                            stops: [0.5, 1],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Select Date and Time',
                              style: font.copyWith(
                                  color: white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 35),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(
                                      items.length,
                                      (index) => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedTime = items[index];
                                              });
                                            },
                                            child: Container(
                                              margin: index == 0
                                                  ? const EdgeInsets.only(
                                                      left: 20, right: 20)
                                                  : const EdgeInsets.only(
                                                      right: 20),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 12, 8, 8),
                                              decoration: BoxDecoration(
                                                  color: DateFormat('d/M/y')
                                                              .format(
                                                                  selectedTime) ==
                                                          DateFormat('d/M/y')
                                                              .format(
                                                                  items[index])
                                                      ? const Color.fromRGBO(
                                                          0, 120, 4, 1)
                                                      : grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    DateFormat('MMM')
                                                        .format(items[index]),
                                                    style: font.copyWith(
                                                        fontSize: 14,
                                                        color: white),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: DateFormat(
                                                                        'd/M/y')
                                                                    .format(
                                                                        selectedTime) ==
                                                                DateFormat(
                                                                        'd/M/y')
                                                                    .format(items[
                                                                        index])
                                                            ? white
                                                            : transparent),
                                                    child: Text(
                                                      DateFormat('dd')
                                                          .format(items[index]),
                                                      style: font.copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: DateFormat(
                                                                          'd/M/y')
                                                                      .format(
                                                                          selectedTime) ==
                                                                  DateFormat(
                                                                          'd/M/y')
                                                                      .format(items[
                                                                          index])
                                                              ? black
                                                              : white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 35),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(
                                      availableTime.length,
                                      (index) => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedTime = DateTime.utc(
                                                  selectedTime.year,
                                                  selectedTime.month,
                                                  selectedTime.day,
                                                  int.parse(availableTime[index]
                                                      .split(':')[0]),
                                                  int.parse(availableTime[index]
                                                      .split(':')[1]),
                                                );
                                              });
                                            },
                                            child: Container(
                                                margin: index == 0
                                                    ? const EdgeInsets.only(
                                                        left: 20, right: 20)
                                                    : const EdgeInsets.only(
                                                        right: 20),
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    color: grey,
                                                    border: Border.all(
                                                        width: 2,
                                                        color: DateFormat('HH:mm')
                                                                    .format(
                                                                        selectedTime)
                                                                    .toString() ==
                                                                availableTime[
                                                                    index]
                                                            ? const Color.fromARGB(
                                                                255, 0, 139, 5)
                                                            : transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                  availableTime[index],
                                                  style: font.copyWith(
                                                      fontSize: 14,
                                                      color: white),
                                                )),
                                          )),
                                ],
                              ),
                            ),
                            selectedSeats.isNotEmpty
                                ? Column(
                                    children: [
                                      const SizedBox(height: 35),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total Price',
                                                  style: font.copyWith(
                                                      color: white,
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'LKR ${(selectedSeats.length * 450.00).toStringAsFixed(2)}',
                                                  style: font.copyWith(
                                                      color: white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 50),
                                            Expanded(
                                              child: MaterialButton(
                                                onPressed: () {
                                                  String selectedTimeString =
                                                      DateFormat('h:mm a')
                                                          .format(selectedTime);
                                                  print(
                                                      'Selected Time: $selectedTimeString');

                                                  String selectedDateString =
                                                      DateFormat('d/M/y')
                                                          .format(selectedTime);
                                                  print(
                                                      'Selected Date: $selectedDateString');

                                                  double totalPrice =
                                                      selectedSeats.length *
                                                          450.00;

                                                  // Get the current user's ID (assuming you have authentication implemented)
                                                  String userId =
                                                      getCurrentUserId(); // Replace with your own logic to get the user ID

                                                  // Create a Firestore instance
                                                  FirebaseFirestore firestore =
                                                      FirebaseFirestore
                                                          .instance;

                                                  // Create a new document in the "reservations" collection
                                                  firestore
                                                      .collection(
                                                          'reservations')
                                                      .add({
                                                    'user_id': userId,
                                                    'selected_seats':
                                                        selectedSeats,
                                                    'selected_Time':
                                                        selectedTimeString,
                                                    'selected_Date':
                                                        selectedDateString,
                                                    'total_Price': totalPrice,
                                                  }).then((value) {
                                                    // Reservation stored successfully
                                                    print(
                                                        'Reservation stored in Firestore: ${value.id}');
                                                  }).catchError((error) {
                                                    // Error storing reservation
                                                    print(
                                                        'Failed to store reservation: $error');
                                                  });
                                                  if (selectedSeats
                                                      .isNotEmpty) {
                                                    // Show SnackBar with success message
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'successfully! Now you are directly billing page'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                      ),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BillingInformation(),
                                                      ),
                                                    );
                                                  } else {
                                                    // Show an error message if no seats are selected
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Please select at least one seat.'),
                                                      ),
                                                    );
                                                  }
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                color: const Color.fromARGB(
                                                    255, 0, 154, 5),
                                                height: 66,
                                                child: Center(
                                                  child: Text(
                                                    'Book Ticket',
                                                    style: font.copyWith(
                                                        color: white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    height: 0,
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class Clip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -20, size.width, size.height);
    path.lineTo(size.width, size.height - 5);
    path.quadraticBezierTo(size.width / 2, -25, 0, size.height - 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Clip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - 30);
    path.quadraticBezierTo(size.width / 2, -20, 0, size.height - 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

String getCurrentUserId() {
  // Get the current user from Firebase Authentication
  User? user = FirebaseAuth.instance.currentUser;

  // Check if the user is authenticated
  if (user != null) {
    // Return the user's ID
    return user.uid;
  } else {
    // Return an empty string or handle the case when the user is not authenticated
    return '';
  }
}
