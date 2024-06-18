import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:xtract/graph_provider.dart';
import 'package:xtract/live_data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

  await Supabase.initialize(
    url: "https://jdhsuxetjdzwdznipbvm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpkaHN1eGV0amR6d2R6bmlwYnZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg2OTE1NjMsImV4cCI6MjAzNDI2NzU2M30.kFeVsszukI3fEJw5Fk1olQ_VGW51EXG59Ml01u8WjDU",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GraphProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

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
      home: const MyHomePage(title: 'Live Graph Chart'),
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
  late GraphProvider graphProvider;
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  void initState() {
    graphProvider=Provider.of(context,listen: false);
    super.initState();
   
    
    
    Future.delayed(const Duration(milliseconds: 320), () {
      graphProvider.getGraph();
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight=MediaQuery.of(context).size.height;
    _deviceWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: (){
            graphProvider.addData(
              time: 300,
              speed: 55,
              success: (){

            }, failure: (){});
          }, icon: Icon(Icons.add,size: 24,))
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.only(left:24.0,right: _deviceHeight*0.5,bottom: 8),
        child: Consumer<GraphProvider>(
          builder: (context, graphProvider, child) {
            return StreamBuilder<List<LiveData>>(
              stream: graphProvider.sGraphs,
              builder: (context, snapshot) {
                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return SfCartesianChart(
                  onDataLabelRender: (dataLabelArgs) {
                    
                  },
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
      ),
    );
  }
}
