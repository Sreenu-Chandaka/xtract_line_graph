import 'package:flutter/material.dart';
import 'package:xtract/pages/messages_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TopicsScreen();
  }
}

class _TopicsScreen extends State<TopicsScreen> {
  List<String> listOfTopics = ["hs1", "ss1", "hs2"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Topics', style: TextStyle(fontSize: 20)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
          onPressed: () {},
          label: const Row(
            children: [Icon(Icons.add,size: 26,),Text("New",style: TextStyle(fontSize: 20),), ],
          )),
      body: ListView.builder(
        itemCount: listOfTopics.length,
        itemBuilder: (context, index) {
          return topicCard(listOfTopics[index]);
        },
      ),
    );
  }

  Widget topicCard(String topic) {
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
                  // Handle menu selection
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
