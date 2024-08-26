import 'package:calendar/blocs/event_bloc.dart';
import 'package:calendar/blocs/event_event.dart';
import 'package:calendar/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddEventPage extends StatefulWidget {
  final String selectAllDay;

  const AddEventPage({super.key, required this.selectAllDay});
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  String _eventName = '';
  String _eventDescription = '';
  String _eventLocation = '';
  Color _priorityColor = Colors.red;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priorityColorController = TextEditingController();
  TimeOfDay _eventTime = TimeOfDay.now();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priorityColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: screenWidth * 0.9,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            backgroundColor: WidgetStatePropertyAll(
              Color(0xff009FEE),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              // Handle form submission

              final event = Event(
                location: _eventLocation,
                name: _nameController.text,
                description: _descriptionController.text,
                color: 0xFF000000,
                time: '${DateTime.now()}',
                selectAllday: '${widget.selectAllDay}',
              );

              context.read<EventBloc>().add(AddEvent(event));
              Navigator.of(context).pop();
              print('Event Name: ${widget.selectAllDay.length}');
              print('Event Description: $_eventDescription');
              print('Event Location: $_eventLocation');
              print('Priority Color: $_priorityColor');
              print('Event Time: $_eventTime');
            }
          },
          child: Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 50, left: 18, right: 18, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(241, 242, 245, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Event Name '),
                  onSaved: (value) {
                    _eventName = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 2, // Minimum height
                  maxLines: 4, // Maximum height
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(241, 242, 245, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Event Description',
                  ),
                  onSaved: (value) {
                    _eventDescription = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event description';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Event Location',
                    filled: true,
                    fillColor: Color.fromRGBO(241, 242, 245, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSaved: (value) {
                    _eventLocation = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Priority Color:',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickColor(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 242, 245, 1),
                            borderRadius: BorderRadius.circular(8)),
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: _priorityColor,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.blue,
                              size: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event time:',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => _pickTime(context),
                      child: Container(
                        padding: EdgeInsets.only(left: 12),
                        width: screenWidth,
                        alignment: Alignment.centerLeft,
                        height: 54,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 242, 245, 1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('${_eventTime.format(context)}'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickColor(BuildContext context) async {
    Color? pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Priority Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _priorityColor,
              onColorChanged: (Color color) {
                setState(() {
                  _priorityColor = color;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
    if (pickedColor != null) {
      setState(() {
        _priorityColor = pickedColor;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _eventTime,
    );
    if (picked != null && picked != _eventTime) {
      setState(() {
        _eventTime = picked;
      });
    }
  }
}
