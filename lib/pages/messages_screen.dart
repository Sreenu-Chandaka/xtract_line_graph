import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xtract/controller/connect_server_controller.dart';

import '../widgets/message_receiver_card.dart';
enum SampleItem { itemOne, itemTwo, itemThree }
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late ScrollController _scrollController;
  late ConnectServerController controller;
SampleItem? selectedItem;
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
        actions: [
           PopupMenuButton<SampleItem>(
            surfaceTintColor: Colors.white,
          initialValue: selectedItem,
          onSelected: (SampleItem item) {
            setState(() {
              selectedItem = item;
              print(selectedItem);
              print("printing selected item");
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemOne,
              child: Text('Item 1'),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemTwo,
              child: Text('Item 2'),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemThree,
              child: Text('Item 3'),
            ),
          ],
        ),
      
        ],
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
