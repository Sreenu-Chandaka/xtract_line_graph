import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:xtract/controllers/channel_grid_controller.dart';
import 'package:xtract/controllers/topic_controller.dart';
import 'package:xtract/helper/get_helper.dart';
import 'package:xtract/widgets/toast_msg.dart';
import '../controllers/connect_server_controller.dart';
import '../models/data_entry.dart';
import '../models/live_data_model.dart';
import 'channels_grid.dart';
import 'connect_server_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _deviceHeight;

  final _switchController = ValueNotifier<bool>(false);
  var controller = Get.put(ConnectServerController());
  var topicController = Get.put(TopicController());
  var gridController = Get.put(ChannelsGridController());
  final _key = GlobalKey<ExpandableFabState>();

  double _min = 0.0;
  double _max = 10.0;
  late SfRangeValues _values;
  num startPoint = 0;
  num endPoint = 0;

  num maximumPeakValue = 0;
  num totalPeaksCounts = 0;

  // Define the ZoomPanBehavior
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
    enableDoubleTapZooming: true,
    enableMouseWheelZooming: true,
    zoomMode: ZoomMode.xy,
  );

  @override
  void initState() {
    super.initState();

    if (GetHelper.getHost().isNotEmpty && GetHelper.getPort().isNotEmpty) {
      controller.connectToBroker();
    }

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (controller.brokerConnected.isTrue) {
        controller.subScribeToTopic(topic: topicController.listOfTopics.first);

        timer.cancel(); // Stop the timer once subscribed
      } else {
        print("Waiting for broker connection...");
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _key,
          distance: _deviceHeight * 0.2,
          type: ExpandableFabType.up,
          pos: ExpandableFabPos.right,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            heroTag: null,
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: FloatingActionButtonBuilder(
            size: 56,
            builder: (BuildContext context, void Function()? onPressed,
                Animation<double> progress) {
              return IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.close,
                  size: _deviceHeight * 0.06,
                ),
              );
            },
          ),
          overlayStyle: const ExpandableFabOverlayStyle(
            blur: 0,
          ),
          onOpen: () {
            debugPrint('onOpen');
          },
          afterOpen: () {
            debugPrint('afterOpen');
          },
          onClose: () {
            debugPrint('onClose');
          },
          afterClose: () {
            debugPrint('afterClose');
          },
          children: [
            FloatingActionButton.small(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              heroTag: null,
              child: Icon(
                Icons.settings,
                size: _deviceHeight * 0.06,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConnectServer()),
                );
                const SnackBar snackBar = SnackBar(
                  content: Text("SnackBar"),
                );
              },
            ),
            FloatingActionButton.small(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              heroTag: null,
              child: Icon(
                Icons.grid_view_outlined,
                size: _deviceHeight * 0.06,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) {
                     
                      return ChannelsGrid();
                    }),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 24),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _graphWidget(),
              _gridData(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _graphWidget() {
    return Expanded(
      flex: 6,
      child: Obx(() {
        if (controller.plotList.isEmpty) {
          return const Center(child: Text("No data"));
        }
        if (controller.plotList.isNotEmpty) {
          _min = controller.plotList
              .map((data) => data.xData.toDouble())
              .reduce((value, element) => value < element ? value : element);

          _max = controller.plotList
              .map((data) => data.xData.toDouble())
              .reduce((value, element) => value > element ? value : element);

          _values = SfRangeValues(_min, _max);
        }

        return _switchController.value
            ? SfRangeSelector(
                activeColor: Colors.greenAccent,
                enableTooltip: true,
                shouldAlwaysShowTooltip: true,
                min: _min,
                max: _max,
                interval: 100,
                showTicks: true,
                showLabels: true,
                initialValues: _values,
                dragMode: SliderDragMode.both,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    startPoint = values.start;
                    endPoint = values.end;
                  });
                },
                child: SizedBox(
                  height: _deviceHeight * 0.8,
                  child: SfCartesianChart(
                    margin: const EdgeInsets.all(0),
                    primaryXAxis: NumericAxis(
                      minimum: _min,
                      maximum: _max,
                      isVisible: false,
                    ),
                    primaryYAxis: const NumericAxis(isVisible: true),
                    plotAreaBorderWidth: 0,
                    series: <SplineAreaSeries<LiveData, double>>[
                      SplineAreaSeries<LiveData, double>(
                        color: const Color.fromARGB(255, 126, 184, 253),
                        dataSource: controller.plotList,
                        xValueMapper: (LiveData data, _) =>
                            data.xData.toDouble(),
                        yValueMapper: (LiveData data, int index) =>
                            data.yData.toDouble(),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: _deviceHeight * 0.8,
                child: SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  zoomPanBehavior: _zoomPanBehavior,
                  margin: const EdgeInsets.all(0),
                  primaryXAxis: NumericAxis(
                    minimum: _min,
                    maximum: _max,
                    isVisible: true,
                  ),
                  primaryYAxis: const NumericAxis(isVisible: true),
                  plotAreaBorderWidth: 0,
                  series: <SplineAreaSeries<LiveData, double>>[
                    SplineAreaSeries<LiveData, double>(
                      color: const Color.fromARGB(255, 126, 184, 253),
                      dataSource: controller.plotList,
                      xValueMapper: (LiveData data, _) => data.xData.toDouble(),
                      yValueMapper: (LiveData data, int index) =>
                          data.yData.toDouble(),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Expanded _gridData() {
    return Expanded(
      flex: 1,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.circle_rounded,
                  color: controller.brokerConnected.isTrue
                      ? Colors.green
                      : Colors.red,
                  size: _deviceHeight * 0.04,
                ),
                Text(
                  controller.brokerConnected.isTrue
                      ? "Connected"
                      : "Not Connected",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _deviceHeight * 0.032,
                  ),
                ),
              ],
            ),
            SizedBox(height: _deviceHeight * 0.03),
            AdvancedSwitch(
              height: _deviceHeight * 0.07,
              width: _deviceHeight * 0.15,
              controller: _switchController,
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              activeChild: Text(
                'ROI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _deviceHeight * 0.025,
                ),
              ),
              inactiveChild: Text(
                'ROI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _deviceHeight * 0.025,
                ),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              enabled: true,
              disabledOpacity: 0.5,
            ),
            SizedBox(height: _deviceHeight * 0.03),
            InkWell(
              onTap: () async {
                if (_switchController.value == true) {
                  await addDataToGrid();
                }
                return ToastMsg.msg(
                    "Please Turn on ROI mode and Select Channel");
              },
              child: Container(
                height: _deviceHeight * 0.07,
                width: _deviceHeight * 0.15,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: _deviceHeight * 0.04,
                    ),
                    Text(
                      "Add ROI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _deviceHeight * 0.025,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> calculateMaxPeakAndTotalCounts() async {
    List<double> filteredYData = controller.plotList
        .where((data) {
          double xValue = data.xData.toDouble();
          return xValue >= startPoint && xValue <= endPoint;
        })
        .map((data) => data.yData.toDouble())
        .toList();

    maximumPeakValue = filteredYData.reduce((a, b) => a > b ? a : b);

    totalPeaksCounts =
        filteredYData.reduce((value, element) => value + element);
  }

  Future<void> addDataToGrid() async {
    await calculateMaxPeakAndTotalCounts();
    // Create a new instance of DataEntry
    DataEntry newDataEntry = DataEntry();
    newDataEntry.channelStart = startPoint;
    newDataEntry.channelEnd = endPoint;
    newDataEntry.peakLabel = gridController.dataRowsList.length + 1;
    newDataEntry.peak = maximumPeakValue;
    newDataEntry.totalCounts = totalPeaksCounts;

    // Add new dataEntry to ChannelsGridController
    gridController.addData(newDataEntry);

    ToastMsg.msg("ROI Data added Successfully");

    // Reset startPoint and endPoint
    // setState(() {
    //   startPoint = 0;
    //   endPoint = 0;
    // });
  }
}
