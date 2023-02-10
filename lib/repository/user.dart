import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  const User(
      {required this.id,
      required this.ip,
      required this.name,
      required this.password,
      required this.permission,
      required this.email,
      required this.mobile,
      required this.tel,
      required this.ext,
      required this.bookmarks,
      required this.isActivate,
      required this.account,
      this.severityColors = const [
        0xff6c757d, //notice background color
        0xff28a745, //normal background color
        0xffffc107, //warning background color
        0xffdc3545, //critical background color
        0xffffffff, //notice font color
        0xffffffff, //normal font color
        0xff000000, //warning font color
        0xffffffff, //critical font color,
      ],
      this.alarmSoundEnableValues = const [
        false, // activate alarm
        false, // AlarmType.notice
        false, // AlarmType.normal
        false, // AlarmType.warning
        false, // AlarmType.critical
      ]});

  const User.empty()
      : this(
          id: '-',
          ip: '-',
          name: '-',
          password: '-',
          permission: '-',
          email: '-',
          mobile: '-',
          tel: '-',
          ext: '-',
          bookmarks: const [],
          isActivate: false,
          account: '-',
          severityColors: const [],
          alarmSoundEnableValues: const [],
        );

  @HiveField(0, defaultValue: '-')
  final String id;

  @HiveField(1, defaultValue: '-')
  final String ip;

  @HiveField(2, defaultValue: '-')
  final String name;

  @HiveField(3, defaultValue: '-')
  final String password;

  @HiveField(4, defaultValue: '-')
  final String permission;

  @HiveField(5, defaultValue: '-')
  final String email;

  @HiveField(6, defaultValue: '-')
  final String mobile;

  @HiveField(7, defaultValue: '-')
  final String tel;

  @HiveField(8, defaultValue: '-')
  final String ext;

  @HiveField(9, defaultValue: [])
  final List<DeviceMeta> bookmarks;

  @HiveField(10, defaultValue: false)
  final bool isActivate;

  @HiveField(11, defaultValue: '-')
  final String account;

  @HiveField(12, defaultValue: [
    0xff6c757d, //notice background color
    0xff28a745, //normal background color
    0xffffc107, //warning background color
    0xffdc3545, //critical background color
    0xffffffff, //notice font color
    0xffffffff, //normal font color
    0xff000000, //warning font color
    0xffffffff, //critical font color
  ])
  final List<int> severityColors;

  @HiveField(13, defaultValue: [
    false, // activate alarm
    false, // AlarmType.notice
    false, // AlarmType.normal
    false, // AlarmType.warning
    false, // AlarmType.critical
  ])
  final List<bool> alarmSoundEnableValues;
}

@HiveType(typeId: 2)
class DeviceMeta {
  const DeviceMeta({
    required this.id,
    required this.name,
    required this.type,
    required this.ip,
    required this.shelf,
    required this.slot,
    required this.path,
  });

  @HiveField(0, defaultValue: -1)
  final int id;

  @HiveField(1, defaultValue: '-')
  final String name;

  @HiveField(2, defaultValue: -1)
  final int type;

  @HiveField(3, defaultValue: '-')
  final String ip;

  @HiveField(4, defaultValue: -1)
  final int shelf;

  @HiveField(5, defaultValue: -1)
  final int slot;

  @HiveField(6, defaultValue: [])
  final List<int> path;
}
