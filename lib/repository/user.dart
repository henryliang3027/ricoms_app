import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  const User({
    required this.id,
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
  });

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
  final List<int> bookmarks;

  @HiveField(10, defaultValue: false)
  final bool isActivate;

  @HiveField(11, defaultValue: '-')
  final String account;
}
