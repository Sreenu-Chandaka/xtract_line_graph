// ignore_for_file: library_private_types_in_public_api, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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

  // Define the ZoomPanBehavior
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
    enableDoubleTapZooming: true,
    enableMouseWheelZooming: true,
    zoomMode: ZoomMode.xy,
  );
  final _key = GlobalKey<ExpandableFabState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();

    if (GetHelper.getHost().isNotEmpty && GetHelper.getPort().isNotEmpty) {
      controller.connectToBroker();
    }
 Timer.periodic(Duration(seconds: 3), (timer) {
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
  dispose() {
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
      // floatingActionButtonLocation: ExpandableFab.location,
      // floatingActionButton: ExpandableFab(
      //   key: _key,
      //   // duration: const Duration(milliseconds: 500),
      //   distance: 60.0,
      //   type: ExpandableFabType.up,
      //   pos: ExpandableFabPos.right,
      //   // childrenOffset: const Offset(0, 20),
      //   // fanAngle: 40,
      //   // openButtonBuilder: RotateFloatingActionButtonBuilder(
      //   //   child: const Icon(Icons.abc),
      //   //   fabSize: ExpandableFabSize.large,
      //   //   foregroundColor: Colors.amber,
      //   //   backgroundColor: Colors.green,
      //   //   shape: const CircleBorder(),
      //   //   angle: 3.14 * 2,
      //   // ),
      //   // closeButtonBuilder: FloatingActionButtonBuilder(
      //   //   size: 56,
      //   //   builder: (BuildContext context, void Function()? onPressed,
      //   //       Animation<double> progress) {
      //   //     return IconButton(
      //   //       onPressed: onPressed,
      //   //       icon: const Icon(
      //   //         Icons.check_circle_outline,
      //   //         size: 40,
      //   //       ),
      //   //     );
      //   //   },
      //   // ),
      //   overlayStyle: ExpandableFabOverlayStyle(
      //     // color: Colors.black.withOpacity(0.5),
      //     blur: 0,
      //   ),
      //   onOpen: () {
      //     debugPrint('onOpen');
      //   },
      //   afterOpen: () {
      //     debugPrint('afterOpen');
      //   },
      //   onClose: () {
      //     debugPrint('onClose');
      //   },
      //   afterClose: () {
      //     debugPrint('afterClose');
      //   },
      //   children: [
      //     FloatingActionButton.small(
      //       // shape: const CircleBorder(),
      //       heroTag: null,
      //       child: const Icon(Icons.edit),
      //       onPressed: () {
      //         const SnackBar snackBar = SnackBar(
      //           content: Text("SnackBar"),
      //         );
      //         scaffoldKey.currentState?.showSnackBar(snackBar);
      //       },
      //     ),
      //     FloatingActionButton.small(
      //       // shape: const CircleBorder(),
      //       heroTag: null,
      //       child: const Icon(Icons.search),
      //       onPressed: () {
      //         Navigator.of(context).push(
      //             MaterialPageRoute(builder: ((context) => ConnectServer())));
      //       },
      //     ),
      //     FloatingActionButton.small(
      //       // shape: const CircleBorder(),
      //       heroTag: null,
      //       child: const Icon(Icons.share),
      //       onPressed: () {
      //         final state = _key.currentState;
      //         if (state != null) {
      //           debugPrint('isOpen:${state.isOpen}');
      //           state.toggle();
      //         }
      //       },
      //     ),
      //   ],
      // ),
     
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
    var controller = Get.find<ConnectServerController>();
    return Expanded(
      // flex: 3,
      child: Obx(() {
        print(DateTime.now());
        print("Datetime for every trigger ..//////////////////////");
        if (controller.plotList.isEmpty) {
          return const Center(child: Text("No data"));
          // CircularProgressIndicator(color: Colors.blue));
        }

        return SfCartesianChart(
          series: <LineSeries<LiveData, int>>[
            LineSeries<LiveData, int>(
              dataSource: controller.plotList,
              xValueMapper: (LiveData data, _) => data.xData,
              yValueMapper: (LiveData data, _) => data.yData,
            ),
          ],
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Index'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Spectrum Data'),
          ),
          zoomPanBehavior: _zoomPanBehavior,
        );
      }),
    );
  }

}