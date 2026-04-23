import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/reminder.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [ReminderSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveReminder(Reminder reminder) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.reminders.putSync(reminder));
  }

  Future<List<Reminder>> getAllReminders() async {
    final isar = await db;
    return await isar.reminders.where().findAll();
  }

  Future<void> deleteReminder(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.reminders.delete(id));
  }

  Future<void> clearDatabase() async {
    final isar = await db;
    await isar.writeTxn(() => isar.reminders.clear());
  }

  Stream<List<Reminder>> listenToReminders() async* {
    final isar = await db;
    yield* isar.reminders.where().watch(fireImmediately: true);
  }
}
