import 'package:get/get.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../models/data_entry.dart';

class ChannelsGridController extends GetxController {
  final dataColumnsList = <PlutoColumn>[].obs;
  final dataRowsList = <PlutoRow>[].obs;
  final exampleData = <DataEntry>[].obs;
  late final PlutoGridStateManager stateManager;

 
  void setData(List<DataEntry> data) {
    if (data.isEmpty) return;

    // Extract column names from keys of the first data object
    var columnKeys = data.first.toMap().keys.toList();

    // Create columns dynamically
    dataColumnsList.assignAll(columnKeys.map((key) => _createPlutoColumn(key, data)).toList());

    // Create rows dynamically
    dataRowsList.assignAll(data.map((entry) => _createPlutoRow(entry)).toList());
  }

  PlutoColumn _createPlutoColumn(String key, List<DataEntry> data) {
    PlutoColumnType columnType;

    // Infer column type based on the first row's data
    var firstValue = data.first.toMap()[key];
    if (firstValue is int || firstValue is double) {
      columnType = PlutoColumnType.number();
    } else if (firstValue is DateTime || key.contains('date')) {
      columnType = PlutoColumnType.date();
    } else if (firstValue is String && key.contains('time')) {
      columnType = PlutoColumnType.time();
    } else {
      columnType = PlutoColumnType.text();
    }

    return PlutoColumn(
      title: key,
      field: key,
      type: columnType,
    );
  }

  PlutoRow _createPlutoRow(DataEntry entry) {
    return PlutoRow(
      cells: entry.toMap().map((key, value) => MapEntry(key, PlutoCell(value: value))),
    );
  }

  void addData(DataEntry newData) {
    exampleData.add(newData);
    setData(exampleData);
  }
}
