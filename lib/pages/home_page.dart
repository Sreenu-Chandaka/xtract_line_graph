// ignore_for_file: unused_field, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controller/connect_server_controller.dart';
import '../model/live_data_model.dart';
import '../providers/graph_provider.dart';
import 'connect_server_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GraphProvider graphProvider;
  late double _deviceHeight;
  late double _deviceWidth;
  late TextEditingController _timeController;
  late TextEditingController _speedController;
   var controller = Get.put(ConnectServerController());

  @override
  void initState() {
    graphProvider = Provider.of(context, listen: false);
    super.initState();
    _timeController=TextEditingController();
    _speedController=TextEditingController();

    Future.delayed(const Duration(milliseconds: 320), () {
      graphProvider.getGraph();
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // ignore: prefer_const_constructors
        leading: Obx(() => Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child:  Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.circle_rounded,
                color:controller.brokerConnected.isTrue? Colors.green:Colors.red,
                size: 20,
              ),
              Text(controller.brokerConnected.isTrue?
                "connected":"Not connected",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),),
        
        title: const Text(
          "Xsynth10",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // graphProvider.addData(
                //     time: 150, speed: 25, success: () {}, failure: () {});
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
      // floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.add),
      //     onPressed: () {
      //       showAboutDialog(context: context, children: [
      //         AlertDialog(
      //             content: Column(
      //               mainAxisSize: MainAxisSize.max,
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             _customTextField(
      //                 labelText: "Enter Time",
      //                 textEditingController: _timeController),
      //             _customTextField(
      //                 labelText: "Enter Speed",
      //                 textEditingController: _speedController),
      //           ],
      //         ))
      //       ]);
      //     }),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0,top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [_graphWidget(), _dataTable()],
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
              print(snapshot.error);
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Colors.blue,));
              }

              return SfCartesianChart(
                onDataLabelRender: (dataLabelArgs) {},
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    dataSource: snapshot.data!,
                    xValueMapper: (LiveData data, _) => data.time,
                    yValueMapper: (LiveData data, _) => data.speed,
                  )
                ],
                primaryXAxis: const NumericAxis(
                  title: AxisTitle(text: 'Time (seconds)'),
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Internet speed (Mbps)'),
                ),
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
                  return const Center(child: CircularProgressIndicator(color: Colors.blue,));
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
        ));
  }

  _customTextField(
      {required String labelText,
      required TextEditingController textEditingController}) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        color: Color.fromARGB(89, 178, 212, 223),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none, // Remove the default border
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
      ),
    );
  }
}
