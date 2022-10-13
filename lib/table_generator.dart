import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vfc/connector.dart';

import 'score_row.dart';

class TableGenerator{
  const TableGenerator();

  final Connector connector = const Connector();

  Widget retail(bool screen, BuildContext context, String timer, String game){
    TextStyle tableHeaderStyle = const TextStyle(color: Colors.white, fontSize: 20);
    return TimerBuilder.periodic(const Duration(seconds: 3), builder: (context){
      return FutureBuilder(
        future: generate(context, timer, game, screen),
        builder: (context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            return (screen) ?
            tableTV(snapshot.data, tableHeaderStyle) : 
            tableOperator(snapshot.data, null);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        });
    });
  }

  Widget tableTV(List<DataRow> dataRows, TextStyle? tableHeaderStyle){
    return DataTable2(
      dataRowHeight: 90,
      columns: [
        DataColumn2(fixedWidth: 100, label: Text("#", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.L, label: Text("Last Name", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.L, label: Text("Jump", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.L, label: Text("Dribbling", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.L, label: Text("Pass", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.L, label: Text("Accuracy", style: tableHeaderStyle)),
      ], 
      dividerThickness: 10,
      rows: dataRows
    );
  }

  Widget tableOperator(List<DataRow> dataRows, TextStyle? tableHeaderStyle){
    return DataTable(
      dataRowHeight: 90,
      columns: [
        DataColumn2(fixedWidth: 100, label: Text("#", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.L, label: Text("Last Name", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Jump", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Dribbling", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Pass", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Accuracy", style: tableHeaderStyle)),
        DataColumn2(fixedWidth: 120, label: Text(" ", style: tableHeaderStyle)),
      ], 
      dividerThickness: 10,
      rows: dataRows
    );
  }

  Future<List<DataRow>> generate(BuildContext context, String timer, String game, bool screen) async {
    try{
      var response = await connector.getScoreBoardData();
      Map<String, dynamic> data = response;
      List<DataRow> dataRows = [];
      List<ScoreRow> cells = [];
      timer = "Match #00${data["id"]} - ${DateTime.now().hour}:${DateTime.now().minute}";
      if(response["players"] != null){
        (data["players"] as Map<String, dynamic>).forEach((key, value) {
          cells.add(ScoreRow.fromJson({key: value})); 
        }); 
      }
      if(screen){
        for(int index = 0; index < cells.length; index++){
          dataRows.add(
            DataRow(
              cells: [
                DataCell(cells.elementAt(index).getPlayerNumber(null)), 
                DataCell(cells.elementAt(index).getLastName(null)), 
                DataCell(cells.elementAt(index).getJump(null)), 
                DataCell(cells.elementAt(index).getDribbling(null)), 
                DataCell(cells.elementAt(index).getPass(null)), 
                DataCell(cells.elementAt(index).getAccuracy(null)), 
              ],
            ),
          );
        }
      } else {
        for(int index = 0; index < cells.length; index++){
          dataRows.add(
            DataRow(
              onLongPress: () => Routemaster.of(context).push("/$game/?id=${cells.elementAt(index).id}"), 
              cells: [
                DataCell(cells.elementAt(index).getPlayerNumber(null)), 
                DataCell(cells.elementAt(index).getLastName(null)), 
                DataCell(cells.elementAt(index).getJumpProgress(null)), 
                DataCell(cells.elementAt(index).getDribblingProgress(null)), 
                DataCell(cells.elementAt(index).getPassProgress(null)), 
                DataCell(cells.elementAt(index).getAccuracyProgress(null)), 
                DataCell(cells.elementAt(index).getDeleteButton())
              ],
            ),
          );
        }
      }
      return dataRows;
    } catch (e){
      debugPrint("[Error on generate()]: $e");
      return [];
    }
  }
}

