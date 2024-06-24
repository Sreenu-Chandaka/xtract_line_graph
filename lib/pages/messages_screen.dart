import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xtract/controller/connect_server_controller.dart';

import '../widgets/message_receiver_card.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Topic"),
        actions: [],
      ),
      body: Obx(() {
        var reversedMessages = controller.messageList.reversed.toList();

        return CustomScrollView(
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
        );
      }),
    );
  }
}
