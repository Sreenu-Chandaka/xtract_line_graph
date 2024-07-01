import 'package:get/get.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class ChannelsGridController extends GetxController {
  RxList<PlutoColumn> dataColumnsList = <PlutoColumn>[].obs;
  RxList<PlutoRow> dataRowsList = <PlutoRow>[].obs;
  late final PlutoGridStateManager stateManager;

  // Dynamic list to hold example data
  RxList<DataEntry> exampleData = <DataEntry>[].obs;

  ChannelsGridController() {
    // Initialize example data
    exampleData.addAll([
      DataEntry(
        peakLabel: 1,
        channelStart: 439,
        channelEnd: 470,
        peak: 570,
        totalCounts: 19202,
        // You don't need to specify default values like 'N/A'
        // They are already handled in the DataEntry class constructor
      ),
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

class DataEntry {
  int peakLabel;
  num channelStart;
  num channelEnd;
  int peak;
  int totalCounts;
  String relatedROI;
  int positionStdDev;
  String fwhmDevKEV;
  String fwhmDevChn;
  String fwhmDevPct;
  String areaStdDev;
  String option;
  String fit;
  String identifiedPeak;

  DataEntry({
    this.peakLabel = 0,
    this.channelStart = 0,
    this.channelEnd = 0,
    this.peak = 0,
    this.totalCounts = 0,
    this.relatedROI = 'N/A',
    this.positionStdDev = 0,
    this.fwhmDevKEV = 'N/A',
    this.fwhmDevChn = 'N/A',
    this.fwhmDevPct = 'N/A',
    this.areaStdDev = 'N/A',
    this.option = 'N/A',
    this.fit = 'N/A',
    this.identifiedPeak = 'N/A',
  });

  // Method to convert to map
  Map<String, dynamic> toMap() {
    return {
      'Peak Label': peakLabel,
      'Channel Start': channelStart,
      'Channel End': channelEnd,
      'Peak': peak,
      'Total Counts': totalCounts,
      'Related ROI': relatedROI,
      'Position|Std.Dev(chn)': positionStdDev,
      'FWHM|Std.dev(kEV)': fwhmDevKEV,
      'FWHM|Std.Dev(chn)': fwhmDevChn,
      'FWHM|Std.Dev(%)': fwhmDevPct,
      'Area|Std.Dev': areaStdDev,
      'Option': option,
      'Fit': fit,
      'Identified Peak': identifiedPeak,
    };
  }
}
