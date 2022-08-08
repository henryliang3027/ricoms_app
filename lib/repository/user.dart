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
        );

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ip;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String permission;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String mobile;

  @HiveField(7)
  final String tel;

  @HiveField(8)
  final String ext;

  @HiveField(9)
  final List<int> bookmarks;

  @HiveField(10)
  final bool isActivate;
}
