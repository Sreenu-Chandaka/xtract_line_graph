import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:xtract/helper/get_helper.dart';

import 'package:xtract/models/message_model.dart';
import 'package:xtract/widgets/toast_msg.dart';

import '../models/live_data_model.dart';
import 'mqtt_controller.dart';

class ConnectServerController extends GetxController {
  var hostNameController = TextEditingController();
  var serverPortController = TextEditingController();

  var messageController = TextEditingController();
  var publishTopicController = TextEditingController();

  var brokerConnected = false.obs;
  var receivedMessage = ''.obs;
  // var messageList =<MessageResponse>[].obs;
  var plotList = <LiveData>[].obs; // Ensure LiveData is properly defined

  var messageMap = <String, List<MessageResponse>>{}.obs;
  var mqttController = MQTTController();

  Future<void> connectToBroker() async {
    if (hostNameController.text.isEmpty && GetHelper.getHost().isEmpty) {
      ToastMsg.msg("hostAddress should not be empty");
    } else {
      if (brokerConnected.isFalse) {
        mqttController.initializeAndConnect(
          hostName: hostNameController.text.isNotEmpty
              ? hostNameController.text
              : GetHelper.getHost(),
          keepAliveTime: 1000,
          portNumber: int.tryParse(serverPortController.text.isNotEmpty
                  ? serverPortController.text
                  : GetHelper.getPort()) ??
              1883,
        );
        brokerConnected.value = await mqttController.onConnected();
      } else {
        mqttController
            .disconnect()
            .then((value) => brokerConnected.value = false);
      }
    }
  }

  publishMessage() {
    mqttController.publishMessage(
      topic: publishTopicController.text,
      publishMessage: messageController.text,
    );
  }

  void subScribeToTopic({required String topic}) {
    mqttController.subscribeToMQTT(topic: topic);
   Fluttertoast.showToast(msg: "message passed 3..,,,,,,,////");
  }

  void unSubscribeToTopic({required String topic}) {
    mqttController.unSubscribeToMQTT(topic: topic);
  }

  // Adjust handleMessage method
void handleMessage(MessageResponse message) {
  String topic = message.topic;


  // Add message to the appropriate topic list
  if (!messageMap.containsKey(topic)) {
    messageMap[topic] = <MessageResponse>[].obs;
  }
  messageMap[topic]!.add(message);

  // Call plotGraphByTopic to update plotList
  plotGraphByTopic(topic);
}

void plotGraphByTopic(String topic) {
  if (messageMap.containsKey(topic) && messageMap[topic]!.isNotEmpty) {
    MessageResponse latestMessage = messageMap[topic]!.last;

    if (latestMessage.message != null && latestMessage.message.isNotEmpty) {
      try {
        Map<String, dynamic>? messageIntList = json.decode(latestMessage.message);

        if (messageIntList != null && messageIntList.containsKey('spectrum')) {
          List<dynamic>? spectrumDynamic = messageIntList['spectrum'];

          if (spectrumDynamic != null) {
            // Map the spectrum data to LiveData objects
            plotList.value = List<LiveData>.generate(
              spectrumDynamic.length,
              (index) => LiveData(
                xData: index,
                yData: spectrumDynamic[index].toDouble(),
              ),
            );
          } else {
            print('Spectrum data is null');
          }
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Message is null or empty');
    }
  }
}

  // void handleMessage(dynamic message) {
  //   // Handle the received message here
  //   debugPrint('Received message in Dashboard: $message');
  //   // receivedMessage.value = '$topic: $message';
  //   receivedMessage.value = '${message.topic}: ${message.message}';
  //   messageList.add(message);

  // }
}
