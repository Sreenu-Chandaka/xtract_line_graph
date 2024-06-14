import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(title: const Text('Line Chart'), centerTitle: true, backgroundColor: Colors.black12,),
      body:
      SingleChildScrollView(
        child:
        Container(
          color: Colors.black12,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: LineChartWidget(),
        ),
      ),
    );
  }
}



class Titles{
  static getTitleData()=>FlTitlesData(
    show: true,
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
      showTitles: true,
      // getTextStyles: (value) => const TextStyle(
      //   color: Colors.grey,
      //   fontWeight: FontWeight.bold,fontSize: 13,
      // ),
      getTitlesWidget: (value,meta){
        switch (value.toInt()){
          case 10000:
            return Text("10k",style: TextStyle(color: Colors.white),) ;
          case 20000:
            return Text("20k") ;
          case 30000:
            return Text("30k") ;
          // case 40000:
          //   return Text("40k") ;
          // case 50000:
          //   return Text("50k") ;
          // case 60000:
          //   return Text("60k") ;
          // case 70000:
          //   return Text("70k") ;
        }
        return Container();
        
     
      },
      reservedSize:  35,
    
    )
    ),
    bottomTitles: AxisTitles(
      sideTitles: 
SideTitles(
      showTitles: true,
      reservedSize: 35,
      getTitlesWidget: (value, meta) {
switch (value.toInt()){
          case 20:
            return Text("2020",style: TextStyle(color: Colors.white),);
          case 50:
            return Text("2021",style: TextStyle(color: Colors.white),);
          case 90:
            return Text("2022",style: TextStyle(color: Colors.white),);
      }
      // getTextStyles: (value) => const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
    
  return Container();
  },
  
 
     
    ),
     
    
    )
  );
}












class LineChartWidget extends StatelessWidget {
  final List<Color> gradiantColors = [
    Colors.redAccent,
    Colors.orangeAccent
  ];

  LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:64.0),
      child: LineChart(
        
        LineChartData(
          titlesData: Titles.getTitleData(),
          minX: 0,
          maxX: 100,
          minY: 0,
          maxY: 70000,
         
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value){
              return FlLine(
                color: Colors.grey[800],
                strokeWidth: 1
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[800]!, width: 2)
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0,10000),
                const FlSpot(5,50000),
                const FlSpot(10,20000),
                const FlSpot(15,40000),
                const FlSpot(20,30000),
                const FlSpot(25,60000),
                const FlSpot(30,40000),
                const FlSpot(35,30000),
                const FlSpot(40,40000),
                const FlSpot(45,50000),
                const FlSpot(50,30000),
                const FlSpot(55,20000),
                const FlSpot(60,60000),
                const FlSpot(65,20000),
                const FlSpot(70,40000),
                const FlSpot(75,30000),
                const FlSpot(80,20000),
                const FlSpot(85,50000),
                
                
              ],
              isCurved: true,
              color: Colors.white,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: false,
                color: Colors.orangeAccent
              )
      
            )
          ]
      
        )
      ),
    );
  }
}













