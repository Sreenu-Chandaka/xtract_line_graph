import 'package:get/get.dart';

import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class ChannelsGridController extends GetxController {
  RxList<PlutoColumn> dataColumnsList = <PlutoColumn>[].obs;
  RxList<PlutoRow> dataRowsList = <PlutoRow>[].obs;
  late final PlutoGridStateManager stateManager;

  // Method to set dynamic data
  void setData(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return;

    // Extract column names from keys of the first data object
    var columnKeys = data.first.keys;

    // Create columns dynamically
    dataColumnsList.assignAll(columnKeys.map((key) {
      PlutoColumnType columnType;

      // Infer column type based on the first row's data
      if (data.first[key] is int || data.first[key] is double) {
        columnType = PlutoColumnType.number();
      } else if (data.first[key] is DateTime || key.contains('date')) {
        columnType = PlutoColumnType.date();
      } else if (data.first[key] is String && key.contains('time')) {
        columnType = PlutoColumnType.time();
      } else if (data.first[key] is String && key.contains('role')) {
        columnType = PlutoColumnType.select(<String>[
          'Programmer',
          'Designer',
          'Owner',
        ]);
      } else {
        columnType = PlutoColumnType.text();
      }

      return PlutoColumn(
        title: key.capitalizeFirst!,
        field: key,
        type: columnType,
      );
    }).toList());

    // Create rows dynamically
    dataRowsList.assignAll(data.map((item) {
      return PlutoRow(
        cells: {
          for (var key in item.keys) key: PlutoCell(value: item[key]),
        },
      );
    }).toList());
  }
}
