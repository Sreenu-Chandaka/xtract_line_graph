import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xtract/controller/connect_server_controller.dart';
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
        title: const Text('MQTT Settings', style: TextStyle(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              debugPrint('brokerConnected: ${controller.brokerConnected.value}');
              return Column(
                children: [
                  ListTile(
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomMethods.customTextField(
                          enable: controller.brokerConnected.isTrue?false:true,
                          labelText: 'MQTT Server Address',
                          textEditingController: controller.hostNameController,
                        ),
                        const SizedBox(height: 30),
                        CustomMethods.customTextField(
                          enable: controller.brokerConnected.isTrue?false:true,
                          labelText: 'MQTT Server Port',
                          textEditingController: controller.serverPortController,
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
                              const SizedBox(width: 20),
                              controller.brokerConnected.isTrue
                                  ? CustomMethods.customButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TopicsScreen())),
                                      buttonText: 'Topics')
                                  : Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
        ],
        ),
      ),
    );
  }
}
