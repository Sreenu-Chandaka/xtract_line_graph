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
    List<Map<String, dynamic>> exampleData = [
      {
        'id': 'user1',
        'name': 'Mike',
        'age': 20,
        'role': 'Programmer',
        'joined': '2021-01-01',
        'working_time': '09:00',
        'salary': 300,
      },
      {
        'id': 'user2',
        'name': 'Jack',
        'age': 25,
        'role': 'Designer',
        'joined': '2021-02-01',
        'working_time': '10:00',
        'salary': 400,
      },
      {
        'id': 'user3',
        'name': 'Suzi',
        'age': 40,
        'role': 'Owner',
        'joined': '2021-03-01',
        'working_time': '11:00',
        'salary': 700,
      },
    ];

    // Set dynamic data to the controller
    _controller.setData(exampleData);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]); // Reset orientation preferences
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
