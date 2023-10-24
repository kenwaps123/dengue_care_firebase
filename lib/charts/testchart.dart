import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<DengueData> chart = [];
List<DengueData> chart2 = [];
List<piechartData> chart3 = [];
List<barChart> chart4 = [];

late TooltipBehavior _tooltipBehavior;
late TooltipBehavior _tooltipBehavior2;
late ZoomPanBehavior _zoomPanBehavior;

class DengueData {
  DengueData(this.x, this.y);
  final int x;
  final int y;
}

class piechartData {
  piechartData(this.ageGroup, this.number, this.color);
  String ageGroup;
  double number;
  Color color;
}

class barChart {
  barChart(this.purok, this.cases);
  String purok;
  int cases;
}

class testChart extends StatefulWidget {
  const testChart({super.key});

  @override
  State<testChart> createState() => _testChartState();
}

class _testChartState extends State<testChart> {
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior2 = TooltipBehavior(enable: true);
    _zoomPanBehavior =
        ZoomPanBehavior(enableMouseWheelZooming: true, enablePinching: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        outputChart(),
        outputChart2(),
        output3(),
        if (chart3.isEmpty) queryAgeGroupsCount()
      ]),
      builder: (context, snapshot) {
        //sort to ascending order
        chart.sort((a, b) => a.x.compareTo(b.x));
        chart2.sort((a, b) => a.x.compareTo(b.x));
        chart4.sort((a, b) => a.cases.compareTo(b.cases));
        return SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SfCartesianChart(
                title: ChartTitle(text: "Number of Active Cases Per Month"),
                enableAxisAnimation: true,
                primaryXAxis: NumericAxis(
                    title: AxisTitle(text: "Morbidity Month"),
                    minimum: 0,
                    maximum: 12),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: "Number of Active Cases")),
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries>[
                  LineSeries<DengueData, int>(
                      dataSource: chart,
                      xValueMapper: (DengueData data, _) => data.x,
                      yValueMapper: (DengueData data, _) => data.y,
                      markerSettings: const MarkerSettings(isVisible: true)),
                ],
              ),
              SfCartesianChart(
                title: ChartTitle(text: "Number of Active Cases Per Week"),
                enableAxisAnimation: true,
                primaryXAxis: NumericAxis(
                    title: AxisTitle(text: "Morbidity Week"),
                    minimum: 0,
                    maximum: 48),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: "Number of Active Cases")),
                tooltipBehavior: _tooltipBehavior2,
                series: <ChartSeries>[
                  LineSeries<DengueData, int>(
                      dataSource: chart2,
                      xValueMapper: (DengueData data, _) => data.x,
                      yValueMapper: (DengueData data, _) => data.y,
                      markerSettings: const MarkerSettings(isVisible: true)),
                ],
              ),
              SfCircularChart(
                  title: ChartTitle(text: 'Active Cases Age Group'),
                  series: <CircularSeries>[
                    PieSeries<piechartData, String>(
                        dataSource: chart3,
                        pointColorMapper: (piechartData data, _) => data.color,
                        xValueMapper: (piechartData data, _) => data.ageGroup,
                        yValueMapper: (piechartData data, _) => data.number,
                        dataLabelMapper: (piechartData data, _) =>
                            '${data.ageGroup}:${data.number}',
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true))
                  ]),
              SizedBox(
                height: 500,
                child: SfCartesianChart(
                  //zoomPanBehavior: _zoomPanBehavior,
                  title: ChartTitle(text: 'Active Cases Per Street/Purok'),
                  series: <ChartSeries>[
                    BarSeries<barChart, String>(
                      dataSource: chart4,
                      xValueMapper: (barChart data, _) => data.purok,
                      yValueMapper: (barChart data, _) => data.cases,
                      borderWidth: 3,
                    )
                  ],
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}

Future<Map<int, int>> getDataMonth(String fieldName) async {
  String x = 'MorbidityMonth';
  CollectionReference collection =
      FirebaseFirestore.instance.collection('denguelinelist');
  QuerySnapshot querySnapshot = await collection.get();

  Map<int, int> valueL = {};

  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    if (data.containsKey(x)) {
      var value = data[x];
      valueL[value] = (valueL[value] ?? 0) + 1;
    }
  }

  return valueL;
}

