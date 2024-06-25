import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xtract/model/message_model.dart';

import 'mqtt_controller.dart';

class ConnectServerController extends GetxController {
  var hostNameController = TextEditingController();
  var serverPortController = TextEditingController();
  
  
  var messageController = TextEditingController();
  var publishTopicController = TextEditingController();

  var brokerConnected = false.obs;
  var receivedMessage = ''.obs;
  // var messageList =<MessageResponse>[].obs;
  var messageMap = <String, List<MessageResponse>>{}.obs;
  var mqttController = MQTTController();

  
  Future<void> connectToBroker() async {
    if (hostNameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Host Address should not be empty',
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
  }

  void unSubscribeToTopic({required String topic}) {
    mqttController.unSubscribeToMQTT(topic: topic);
    
  }

    

  // Adjust handleMessage method
  void handleMessage(MessageResponse message) {
    String topic = message.topic;
    debugPrint('Received message in Dashboard: $message');
    
    // Add message to the appropriate topic list
    if (!messageMap.containsKey(topic)) {
      messageMap[topic] = <MessageResponse>[].obs;
    }
    messageMap[topic]!.add(message);
  }

  // void handleMessage(dynamic message) {
  //   // Handle the received message here
  //   debugPrint('Received message in Dashboard: $message');
  //   // receivedMessage.value = '$topic: $message';
  //   receivedMessage.value = '${message.topic}: ${message.message}';
  //   messageList.add(message);
    
  // }
}
