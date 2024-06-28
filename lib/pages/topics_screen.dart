import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xtract/controller/topic_controller.dart';
import 'package:xtract/pages/messages_screen.dart';
import 'package:xtract/widgets/custom_methods.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TopicsScreen();
  }
}

class _TopicsScreen extends State<TopicsScreen> {
  late TextEditingController _topicController;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController();
    _editingController = TextEditingController();
    // Initialize the controller here
    Get.put(TopicController());
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
           backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const Text('Topics', style: TextStyle(fontSize: 20)),
        ),
        floatingActionButton: FloatingActionButton.extended(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          onPressed: () {
            _addTopicShowInputDialog(context);
          },
          label: const Row(
            children: [
              Icon(
                Icons.add,
                size: 26,
              ),
              Text(
                "New",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        body: GetX<TopicController>(
          builder: (controller) {
            return ListView.builder(
              itemCount: controller.listOfTopics.length,
              itemBuilder: (context, index) {
                return topicCard(controller.listOfTopics[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget topicCard(String topic) {
    final TopicController controller = Get.find<TopicController>();

    const double kDefault = 16.0;
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: kDefault * 0.7, horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefault),
        ),
        color: const Color(0xFFF4F5F5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0095B8),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagesScreen(topic: topic),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == "edit") {
                 _showEditDialog(context, topic);
                  }
                  if (value == "delete") {
                    controller.deleteTopic(topic);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    padding: EdgeInsets.only(left: 16),
                    value: "edit",
                    child: Text(
                      'Edit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const PopupMenuItem(
                    padding: EdgeInsets.only(left: 16),
                    value: "delete",
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTopicShowInputDialog(BuildContext context) {
    final TopicController controller = Get.find<TopicController>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Topic'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomMethods.customTextField(
                labelText: "Enter Topic",
                textEditingController: _topicController,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                controller.addTopic(_topicController.text);
                _topicController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _topicController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

 void _showEditDialog(BuildContext context, String initialTopic) {
    final TopicController controller = Get.find<TopicController>();
    _topicController.text = initialTopic; // Set initial text for editing

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Topic'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomMethods.customTextField(
                labelText: "Edit Topic",
                textEditingController: _topicController,
                initialText: initialTopic,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                controller.updateTopic(initialTopic, _topicController.text);
                _topicController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _topicController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
