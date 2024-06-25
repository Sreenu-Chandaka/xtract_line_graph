import 'package:get/get.dart';

class TopicController extends GetxController {
  // Initialize as RxList
  RxList<String> listOfTopics = ["hs1", "ss1", "hs2"].obs;

  // Initialize as RxBool
  RxBool isEnabled = true.obs;

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

  // Method to update the topic state
  void updateTopicState(bool value) {
    isEnabled.value = value;
  }
}
