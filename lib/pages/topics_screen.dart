import 'package:flutter/material.dart';

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
      child: const Scaffold(
        body: Column(
          children: [
            Center(
              child: Card(
                child: Text("ss1",style: TextStyle(color: Colors.black),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
