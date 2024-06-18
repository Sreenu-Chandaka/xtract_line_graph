import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xtract/live_data_model.dart';

// Abstract class defining the contract
abstract class IGraphRepository {
  Future<bool> addData({required int time, required int speed});
  Stream<List<LiveData>> getGraphData();
}

// Implementation of the abstract class
class GraphRepository implements IGraphRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<bool> addData({required int time, required int speed}) async {
    try {
      await _supabase.from("graph_table").insert({
        "created_at":
            DateTime.now().toIso8601String(), // ISO 8601 format for timestamps
        "time": time,
        "speed": speed,
      });

      return true;
    } catch (error) {
      print("Error adding data: $error");
      return false;
    }
  }

  @override
  Stream<List<LiveData>> getGraphData() {
    print("entered into repo..////////////////////////////////////");
    final controller = StreamController<List<LiveData>>.broadcast();

    final subscription = _supabase
        .from("graph_table")
        .stream(primaryKey: ['id'])
        .listen((event) {
      try {
        final data = event.map((row) {
          return LiveData(row['time'] as int, row['speed'] as int);
        }).toList();
        print(data);
        print(
            "data in repository../////////////////////////////////////////////////////////////////////");
        controller.add(data);
      } catch (error) {
        controller.addError("Error processing data: $error");
      }
    }, onError: (error) {
      controller.addError("Error fetching data: $error");
    });

    // Ensure the subscription and controller are properly managed
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }
}
