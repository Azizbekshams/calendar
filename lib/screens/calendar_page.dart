import 'dart:math';

import 'package:calendar/blocs/event_bloc.dart';
import 'package:calendar/blocs/event_event.dart';
import 'package:calendar/blocs/event_state.dart';
import 'package:calendar/screens/add_event_page.dart';
import 'package:calendar/screens/details_event_page.dart';
import 'package:calendar/screens/event_test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int? selectedDay;
  String selectAllDay = '${DateTime.now()}';
  List eventfilterCalendar = [];

  final List<String> weekName = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<String> monthName = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.45,
                child: Column(
                  children: [
                    buildYearSelector(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          monthName[selectedMonth - 1],
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (selectedMonth == 1) {}
                                  setState(() {
                                    if (selectedMonth == 1) {
                                      selectedMonth == 0;
                                    } else {
                                      selectedMonth -= 1;
                                    }

                                    //     selectAllDay =
                                    // '${selectedDay == null ? DateTime.now().day : selectedDay}-$selectedMonth-$selectedYear';
                                  });
                                },
                                child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        Color.fromARGB(255, 227, 227, 227),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 12,
                                    ))),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  if (selectedMonth == 11) {}
                                  setState(() {
                                    if (selectedMonth == 11) {
                                      selectedMonth == 0;
                                    } else {
                                      selectedMonth += 1;
                                    }

                                    //     selectAllDay =
                                    // '${selectedDay == null ? DateTime.now().day : selectedDay}-$selectedMonth-$selectedYear';
                                  });
                                },
                                child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        Color.fromARGB(255, 227, 227, 227),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                    )))
                          ],
                        )
                      ],
                    ),
                    // buildMonthSelecter(
                    //     monthName: monthName, selectedMonth: selectedMonth),
                    buildWeekHeader(),
                    buildCalendarGrid(),
                  ],
                ),
              ),
              buildEventList(
                context,
                screenHeight,
                screenWidth,
                selectedMonth,
                selectedYear,
                selectedDay,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildMonthSelecter(
      {required List<String> monthName, required int selectedMonth}) {
    int ind = 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthName[selectedMonth - 1],
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Row(
          children: [
            GestureDetector(
                child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Color.fromARGB(255, 227, 227, 227),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 12,
                    ))),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedMonth += 1;
                  print('$selectedMonth');
                  //     selectAllDay =
                  // '${selectedDay == null ? DateTime.now().day : selectedDay}-$selectedMonth-$selectedYear';
                });
              },
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: Color.fromARGB(255, 227, 227, 227),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Column buildEventList(BuildContext context, double screenHeight,
      double screenWidth, selectedMonth, selectedYear, selectedDay) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Schedule',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // EventPage()
                        AddEventPage(selectAllDay: selectAllDay),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff009FEE),
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
                child: const Text(
                  '+Add event',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is EventLoaded) {
              final eventfilter = state.events
                  .where(
                    (element) => element.selectAllday == selectAllDay,
                  )
                  .toList();

              return SizedBox(
                height: screenHeight * 0.45,
                child: eventfilter.length == 0
                    ? Text('No Event yet')
                    : ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          eventfilter.length,
                          (index) {
                            var event = eventfilter[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsEventPage(
                                          id: event.id, event: event)),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                width: screenWidth,
                                height: screenHeight * 0.13,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(204, 229, 244, 1)),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 14,
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                          color: Color(0xff009fee),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${event.name}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff056EA1),
                                                fontSize: 14),
                                          ),
                                          Text(
                                            '${event.description}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff056EA1),
                                                fontSize: 8),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_filled,
                                                        color:
                                                            Color(0xff056EA1),
                                                        size: 18,
                                                      ),
                                                      Text(
                                                        '${event.time}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff056EA1),
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color:
                                                            Color(0xff056EA1),
                                                        size: 18,
                                                      ),
                                                      Text(
                                                        '${event.location}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff056EA1),
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 0,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              );
            } else if (state is EventError) {
              return Center(
                  child: Text('Failed to load events: ${state.message}'));
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        )
      ],
    );
  }

  Widget buildYearSelector() {
    return DropdownButton<int>(
      underline: SizedBox(),
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: 15,
      ),
      value: selectedYear,
      items: List.generate(2951 - 1950, (index) => 1950 + index)
          .map((year) => DropdownMenuItem(
                value: year,
                child: Text(
                  '${selectedDay == null ? DateTime.now().day : selectedDay} ${monthName[selectedMonth - 1]} ${year.toString()}',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value!;
          selectAllDay =
              '${selectedDay == null ? DateTime.now().day : selectedDay}-$selectedMonth-$selectedYear';
        });
      },
    );
  }

  Widget buildMonthSelector() {
    return DropdownButton<int>(
      value: selectedMonth,
      items: List.generate(12, (index) => index + 1)
          .map((month) => DropdownMenuItem(
                value: month,
                child: Text(monthName[month - 1]),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedMonth = value!;
        });
      },
    );
  }

  Widget buildWeekHeader() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: weekName.map((day) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCalendarGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(selectedYear, selectedMonth);
    final firstDayOfWeek = DateTime(selectedYear, selectedMonth, 1).weekday;

    return Expanded(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: daysInMonth + firstDayOfWeek - 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemBuilder: (context, index) {
          if (index < firstDayOfWeek - 1) {
            return Container();
          } else {
            final day = index - firstDayOfWeek + 2;
            final isSelected =
                day == (selectedDay == null ? DateTime.now().day : selectedDay);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = day;
                  selectAllDay =
                      '${selectedDay == null ? DateTime.now().day : selectedDay}-$selectedMonth-$selectedYear';
                });
                // Implement date selection logic
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  // color: isSelected ? Colors.blue : Colors.transparent,

                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: Colors.grey),
                  // borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          isSelected ? Colors.blue : Colors.transparent,
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    // BlocBuilder<EventBloc, EventState>(
                    //   builder: (context, state) {
                    //     if (state is EventLoading) {
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     } else if (state is EventLoaded) {
                    //       print(' yyy ${state.events}');
                    //       // final eventfilter = state.events
                    //       //     .where(
                    //       //       (element) => element.selectAllday == day,
                    //       //     )
                    //       //     .toList();
                    //       return Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           CircleAvatar(
                    //             radius: 2,
                    //             // child: Text(
                    //             //     '${state.events[0].selectAllday == day ? 'a' : "b"}'),
                    //           )
                    //         ],
                    //       );
                    //     } else if (state is EventError) {
                    //       return Center(
                    //           child: Text(
                    //               'Failed to load events: ${state.message}'));
                    //     } else {
                    //       return Center(child: Text('Unknown state'));
                    //     }
                    //   },
                    // )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
