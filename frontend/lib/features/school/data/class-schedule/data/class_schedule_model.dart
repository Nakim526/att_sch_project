import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/utils/extensions/string_extension.dart';
import 'package:flutter/material.dart';

class ClassScheduleModel {
  final String? id;
  final String? teachingAssignmentId;
  String day;
  final String startTime;
  final String endTime;
  final String? room;

  ClassScheduleModel({
    this.id,
    this.teachingAssignmentId,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.room,
  });

  factory ClassScheduleModel.fromJson(Map<String, dynamic> json) {
    return ClassScheduleModel(
      id: json['id'],
      teachingAssignmentId: json['teachingAssignmentId'],
      day: json['dayOfWeek'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      room: json['room'],
    );
  }

  static ClassScheduleModel fromMap(Map<String, dynamic> map) {
    return ClassScheduleModel(
      id: map['id'],
      day: map['day'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      room: map['room'],
    );
  }

  static List<ClassScheduleModel> fromForm({
    required List<Map<String, dynamic>?> days,
    required List<TextEditingController> startTime,
    required List<TextEditingController> endTime,
    required List<TextEditingController> room,
  }) {
    List<ClassScheduleModel> result = [];

    for (int i = 0; i < days.length; i++) {
      result.add(
        ClassScheduleModel(
          day: days[i]?['name'],
          startTime: startTime[i].text,
          endTime: endTime[i].text,
          room: room[i].text,
        ),
      );
    }

    return result;
  }

  String get time_ => '$startTime - $endTime';

  Map<String, dynamic> toJson() => {
    'dayOfWeek': AppItems.dayOfWeek[day],
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
  };

  String get day_ {
    normalized = day;
    return day;
  }

  set normalized(_) {
    final keys = AppItems.dayOfWeek.keys;
    final value = keys.firstWhere(
      (e) => AppItems.dayOfWeek[e] == day,
      orElse: () => day,
    );

    day = value.capitalizeEachWord();
  }

  Map<String, dynamic> get dayToForm {
    normalized = day;
    return {'id': day.toLowerCase(), 'name': day.toUpperCase()};
  }

  TextEditingController get startTimeToForm =>
      TextEditingController(text: startTime);

  TextEditingController get endTimeToForm =>
      TextEditingController(text: endTime);

  TextEditingController get roomToForm => TextEditingController(text: room);
}
