import 'package:calendar/blocs/event_bloc.dart';
import 'package:calendar/blocs/event_event.dart';
import 'package:calendar/blocs/event_state.dart';
import 'package:calendar/models/event_model.dart';
import 'package:calendar/screens/event_test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsEventPage extends StatefulWidget {
  final int? id;

  final Event event;

  const DetailsEventPage({super.key, required this.id, required this.event});

  @override
  State<DetailsEventPage> createState() => _DetailsEventPageState();
}

class _DetailsEventPageState extends State<DetailsEventPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.05),
        child: GestureDetector(
          onTap: () {
            context.read<EventBloc>().add(DeleteEvent(widget.event.id!));
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            height: 54,
            width: screenWidth * 0.85,
            decoration: BoxDecoration(
                color: const Color(0xffFEE8E9),
                border: Border.all(
                  color: const Color.fromARGB(255, 252, 223, 225),
                ),
                borderRadius: BorderRadius.circular(10)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: Color(0xffEE2B00),
                ),
                Text(
                  'Delete Event',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 100,
        leadingWidth: 110,
        leading: Padding(
          padding: const EdgeInsets.all(30.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () {
                // _editEvent(context, widget.event);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EventPage(),
                //   ),
                // );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: screenWidth,
            // height: screenHeight * 0.156,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.event.name}',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(
                    '${widget.event.description}',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.white,
                            size: 18,
                          ),
                          Text(
                            ' 17:00 - 18:30',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 18,
                          ),
                          Text(
                            '${widget.event.location}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: screenWidth * 0.80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '15 minutes befor',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff7C7B7B)),
                ),
                SizedBox(
                  height: 22,
                ),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' ${widget.event.description}',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff7C7B7B)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'event_bloc.dart';
// import 'event_event.dart';
// import 'event_state.dart';
// import 'event_model.dart';

void _editEvent(BuildContext context, Event event) {
  _showEventDialog(context, event: event);
}

void _showEventDialog(BuildContext context, {Event? event}) {
  final nameController = TextEditingController(text: event?.name ?? '');
  final descriptionController =
      TextEditingController(text: event?.description ?? '');
  final colorController =
      TextEditingController(text: event?.color.toRadixString(16) ?? '');
  final timeController = TextEditingController(text: event?.time ?? '');

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(event == null ? 'Add New Event' : 'Edit Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Event Description'),
            ),
            TextField(
              controller: colorController,
              decoration: InputDecoration(labelText: 'Priority Color (ARGB)'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Event Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newEvent = Event(
                id: event?.id,
                name: nameController.text,
                description: descriptionController.text,
                color: int.tryParse(colorController.text) ?? 0xFF000000,
                time: timeController.text,
                selectAllday: '',
                location: '',
              );

              if (event == null) {
                context.read<EventBloc>().add(AddEvent(newEvent));
              } else {
                context.read<EventBloc>().add(UpdateEvent(newEvent));
              }
              Navigator.of(context).pop();
            },
            child: Text(event == null ? 'Add' : 'Update'),
          ),
        ],
      );
    },
  );
}
