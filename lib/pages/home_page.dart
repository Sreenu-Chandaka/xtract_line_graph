// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:xtract/helper/get_helper.dart';
import 'package:xtract/widgets/toast_msg.dart';
import '../controller/connect_server_controller.dart';
import '../model/live_data_model.dart';
import '../providers/graph_provider.dart';
import 'connect_server_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GraphProvider graphProvider;
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

  @override
  void initState() {
    super.initState();
    print(GetHelper.getHost().isNotEmpty);
    ToastMsg.msg("host status: ${GetHelper.getHost().isNotEmpty}");
    print("host statsu..////////////////////////////////////");
    if(GetHelper.getHost().isNotEmpty && GetHelper.getPort().isNotEmpty){
      debugPrint("entered into if statement..////////////////////////");

      controller.connectToBroker();
      debugPrint("crossed the controller ..////////////////////////");
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    graphProvider = Provider.of(context, listen: false);
  

    Future.delayed(const Duration(milliseconds: 320), () {
      graphProvider.getGraph();
    });
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
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _graphWidget(),
            _dataTable(),
          ],
        ),
      ),
    );
  }

  Expanded _graphWidget() {
    return Expanded(
      flex: 3,
      child: Consumer<GraphProvider>(
        builder: (context, graphProvider, child) {
          return StreamBuilder<List<LiveData>>(
            stream: graphProvider.sGraphs,
            builder: (context, snapshot) {
              debugPrint(snapshot.error.toString());
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.blue));
              }

              return SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    dataSource: snapshot.data!,
                    xValueMapper: (LiveData data, _) => data.time,
                    yValueMapper: (LiveData data, _) => data.speed,
                  ),
                ],
                primaryXAxis: const NumericAxis(
                  title: AxisTitle(text: 'Time (seconds)'),
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Internet speed (Mbps)'),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              );
            },
          );
        },
      ),
    );
  }

  Expanded _dataTable() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child:
            Consumer<GraphProvider>(builder: (context, graphProvider, child) {
          return StreamBuilder<List<LiveData>>(
            stream: graphProvider.sGraphs,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.blue));
              }
              return Column(
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text("Time"), Text("Speed")],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(snapshot.data![index].time.toString())
                            ],
                          ),
                          Column(
                            children: [
                              Text(snapshot.data![index].speed.toString())
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
