import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../controllers/channel_grid_controller.dart';


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
      
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
             Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  BackButton(),
                  IconButton(onPressed: (){}, icon: Icon(Icons.delete_rounded))
                ],
              )
            ),
            Expanded(
              flex: 15,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                child: Obx(
                  (){return _controller.dataRowsList.isNotEmpty? PlutoGrid(
                    
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
                  ): Center(
                    child: Text("No ROI added. Please go back, select, and add a new ROI value ",style: TextStyle(color: Colors.blue,fontSize: MediaQuery.of(context).size.height * 0.03),),
                  );}
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
