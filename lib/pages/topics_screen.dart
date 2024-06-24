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
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child:  Scaffold(
        body: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagesScreen(topic: "hs2")));

            }, child: Text("hs2"))
          ],
        ),
      ),
    );
  }
}
