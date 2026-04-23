import 'package:isar/isar.dart';

part 'reminder.g.dart';

@collection
class Reminder {
  Id id = Isar.autoIncrement;

  late String title;
  String? description;

  late int hour;
  late int minute;

  @enumerated
  late ReminderFrequency frequency;

  List<int>? repeatDays; // 1 = Lunes, 7 = Domingo

  bool isEnabled = true;

  @enumerated
  FulfillmentStatus fulfillmentStatus = FulfillmentStatus.neutral;

  DateTime? lastExecuted;
  DateTime? nextExecution;
}

enum ReminderFrequency { once, daily, weekly, custom }

enum FulfillmentStatus { neutral, happy, sad }
