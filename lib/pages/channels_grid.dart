import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../controller/channel_grid_controller.dart';


class ChannelsGrid extends StatefulWidget {
  const ChannelsGrid({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChannelsGridState();
  }
}

class _ChannelsGridState extends State<ChannelsGrid> {
 
  final _controller = Get.put(ChannelsGridController());

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    // Example data (you should replace this with actual dynamic data)
  

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]); // Reset orientation preferences
    super.dispose();
  }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true,),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Obx(
            () => PlutoGrid(
              columns: _controller.dataColumnsList.value,
              rows: _controller.dataRowsList.value,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                _controller.stateManager = event.stateManager;
              //   _controller.stateManager.setShowColumnFilter(true);
              },
              onChanged: (PlutoGridOnChangedEvent event) {
                print('Old Value: ${event.oldValue}');
                print('New Value: ${event.value}');
              },
              configuration: const PlutoGridConfiguration(),
            ),
          ),
        ),
      ),
    );
  }
}
