import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xtract/model/message_model.dart';

import 'mqtt_controller.dart';

class ConnectServerController extends GetxController {
  var hostNameController = TextEditingController();
  var serverPortController = TextEditingController();
  
  var topicController = TextEditingController();
  var messageController = TextEditingController();
  var publishTopicController = TextEditingController();

  var brokerConnected = false.obs;
  var receivedMessage = ''.obs;
  var messageList =<MessageResponse>[].obs;
  var mqttController = MQTTController();

  
  Future<void> connectToBroker() async {
    if (hostNameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Client Id should not be empty',
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        webPosition: "center",
        webBgColor: "#b2dfdb",
        timeInSecForIosWeb: 2,
      );
    } else {
      if (brokerConnected.isFalse) {
        mqttController.initializeAndConnect(
          hostName: hostNameController.text,

          keepAliveTime: 1000,

          portNumber: int.tryParse(serverPortController.text) ?? 1883,
          //   password: passwordController.text,
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

  void subScribeToTopic() {
    mqttController.subscribeToMQTT(topic: topicController.text);
  }

  void unSubscribeToTopic() {
    mqttController.unSubscribeToMQTT(topic: topicController.text);
    
  }

  void handleMessage(dynamic message) {
    // Handle the received message here
    debugPrint('Received message in Dashboard: $message');
    // receivedMessage.value = '$topic: $message';
    receivedMessage.value = '${message.topic}: ${message.message}';
    messageList.add(message);
    
  }
}
