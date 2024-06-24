import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';

class MessageResponse {
  final String topic;
  final String message;

   MessageResponse ({required this.topic, required this.message});

  factory  MessageResponse .fromPayload(String topic, MqttPublishMessage payload) {
    final String message =
        MqttPublishPayload.bytesToStringAsString(payload.payload.message);
    return  MessageResponse (topic: topic, message: message);
  }

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'message': message,
      };

  @override
  String toString() => jsonEncode(toJson());
}
