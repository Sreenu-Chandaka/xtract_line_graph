import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xtract/controller/connect_server_controller.dart';
import 'package:xtract/pages/messages_screen.dart';
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
dispose(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  
  ]);
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ConnectServerController());
    return Scaffold(
     appBar: AppBar(automaticallyImplyLeading: true,title: const Text('MQTT Settings',style: TextStyle(fontSize: 16)),),
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
                    child: Row(
                      children: [
                          CustomMethods.customTextField(
                          labelText: 'MQTT Server Address',
                          textEditingController: controller.hostNameController,
                        ),
                        const SizedBox(width: 30),
                          CustomMethods.customTextField(
                          labelText: 'MQTT Server Port',
                          textEditingController:
                              controller.serverPortController,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child:  CustomMethods.customButton(
                            onPressed: () => controller.connectToBroker(),
                            buttonText: controller.brokerConnected.isTrue
                                ? 'Disconnect'
                                : 'Connect',
                          ),
                        ),
                        // const SizedBox(width: 30),
                        // _customTextField(
                        //   labelText: 'Password',
                        //   textEditingController: controller.passwordController,
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomMethods.customTextField(
                      labelText: 'Topic',
                      textEditingController: controller.topicController,
                    ),
                    const SizedBox(width: 50),
                     CustomMethods.customButton(
                      onPressed: () { controller.subScribeToTopic();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MessagesScreen()));
                      },
                      buttonText: 'Subscribe',
                    ),
                    const SizedBox(width: 100),
                     CustomMethods.customButton(
                      onPressed: () => controller.unSubscribeToTopic(),
                      buttonText: 'Unsubscribe',
                    ),
                    const SizedBox(width: 100),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.grey),
            SizedBox(
              height: 80,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                      CustomMethods.customTextField(
                      labelText: 'Publish Topic',
                      textEditingController: controller.publishTopicController,
                    ),
                    const SizedBox(width: 30),
                      CustomMethods.customTextField(
                      labelText: 'Publish Message',
                      textEditingController: controller.messageController,
                    ),
                    const SizedBox(width: 50),
                    CustomMethods.customButton(
                      onPressed: () => controller.publishMessage(),
                      buttonText: 'Publish',
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Container(
                width: double.infinity,
                height: 100,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.grey),
                ),
                child: ListView.builder(
                  itemCount: controller.messageList.length,
                  itemBuilder: (context, index) {
                    return Text(
                      controller.messageList[index].toString(),
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
           CustomMethods.customButton(
              onPressed: () => controller.messageList.clear(),
              buttonText: 'Clear Messages',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
