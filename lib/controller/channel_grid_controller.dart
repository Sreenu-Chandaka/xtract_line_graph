import 'package:get/get.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../model/data_entry.dart';

class ChannelsGridController extends GetxController {
  RxList<PlutoColumn> dataColumnsList = <PlutoColumn>[].obs;
  RxList<PlutoRow> dataRowsList = <PlutoRow>[].obs;
  late final PlutoGridStateManager stateManager;

  // Dynamic list to hold example data
  RxList<DataEntry> exampleData = <DataEntry>[].obs;

  ChannelsGridController() {
    // Initialize example data
    exampleData.addAll([
      
      // Add more initial data here if needed
    ]);

    // Set dynamic data to the controller
    setData(exampleData);
  }

  // Method to set dynamic data
  void setData(List<DataEntry> data) {
    if (data.isEmpty) return;

    // Extract column names from keys of the first data object
    var columnKeys = data.first.toMap().keys.toList();

    // Create columns dynamically
    dataColumnsList.assignAll(columnKeys.map((key) {
      PlutoColumnType columnType;

      // Infer column type based on the first row's data
      if (data.first.toMap()[key] is int || data.first.toMap()[key] is double) {
        columnType = PlutoColumnType.number();
      } else if (data.first.toMap()[key] is DateTime || key.contains('date')) {
        columnType = PlutoColumnType.date();
      } else if (data.first.toMap()[key] is String && key.contains('time')) {
        columnType = PlutoColumnType.time();
      } else {
        columnType = PlutoColumnType.text();
      }

      return PlutoColumn(
        title: key,
        field: key,
        type: columnType,
      );
    }).toList());

    // Create rows dynamically
    dataRowsList.assignAll(data.map((entry) {
      return PlutoRow(
        cells: entry.toMap().map((key, value) {
          return MapEntry(key, PlutoCell(value: value));
        }),
      );
    }).toList());
  }

  // Method to add new data
  void addData(DataEntry newData) {
    exampleData.add(newData);
    setData(exampleData);
  }
}

