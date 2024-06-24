import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xtract/controller/connect_server_controller.dart';
import 'package:xtract/pages/messages_screen.dart';
import 'package:xtract/pages/topics_screen.dart';
import 'package:xtract/widgets/custom_methods.dart';

class ConnectServer extends StatefulWidget {
  const ConnectServer({super.key});

  @override
  State<ConnectServer> createState() => _ConnectServerState();
}

class _ConnectServerState extends State<ConnectServer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ConnectServerController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('MQTT Settings', style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              debugPrint(
                  'brokerConnected: ${controller.brokerConnected.value}');
              return ExpansionTile(
                title: ListTile(
                  leading: CircleAvatar(
                    radius: 10,
                    backgroundColor: controller.brokerConnected.isTrue
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(
                    controller.brokerConnected.isTrue
                        ? 'Connected'
                        : 'Not connected',
                  ),
                ),
                initiallyExpanded: true,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomMethods.customTextField(
                          labelText: 'MQTT Server Address',
                          textEditingController: controller.hostNameController,
                        ),
                        const SizedBox(height: 30),
                        CustomMethods.customTextField(
                          labelText: 'MQTT Server Port',
                          textEditingController:
                              controller.serverPortController,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomMethods.customButton(
                                  onPressed: () => controller.connectToBroker(),
                                  buttonText: controller.brokerConnected.isTrue
                                      ? 'Disconnect'
                                      : 'Connect',
                                ),
                            const    SizedBox(width: 20),
                                controller.brokerConnected.isTrue
                                    ? CustomMethods.customButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TopicsScreen())),
                                        buttonText: 'Topics')
                                    : Container()
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              );
            }),
            // const SizedBox(height: 20),
            // SizedBox(
            //   height: 100,
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: [
            //         CustomMethods.customTextField(
            //           labelText: 'Topic',
            //           textEditingController: controller.topicController,
            //         ),
            //         const SizedBox(width: 50),
            //          CustomMethods.customButton(
            //           onPressed: () { controller.subScribeToTopic();
            //           Navigator.push(context, MaterialPageRoute(builder: (context)=> MessagesScreen()));
            //           },
            //           buttonText: 'Subscribe',
            //         ),
            //         const SizedBox(width: 100),
            //          CustomMethods.customButton(
            //           onPressed: () => controller.unSubscribeToTopic(),
            //           buttonText: 'Unsubscribe',
            //         ),
            //         const SizedBox(width: 100),
            //       ],
            //     ),
            //   ),
            // ),
            // // const SizedBox(height: 20),
            // const Divider(thickness: 1, color: Colors.grey),
            // SizedBox(
            //   height: 80,
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: [
            //           CustomMethods.customTextField(
            //           labelText: 'Publish Topic',
            //           textEditingController: controller.publishTopicController,
            //         ),
            //         const SizedBox(width: 30),
            //           CustomMethods.customTextField(
            //           labelText: 'Publish Message',
            //           textEditingController: controller.messageController,
            //         ),
            //         const SizedBox(width: 50),
            //         CustomMethods.customButton(
            //           onPressed: () => controller.publishMessage(),
            //           buttonText: 'Publish',
            //         ),
            //         const SizedBox(width: 50),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
