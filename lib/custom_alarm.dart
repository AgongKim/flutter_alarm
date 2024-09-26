import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/custom_alarm_data.dart';
import 'package:alarm/service/custom_alarm_storage.dart';
import 'package:alarm/utils/alarm_exception.dart';


/// 반복알람등을위해 Alarm클래스를 wrapping한 클래스
class CustomAlarm extends Alarm {
  static Future<void> init({bool showDebugLogs = true}) async {
    // CustomAlarm만의 초기화 로직 추가 가능
    await Alarm.init(showDebugLogs: showDebugLogs); // 부모 클래스의 init 호출
  }

  static List<CustomAlarmData> getCustomAlarms() => CustomAlarmStorage.getSavedCustomAlarms();

  /// Validates [alarmSettings] fields.
  static void customAlarmDataValidation(CustomAlarmData customAlarmData) {
    if (customAlarmData.id == 0 || customAlarmData.id == -1) {
      throw AlarmException(
        'Alarm id cannot be 0 or -1. Provided: ${customAlarmData.id}',
      );
    }
    if (customAlarmData.id > 2147483647) {
      throw AlarmException(
        '''Alarm id cannot be set larger than Int max value (2147483647). Provided: ${customAlarmData.id}''',
      );
    }
    if (customAlarmData.id < -2147483648) {
      throw AlarmException(
        '''Alarm id cannot be set smaller than Int min value (-2147483648). Provided: ${customAlarmData.id}''',
      );
    }
    if (customAlarmData.volume != null && (customAlarmData.volume! < 0 || customAlarmData.volume! > 1)) {
      throw AlarmException(
        'Volume must be between 0 and 1. Provided: ${customAlarmData.volume}',
      );
    }
  }

  /// CustomAlarm객체를 저장하는 메소드
  static Future<bool> setCustomAlarm({required CustomAlarmData data}) async {
    customAlarmDataValidation(data);

    for (final alarm in CustomAlarm.getCustomAlarms()) {
      if (alarm.id == data.id) {
        throw AlarmException('CustomAlarm has same id');
      }
    }

    await CustomAlarmStorage.saveCustomAlarm(data);

    if (data.type == AlarmType.single) {
      int id = createAlarmId(data.dateTime);
      while (CustomAlarmStorage.hasId(id)) {
        id = createAlarmId(data.dateTime);
      }
      Alarm.set(
          alarmSettings: AlarmSettings(
        id: createAlarmId(data.dateTime),
        dateTime: data.dateTime,
        loopAudio: true,
        vibrate: data.vibrate,
        volume: data.volume,
        assetAudioPath: data.assetAudioPath,
        enableNotificationOnKill: Platform.isIOS,
        notificationTitle: 'Alarm example',
        notificationBody: 'Your alarm (${data.dateTime}) is ringing',
      ));
      return true;
    } else {
      //반복타입 TODO
      return true;
    }

    return false;
  }

  /// CustomAlarm객체를 지우는 메소드
  static Future<bool> deleteCustomAlarm({required int id}) async {
    return false;
  }

  static List<AlarmSettings> getAlarms() {
    return Alarm.getAlarms();
  }

  static Future<bool> stop(int id) async {
    return Alarm.stop(id);
  }
}
