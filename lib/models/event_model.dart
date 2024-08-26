import 'package:calendar/core/local_database.dart';
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final int? id;
  final String name;
  final String location;
  final String selectAllday;
  final String description;
  final int color; // Store color as an integer value (ARGB)
  final String time;

  const Event({
    this.id,
    required this.name,
    required this.selectAllday,
    required this.location,
    required this.description,
    required this.color,
    required this.time,
  });

  Event copy({
    int? id,
    String? name,
    String? selectAllday,
    String? location,
    String? description,
    int? color,
    String? time,
  }) =>
      Event(
        id: id ?? this.id,
        name: name ?? this.name,
        selectAllday: selectAllday ?? this.selectAllday,
        location: location ?? this.location,
        description: description ?? this.description,
        color: color ?? this.color,
        time: time ?? this.time,
      );

  static Event fromJson(Map<String, Object?> json) => Event(
        id: json[EventFields.id] as int?,
        name: json[EventFields.name] as String,
        location: json[EventFields.location] as String,
        selectAllday: json[EventFields.selectAllday] as String,
        description: json[EventFields.description] as String,
        color: json[EventFields.color] as int,
        time: json[EventFields.time] as String,
      );

  Map<String, Object?> toJson() => {
        EventFields.id: id,
        EventFields.name: name,
        EventFields.selectAllday: selectAllday,
        EventFields.location: location,
        EventFields.description: description,
        EventFields.color: color,
        EventFields.time: time,
      };

  @override
  List<Object?> get props => [id, name, description, color, time, selectAllday];
}