Future<List<DengueData>> outputChart() async {
  Map<int, int> counts = await getDataMonth('MorbidityMonth');
  counts.forEach((x, y) {
    chart.add(DengueData(x, y));
  });
  return chart;
}

Future<Map<int, int>> getDataWeek(String fieldName) async {
  String x = 'MorbidityWeek';
  CollectionReference collection =
      FirebaseFirestore.instance.collection('denguelinelist');
  QuerySnapshot querySnapshot = await collection.get();

  Map<int, int> valueL = {};

  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    if (data.containsKey(x)) {
      var value = data[x];
      valueL[value] = (valueL[value] ?? 0) + 1;
    }
  }

  return valueL;
}

Future<List<DengueData>> outputChart2() async {
  Map<int, int> counts = await getDataWeek('MorbidityWeek');
  counts.forEach((x, y) {
    chart2.add(DengueData(x, y));
  });

  return chart2;
}

Future<List<piechartData>> queryAgeGroupsCount() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int childAgeMin = 0;
  int childAgeMax = 16;

  QuerySnapshot querySnapshot = await firestore
      .collection('denguelinelist')
      .where('AgeYears', isGreaterThanOrEqualTo: childAgeMin)
      .where('AgeYears', isLessThanOrEqualTo: childAgeMax)
      .get();

  double ageGroupCount = querySnapshot.size.toDouble();
  chart3.add(piechartData('Child', ageGroupCount, Colors.blue));

  int yAdultAgeMin = 17;
  int yAdultAgeMax = 30;

  QuerySnapshot querySnapshot2 = await firestore
      .collection('denguelinelist')
      .where('AgeYears', isGreaterThanOrEqualTo: yAdultAgeMin)
      .where('AgeYears', isLessThanOrEqualTo: yAdultAgeMax)
      .get();

  double ageGroupCount2 = querySnapshot2.size.toDouble();
  chart3.add(piechartData('Young Adult', ageGroupCount2, Colors.red));

  int mAdultAgeMin = 31;
  int mAdultAgeMax = 45;

  QuerySnapshot querySnapshot3 = await firestore
      .collection('denguelinelist')
      .where('AgeYears', isGreaterThanOrEqualTo: mAdultAgeMin)
      .where('AgeYears', isLessThanOrEqualTo: mAdultAgeMax)
      .get();

  double ageGroupCount3 = querySnapshot3.size.toDouble();
  chart3.add(piechartData('Middle Adult', ageGroupCount3, Colors.green));

  int oAdultAgeMin = 45;

  QuerySnapshot querySnapshot4 = await firestore
      .collection('denguelinelist')
      .where('AgeYears', isGreaterThan: oAdultAgeMin)
      .get();

  double ageGroupCount4 = querySnapshot4.size.toDouble();
  chart3.add(piechartData('Old Adult', ageGroupCount4, Colors.yellow));
  return chart3;
}

Future<Map<String, int>> getPurokCases(String purok) async {
  String x = 'Streetpurok';
  CollectionReference collection =
      FirebaseFirestore.instance.collection('denguelinelist');
  QuerySnapshot querySnapshot = await collection.get();

  Map<String, int> casesByPurok = {};

  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    if (data.containsKey(x)) {
      var value = data[x];
      casesByPurok[value] = (casesByPurok[value] ?? 0) + 1;
    }
  }
  print(casesByPurok);
  return casesByPurok;
}

Future<List<barChart>> output3() async {
  Map<String, int> counts = await getPurokCases('Streetpurok');
  counts.forEach((x, y) {
    chart4.add(barChart(x, y));
    print((x, y));
  });

  return chart4;
}
