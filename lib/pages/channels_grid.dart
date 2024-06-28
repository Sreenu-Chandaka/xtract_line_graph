import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChannelsGrid extends StatefulWidget {
  const ChannelsGrid({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChannelsGridState();
  }
}

class _ChannelsGridState extends State<ChannelsGrid> {
  @override
  void initState() {
    super.initState();

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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              // Datatable widget that have the property columns and rows.
              columns: [
                // Set the name of the column
                DataColumn(
                  label: Text('ID'),
                ),
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text('LastName'),
                ),
                DataColumn(
                  label: Text('Age'),
                ),
              ],
              rows: [
                // Set the values to the columns
                DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                    DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
                  DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                ]),
              
              ]),
        ),
      ),
    );
  }
}
