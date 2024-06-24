import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../model/message_model.dart';
import 'connect_server_controller.dart';  // Adjust import as necessary

class MQTTController {
  MqttServerClient? mqttClient;
  final Random _rnd = Random();
  final String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

  String getRandomString(int length) => String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> initializeAndConnect({
    required String hostName,
    required int portNumber,
    int? keepAliveTime,
  }) async {
    String clientId = getRandomString(5); // Generate a consistent clientId
    debugPrint("Host: $hostName, Port: $portNumber, ClientId: $clientId");

    mqttClient = MqttServerClient(hostName, clientId);
    mqttClient!.port = portNumber;
    mqttClient!.keepAlivePeriod = keepAliveTime ?? 60;

    // Define connection callbacks
    mqttClient!.onConnected = onConnected;
    mqttClient!.onDisconnected = onDisconnected;
    mqttClient!.onSubscribed = onSubscribed;
    mqttClient!.onUnsubscribed = onUnSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .withWillQos(MqttQos.exactlyOnce)
        .startClean();

    mqttClient!.connectionMessage = connMessage;

    try {
      await mqttClient!.connect("sreenu", "123");
      print("entered into connect clinet......///////////////////");
      if (mqttClient!.connectionStatus!.state == MqttConnectionState.connected) {
        print(mqttClient!.connectionStatus!.state);
        // print("printing connection state in try...................//////////////////////////////////////////////////////");
        startListeningMessages();
      } else {
        debugPrint("Failed to connect to the broker.");
      }
    } catch (e) {
      debugPrint('MQTT Client exception: $e');
      mqttClient!.disconnect();
    }
  }

  bool isConnectedToBroker() {
    print( mqttClient!.connectionStatus!.state );
    print("print connection state.///////////////////////////");
    return mqttClient!.connectionStatus!.state == MqttConnectionState.connected;
  }

  Future onConnected() async {
    Fluttertoast.showToast(msg: 'Connected');
    return true;
  }

  Future onSubscribed(String topic) async {
    debugPrint("Subscribed to topic: $topic");
    Fluttertoast.showToast(msg: 'Subscribed to topic: $topic');
  }

  Future onUnSubscribed(String? topic) async {
    debugPrint("Unsubscribed from topic: $topic");
    Fluttertoast.showToast(msg: 'Unsubscribed from topic: $topic');
  }

  Future onDisconnected() async {
    debugPrint("Disconnected");
   Fluttertoast.showToast(msg: 'Disconnected');
  }

  Future publishMessage({
    required String topic,
    required String publishMessage,
  }) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(publishMessage);
    try {
      mqttClient!.publishMessage(
        topic,
        MqttQos.atMostOnce,
        builder.payload!,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future subscribeToMQTT({required String topic}) async {
    print("topic.......///////////////////////////////");
    print(topic);
    if (isConnectedToBroker()) {
      debugPrint('Subscribing to topic: $topic');
      mqttClient!.subscribe(topic, MqttQos.atMostOnce);
    } else {
      debugPrint('Cannot subscribe, not connected to the broker.');
    }
  }

  Future unSubscribeToMQTT({required String topic}) async {
    if (isConnectedToBroker()) {
      mqttClient!.unsubscribe(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } else {
      debugPrint('Cannot unsubscribe, not connected to the broker.');
    }
  }

  Future<void> disconnect() async => mqttClient!.disconnect();

 void startListeningMessages() {
  mqttClient!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
    final String topic = c[0].topic;
    final MqttPublishMessage payload = c[0].payload as MqttPublishMessage;
    final MessageResponse message = MessageResponse.fromPayload(topic, payload);

    // Displaying topic and message separately
    print("Topic: ${message.topic}");
    print("Message: ${message.message}");

    // Pass to controller
    ConnectServerController connectServerController = Get.find<ConnectServerController>();
    connectServerController.handleMessage(message);
  });
}



}



