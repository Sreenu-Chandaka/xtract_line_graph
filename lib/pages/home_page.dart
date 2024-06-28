import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:xtract/helper/get_helper.dart';
import '../controller/connect_server_controller.dart';
import '../model/live_data_model.dart';
import 'connect_server_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _deviceHeight;
  late double _deviceWidth;

  var controller = Get.put(ConnectServerController());
  double _min = 0.0;
  double _max = 10.0; // Default max value to ensure _min != _max
  SfRangeValues _values = SfRangeValues(0.0, 10.0); // Default range values

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
        controller.subScribeToTopic(topic: "mca/data");
      
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
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.circle_rounded,
                  color: controller.brokerConnected.isTrue
                      ? Colors.green
                      : Colors.red,
                  size: 20,
                ),
                Text(
                  controller.brokerConnected.isTrue
                      ? "Connected"
                      : "Not connected",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        title: const Text(
          "Xsynth10",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConnectServer()));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 24,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [_graphWidget()],
        ),
      ),
    );
  }

  Expanded _graphWidget() {
    return Expanded(
      flex: 3,
      child: Obx(() {
        if (controller.plotList.isEmpty) {
          return const Center(child: Text("No data"));
        }
          if (controller.plotList.isNotEmpty) {
  _min = controller.plotList
      .map((data) => data.xData.toDouble())
      .reduce((value, element) => value < element ? value : element);
      print(_min);
      print("priting minimum values ...//////////////////////////");
  _max = controller.plotList
      .map((data) => data.xData.toDouble())
      .reduce((value, element) => value > element ? value : element);
      print(_max);
      print("printing maxiumu pluginn.//////////////////////////");
  _values = SfRangeValues(_min, _max); // Set initial range values based on _min and _max
}

        return SfRangeSelector(
          activeColor: Colors.amber,
         enableTooltip: true,
         shouldAlwaysShowTooltip: true,
          min: _min,
          max: _max,
          interval: 100,
          showTicks: true,
          showLabels: true,
          initialValues: _values,
          dragMode: SliderDragMode.onThumb,
          onChanged: (SfRangeValues values) {
            setState(() {
              _values = values;
            });
 print("printing selected range values ..//////////////////////");
    print(_values);
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SfCartesianChart(
              zoomPanBehavior: _zoomPanBehavior,
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
                  xValueMapper: (LiveData data, _) => data.xData.toDouble(),
                  yValueMapper: (LiveData data, int index) =>
                      data.yData.toDouble(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
