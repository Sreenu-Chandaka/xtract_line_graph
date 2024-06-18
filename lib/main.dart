// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://jdhsuxetjdzwdznipbvm.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpkaHN1eGV0amR6d2R6bmlwYnZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg2OTE1NjMsImV4cCI6MjAzNDI2NzU2M30.kFeVsszukI3fEJw5Fk1olQ_VGW51EXG59Ml01u8WjDU",
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<int> timeList;
  late List<int> speedList;
  late List<LiveData> chartData;

  @override
  void initState() {
    super.initState();
    timeList = [];
    speedList = [];
    chartData = [];
    fetchDataAndBuildChart();
  }

  Future<void> fetchDataAndBuildChart() async {
    await getGraphData();
    setState(() {
      chartData = getChartData(timeList, speedList);
    });
  }

  Future<void> getGraphData() async {
    final response = await supabase.from('graph_table').select('time, speed');

    timeList.clear();
    speedList.clear();

    for (var row in response as List<dynamic>) {
      timeList.add(row['time'] as int);
      speedList.add(row['speed'] as int);
    }
  }

  List<LiveData> getChartData(List<int> timeList, List<int> speedList) {
    List<LiveData> chartData = [];

    int minLength = timeList.length < speedList.length ? timeList.length : speedList.length;

    for (int i = 0; i < minLength; i++) {
      chartData.add(LiveData(timeList[i], speedList[i]));
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          series: <LineSeries<LiveData, int>>[
            LineSeries<LiveData, int>(
              dataSource: chartData,
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
        ),
      ),
    );
  }
}

class LiveData {
  final int time;
  final int speed;

  LiveData(this.time, this.speed);
}
