import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:xtract/live_data_model.dart';
import 'graph_repository.dart';

class GraphProvider extends ChangeNotifier {
  final _repo = GraphRepository();

  void addData({
    required Function() success,
    required Function() failure,
    int time = 0,
    int speed = 0,
  }) async {
    final result = await _repo.addData(time: time, speed: speed);

    if (result) {
      success();
    } else {
      failure();
    }
    // Ensure data is refreshed after adding
    getGraph();
  }

  Stream<List<LiveData>>? _sGraphs;
  Stream<List<LiveData>>? get sGraphs => _sGraphs;

  void getGraph() {
    print("entered into providers..////////////////////////////////");
    _sGraphs = _repo.getGraphData();
    notifyListeners();
  }
}
