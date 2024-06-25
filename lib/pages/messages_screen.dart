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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        var reversedMessages = controller.messageList.reversed.toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(widget.topic,style: const TextStyle(fontSize: 20),),
                  PopupMenuButton(
                    surfaceTintColor: Colors.white,
                    onSelected: (String value) {
                      if (value == "subscribe") {
                        controller.subScribeToTopic(topic: widget.topic);
                      } else if (value == "unsubscribe") {
                        controller.unSubscribeToTopic(topic: widget.topic);
                      } else {
                        controller.messageList.clear();
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
                            message: reversedMessages[index],
                          );
                        },
                        childCount: reversedMessages.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
