import 'package:flutter/material.dart';
import 'package:alarm/utils/times.dart';


enum AlarmType {
  single,
  period
}
extension AlarmTypeExtension on AlarmType {
  static AlarmType fromString(String type) {
    switch (type) {
      case 'single':
        return AlarmType.single;
      case 'period':
        return AlarmType.period;
      default:
        throw Exception('Unknown AlarmType: $type');
    }
  }
  String toShortString() {
    return toString().split('.').last;
  }
}


@immutable
class CustomAlarmData {
  final int id;
  final AlarmType type;
  final List<int> days;
  final DateTime dateTime;
  final String assetAudioPath;
  final String notificationTitle;
  final String notificationBody;
  final bool vibrate;
  final double? volume;
  final DateTime createdTime;

  const CustomAlarmData._internal({
    required this.id,
    required this.type,
    required this.days,
    required this.dateTime,
    required this.assetAudioPath,
    required this.notificationTitle,
    required this.notificationBody,
    this.vibrate = true,
    this.volume,
    required this.createdTime,
  });

// factory 생성자 사용
  factory CustomAlarmData({
    required int id,
    required AlarmType type,
    required List<int> days,
    required DateTime dateTime,
    required String assetAudioPath,
    required String notificationTitle,
    required String notificationBody,
    bool vibrate = true,
    double? volume = 0.75,
  }) {
    return CustomAlarmData._internal(
      id: id,
      type: type,
      days: days,
      dateTime: dateTime,
      assetAudioPath: assetAudioPath,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
      vibrate: vibrate,
      volume: volume,
      createdTime: DateTime.now(), // 런타임에 생성 시간 설정
    );
  }

  factory CustomAlarmData.fromJson(Map<String, dynamic> json) => CustomAlarmData(
    id: json['id'] as int,
    type: AlarmTypeExtension.fromString(json['type']),
    days: (json['days'] as List<dynamic>).map((e) => e as int).toList(),
    dateTime: DateTime.fromMicrosecondsSinceEpoch(json['dateTime'] as int),
    assetAudioPath: json['assetAudioPath'] as String,
    notificationTitle: json['notificationTitle'] as String? ?? '',
    notificationBody: json['notificationBody'] as String? ?? '',
    vibrate: json['vibrate'] as bool? ?? true,
    volume: json['volume'] as double?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toShortString(),
    'days': days,
    'dateTime': dateTime.microsecondsSinceEpoch,
    'assetAudioPath': assetAudioPath,
    'notificationTitle': notificationTitle,
    'notificationBody': notificationBody,
    'vibrate': vibrate,
    'volume': volume,
  };

  List<int> getAlarmIds() {
    //미래의 알람들만 카운트 (지난 알림은 끄면 지워짐)
    List<DateTime> datetimes = getMatchingDatesWithTime(days, dateTime.hour, dateTime.minute);
    return datetimes.map((elem) => createAlarmId(elem)).toList();
  }
  @override
  String toString() {
    final json = toJson();
    json['dateTime'] =
        DateTime.fromMicrosecondsSinceEpoch(json['dateTime'] as int);

    return 'CustomAlarmData: $json';
  }

// List<int> makeAlarms(CustomAlarmData data) {
//   List<int> alarmSettingIds = [];
//   if (data.type.toString() == 'period') {
//     List<DateTime> datetimes = getMatchingDatesWithTime(days, timeOfDay.hour, timeOfDay.minute);
//     for (var d in datetimes) {
//       final alarmSettingId = createAlarmId(d);
//       alarmSettingIds.add(alarmSettingId);
//       if (!AlarmStorage.prefs.containsKey('$AlarmStorage.prefix$alarmSettingId')) {
//         Alarm.set(
//           alarmSettings: AlarmSettings(
//             id: alarmSettingId,
//             dateTime: d,
//             loopAudio: true,
//             vibrate: vibrate,
//             volume: volume,
//             assetAudioPath: assetAudioPath,
//             enableNotificationOnKill: Platform.isIOS,
//             notificationTitle: 'Alarm example',
//             notificationBody: 'Your alarm ($id) is ringing',
//           )
//         );
//       }
//     }
//   }
//   else{
//     if (!AlarmStorage.prefs.containsKey('$AlarmStorage.prefix$alarmSettingId')) {
//       Alarm.set(
//           alarmSettings: AlarmSettings(
//             id: alarmSettingId,
//             dateTime: d,
//             loopAudio: true,
//             vibrate: vibrate,
//             volume: volume,
//             assetAudioPath: assetAudioPath,
//             enableNotificationOnKill: Platform.isIOS,
//             notificationTitle: 'Alarm example',
//             notificationBody: 'Your alarm ($id) is ringing',
//           )
//       );
//     }
//   }
// }
}