import 'package:calendar/core/local_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final LocalDatabase localDatabase;

  EventBloc({required this.localDatabase}) : super(EventLoading()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    try {
      final events = await localDatabase.readAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to load events'));
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EventState> emit) async {
    if (state is EventLoaded) {
      try {
        await localDatabase.create(event.event);
        final events = await localDatabase.readAllEvents();
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError('Failed to add event'));
      }
    }
  }

  Future<void> _onUpdateEvent(
      UpdateEvent event, Emitter<EventState> emit) async {
    if (state is EventLoaded) {
      try {
        await localDatabase.update(event.event);
        final events = await localDatabase.readAllEvents();
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError('Failed to update event'));
      }
    }
  }

  Future<void> _onDeleteEvent(
      DeleteEvent event, Emitter<EventState> emit) async {
    if (state is EventLoaded) {
      try {
        await localDatabase.delete(event.id);
        final events = await localDatabase.readAllEvents();
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError('Failed to delete event'));
      }
    }
  }
}
