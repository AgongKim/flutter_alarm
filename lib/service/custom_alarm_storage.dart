import 'dart:convert';

import 'package:alarm/model/custom_alarm_data.dart';
import 'package:alarm/service/alarm_storage.dart';
import 'package:alarm/utils/times.dart';

class CustomAlarmStorage extends AlarmStorage {
  static const customPrefix = '__custom_alarm_id__';

  static List<CustomAlarmData> getSavedCustomAlarms() {
    final alarms = <CustomAlarmData>[];
    final keys = AlarmStorage.prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith(customPrefix)) {
        final res = AlarmStorage.prefs.getString(key);
        alarms.add(
          CustomAlarmData.fromJson(json.decode(res!) as Map<String, dynamic>),
        );
      }
    }
    return alarms;
  }

  static Future<void> saveCustomAlarm(CustomAlarmData data) =>
      AlarmStorage.prefs.setString('$customPrefix${data.id}', json.encode(data.toJson()));

  static bool hasId(int id) {
    return AlarmStorage.prefs.containsKey('${AlarmStorage.prefix}$id');
  }
}
