import 'package:calendar/blocs/event_bloc.dart';
import 'package:calendar/blocs/event_event.dart';
import 'package:calendar/blocs/event_state.dart';
import 'package:calendar/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Manager'),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text(event.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<EventBloc>().add(DeleteEvent(event.id!));
                    },
                  ),
                  onTap: () {
                    _editEvent(context, event);
                  },
                );
              },
            );
          } else if (state is EventError) {
            return Center(
                child: Text('Failed to load events: ${state.message}'));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addNewEvent(context);
        },
      ),
    );
  }

  void _addNewEvent(BuildContext context) {
    _showEventDialog(context);
  }

  void _editEvent(BuildContext context, Event event) {
    _showEventDialog(context, event: event);
  }

  void _showEventDialog(BuildContext context, {Event? event}) {
    final nameController = TextEditingController(text: event?.name ?? '');
    final descriptionController =
        TextEditingController(text: event?.description ?? '');
    final locationController = TextEditingController(text: event?.location);
    final colorController =
        TextEditingController(text: event?.color.toRadixString(16) ?? '');
    final _priorityColorController =
        TextEditingController(text: '${event?.color}');
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
                   color: 0xFF000000,
                  time: '${DateTime.now()}',
                  selectAllday: '${event?.selectAllday}',
                 location: locationController.text,
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
}
