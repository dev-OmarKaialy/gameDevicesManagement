import 'package:hive_flutter/hive_flutter.dart';

part 'device.g.dart';

@HiveType(typeId: 1)
class Device {
  @HiveField(0)
  String name;
  @HiveField(1)
  double price;
  @HiveField(2)
  bool status;
  @HiveField(3)
  DeviceType type;
  Device({
    required this.name,
    required this.price,
    required this.status,
    required this.type,
  });
}

@HiveType(typeId: 2)
enum DeviceType {
  @HiveField(0)
  playstation,
  @HiveField(1)
  pc,
  @HiveField(2)
  xbox,
  @HiveField(3)
  laptop
}
