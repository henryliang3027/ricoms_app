import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  const User({
    required this.id,
    required this.ip,
    required this.isActivate,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ip;

  @HiveField(2)
  final bool isActivate;
}
