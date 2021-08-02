import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  final double x;
  final double y;
  final double z;

  SensorData({required this.x, required this.y, required this.z});

  factory SensorData.fromJson(Map<String, dynamic> json) => _$SensorDataFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataToJson(this);
}
