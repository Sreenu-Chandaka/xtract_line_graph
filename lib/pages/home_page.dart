import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:xtract/helper/get_helper.dart';
import 'package:xtract/widgets/toast_msg.dart';
import '../controller/connect_server_controller.dart';
import '../model/live_data_model.dart';
import 'channels_grid.dart';
import 'connect_server_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _deviceHeight;
  late double _deviceWidth;
  final _switchController = ValueNotifier<bool>(false);
  var controller = Get.put(ConnectServerController());
  final _key = GlobalKey<ExpandableFabState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  double _min = 0.0;
  double _max = 10.0; // Default max value to ensure _min != _max
  SfRangeValues _values = const SfRangeValues(0.0, 10.0); // Default range values

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
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _key,
          // duration: const Duration(milliseconds: 500),
          distance: _deviceHeight*0.1,
          type: ExpandableFabType.up,
          pos: ExpandableFabPos.right,
          // childrenOffset: const Offset(0, 20),
          // fanAngle: 40,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            heroTag: null,
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            // angle: 3.14 * 2,
          ),
          closeButtonBuilder: FloatingActionButtonBuilder(
            size: 56,
            builder: (BuildContext context, void Function()? onPressed,
                Animation<double> progress) {
              return IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.close,
                  size: _deviceHeight * 0.04,
                ),
              );
            },
          ),
          overlayStyle: const ExpandableFabOverlayStyle(
            // color: Colors.black.withOpacity(0.5),
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
                size: _deviceHeight * 0.04,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ConnectServer()));
                const SnackBar snackBar = SnackBar(
                  content: Text("SnackBar"),
                );
                scaffoldKey.currentState?.showSnackBar(snackBar);
              },
            ),
            FloatingActionButton.small(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              heroTag: null,
              child: Icon(
                Icons.grid_view_outlined,
                size: _deviceHeight * 0.04,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => const ChannelsGrid())));
              },
            ),
            // FloatingActionButton.small(
            //   shape: const CircleBorder(),
            //   backgroundColor: Colors.white,
            //   heroTag: null,
            //   child: Icon(
            //     Icons.share,
            //     size: _deviceHeight * 0.04,
            //   ),
            //   onPressed: () {
            //     final state = _key.currentState;
            //     if (state != null) {
            //       debugPrint('isOpen:${state.isOpen}');
            //       state.toggle();
            //     }
            //   },
            // ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 24),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [_graphWidget(), _gridData()],
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

          _values = SfRangeValues(
              _min, _max); // Set initial range values based on _min and _max
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
                    _values = values;
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
                    size: 20,
                  ),
                  Text(
                    controller.brokerConnected.isTrue
                        ? "Connected"
                        : "Not connected",
                    style: TextStyle(color: Colors.black,fontSize: _deviceHeight*0.03),
                  ),
                ],
              ),
              SizedBox(height: _deviceHeight * 0.03),
              AdvancedSwitch(
                width: _deviceWidth * 0.08,
                controller: _switchController,
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
                activeChild: const Text('ROI'),
                inactiveChild: const Text('ROI '),
                // activeImage: AssetImage('assets/images/on.png'),
                // inactiveImage: AssetImage('assets/images/off.png'),
                borderRadius: const BorderRadius.all(Radius.circular(15)),

                height: 30.0,
                enabled: true,
                disabledOpacity: 0.5,
              ),
               SizedBox(height: _deviceHeight * 0.03),
              InkWell(
                onTap: (){

                },
                child: Container(
                   width:_deviceWidth * 0.09 ,
                height: _deviceHeight * 0.06 ,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16)
                ),
                  
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add,color: Colors.white,),
                      Text("Add ROI",style: TextStyle(color:  Colors.white),)
                    ],
                  ),
                ),
              )
            
            ],
          ),
        ));
  }
}
