import 'package:flutter/material.dart';


String convertDay(int i) {
  switch (i) {
    case 0:
      return "월";
    case 1:
      return "화";
    case 2:
      return "수";
    case 3:
      return "목";
    case 4:
      return "금";
    case 5:
      return "토";
    case 6:
      return "일";
    default:
      return "";
  }
}

String countDay(List<bool> _days) {
  String cntDay = "";
  for (int i = 0; i < 7; i++) {
    if (_days[i] == true) {
      if (cntDay != "") cntDay += ", ";
      cntDay += convertDay(i);
    }
  }
  if (!_days.contains(false)) cntDay = "매일";
  return cntDay;
}

int compareTo(TimeOfDay time, TimeOfDay other) {
  final int hourComparison = time.hour.compareTo(other.hour);
  return hourComparison == 0 ? time.minute.compareTo(other.minute) : hourComparison;
}

String minutesToTimeString(int minutes){
  return '${(minutes / 60).floor().toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
}

int timeOfDayToInt(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

TimeOfDay intToTimeOfDay(int totalMinutes) {
  int hour = totalMinutes ~/ 60; // 시간 구하기
  int minute = totalMinutes % 60; // 분 구하기
  return TimeOfDay(hour: hour, minute: minute);
}

extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    if (this.hour < other.hour) {
      return true;
    } else if (this.hour == other.hour && this.minute < other.minute) {
      return true;
    }
    return false;
  }

  bool isAfter(TimeOfDay other) {
    if (this.hour > other.hour) {
      return true;
    } else if (this.hour == other.hour && this.minute > other.minute) {
      return true;
    }
    return false;
  }
}

List<DateTime> getMatchingDatesWithTime(List<int> weekdays, int hour, int minute, {int maxDays=30}) {
  DateTime now = DateTime.now();  // 현재 날짜와 시간
  List<DateTime> matchingDates = [];
  for (int i = 0; i <= maxDays; i++) {
    DateTime currentDate = now.add(Duration(days: i));  // 현재 날짜부터 maxDays까지 날짜를 순회
    // 요일이 일치하는지 확인
    if (weekdays.contains(currentDate.weekday)) {
      DateTime dateTimeWithTime = DateTime(currentDate.year, currentDate.month, currentDate.day, hour, minute);
      // 현재 시간보다 이른 경우 같은 날의 해당 시간을 사용
      if (i == 0 && now.isAfter(dateTimeWithTime)) {
        continue;  // 만약 오늘인데 현재 시간이 입력 시간 이후면, 오늘의 해당 시간을 건너뜀
      }
      matchingDates.add(dateTimeWithTime);
    }
  }

  return matchingDates;
}

int createAlarmId(DateTime datetime){
  return DateTime.now().millisecondsSinceEpoch % 10000 + 1;
}