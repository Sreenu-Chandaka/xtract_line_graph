import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';

class MessageResponse {
  final String topic;
  final String message;
  final DateTime time; // New field for storing message timestamp

  MessageResponse({
    required this.topic,
    required this.message,
    required this.time,
  });

  factory MessageResponse.fromPayload(String topic, MqttPublishMessage payload) {
    final String message =
        MqttPublishPayload.bytesToStringAsString(payload.payload.message);
    final DateTime currentTime = DateTime.now(); // Get current timestamp
    return MessageResponse(topic: topic, message: message, time: currentTime);
  }

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'message': message,
        'time': time.toIso8601String(), // Serialize DateTime to ISO 8601 string
      };

  @override
  String toString() => jsonEncode(toJson());
}
