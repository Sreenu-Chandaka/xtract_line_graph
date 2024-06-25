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
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Topics', style: TextStyle(fontSize: 16)),
        ),
        body: ListView.builder(
          itemCount: listOfTopics.length,
          itemBuilder: (context, index) {
            return topicCard(listOfTopics[index]);
          },
        ),
      ),
    );
  }

  Widget topicCard(String topic) {
    const double kDefault = 16.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefault * 0.7, horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefault),
        ),
        color: const Color(0xFFEAEAEC),
        child: ListTile(
          title: Text(
            topic,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00B1CC),
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
    );
  }
}
