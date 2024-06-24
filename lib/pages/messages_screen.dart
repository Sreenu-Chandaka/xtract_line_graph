import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
     
      body: Obx(() {
        var reversedMessages = controller.messageList.reversed.toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(),
                   Text("Topic"),
                    PopupMenuButton(
              surfaceTintColor: Colors.white,
                       
                        onSelected: (String value) {
              if(value=="subscribe"){
                controller.subScribeToTopic();
              }
              else if(value=="unsubscribe"){
                controller.unSubscribeToTopic();
              }
              else{
               controller.messageList.clear();
              }
              
              
              
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String >>[
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
