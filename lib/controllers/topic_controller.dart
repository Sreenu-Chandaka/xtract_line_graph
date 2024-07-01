import 'package:get/get.dart';

class TopicController extends GetxController {
  // Initialize as RxList
  RxList<String> listOfTopics = ["mca/data"].obs;



  // Method to add a topic to the list
  void addTopic(String topic) {
    listOfTopics.add(topic);
  }

  // Method to update a specific topic in the list
  void updateTopic(String oldTopic, String newTopic) {
    // Find the index of the old topic
    int index = listOfTopics.indexOf(oldTopic);

    // If the topic exists in the list, update it
    if (index != -1) {
      listOfTopics[index] = newTopic;
    }
  }
 void deleteTopic(String topic) {
    listOfTopics.remove(topic);
  }

 
}
