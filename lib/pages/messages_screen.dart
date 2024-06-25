import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xtract/controller/connect_server_controller.dart';
import '../widgets/message_receiver_card.dart';

class MessagesScreen extends StatefulWidget {
  final String topic;
  const MessagesScreen({super.key, required this.topic});

  @override
  State<StatefulWidget> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late ScrollController _scrollController;
  late ConnectServerController controller;


  @override
  void initState() {
    super.initState();
   
    _scrollController = ScrollController();
    controller = Get.put(ConnectServerController());
    controller.subScribeToTopic(topic: widget.topic);
  }

  @override
  Widget build(BuildContext context) {
      const double kDefault = 16.0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        var messages = controller.messageMap[widget.topic] ?? [];

        return Column(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(color: Colors.white,),
                    Text(
                      widget.topic,
                      style: const TextStyle(fontSize: 20,color: Colors.white,),
                    ),
                    PopupMenuButton(
                      iconColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      onSelected: (String value) {
                        if (value == "subscribe") {
                          controller.subScribeToTopic(topic: widget.topic);
                        } else if (value == "unsubscribe") {
                          controller.unSubscribeToTopic(topic: widget.topic);
                        } else {
                          // Clear messages for this topic
                          controller.messageMap[widget.topic]?.clear();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem(
                          value: "subscribe",
                          child: Text('Subscribe'),
                        ),
                        const PopupMenuItem(
                          value: "unsubscribe",
                          child: Text("Unsubscribe"),
                        ),
                        const PopupMenuItem(
                          value: "clear",
                          child: Text("Clear"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                reverse: true,
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return MsgReceiverCard(
                            message: messages.reversed.toList()[index],
                          );
                        },
                        childCount: messages.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
             Container(
              padding: const EdgeInsets.only(
          left: kDefault,
          right: kDefault,
          top: kDefault / 2,
          bottom: kDefault * 1.4),
              color: Colors.white,
              child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefault),
              decoration: BoxDecoration(
                color: Color(0xFFF4F5F5),
                // color: Colors.grey.withOpacity(.23),
                borderRadius: BorderRadius.circular(kDefault),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.publishTopicController,
                    
                    decoration: const InputDecoration(
                       
                        hintText: ' Enter Your Topic',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                Divider(),
                  TextFormField(
                    controller:controller. messageController,
                  
                    decoration: const InputDecoration(
                      
                        hintText: ' Enter Your Message',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              controller.publishMessage();
              controller.publishTopicController.clear();
              controller.messageController.clear();
            },
            child: Transform.rotate(
              angle: -pi / 50,
              child: const Icon(
                Icons.arrow_circle_up_sharp,
                color: Colors.blueAccent,
                size: kDefault * 2.4,
              ),
            ),
          )
        ],
              ),
            )
          ],
        );
      }),
    );
  }

 
}
