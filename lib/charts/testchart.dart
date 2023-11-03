import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<DengueData> chart = [];
List<DengueData> chart2 = [];
List<DengueData> chart3 = [];
List<piechartData> pieChart = [];
List<StreetPurokData> barChart = [];
List<int> listYear = [];

int selectedYear = DateTime.now().year;
double minYear = 0;
double maxYear = 0;

double a1 = 0;
double a2 = 0;
double a3 = 0;
double a4 = 0;

late TooltipBehavior _tooltipBehavior;
late TooltipBehavior _tooltipBehavior2;
late TooltipBehavior _tooltipBehavior3;
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

class StreetPurokData {
  StreetPurokData(this.purok, this.cases);
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
    selectedYear = selectedYear;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior2 = TooltipBehavior(enable: true);
    _tooltipBehavior3 = TooltipBehavior(enable: true);
    _zoomPanBehavior =
        ZoomPanBehavior(enableMouseWheelZooming: true, enablePinching: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        getListYear(),
        getYearlyDataMonth(selectedYear),
        getYearlyDataWeek(selectedYear),
        getDataYear(),
        queryAgeGroupsCount(selectedYear),
        getPurokCases(selectedYear),
      ]),
      builder: (context, snapshot) {
        if (chart.isNotEmpty) {
          chart.sort((a, b) => a.x.compareTo(b.x));
          chart2.sort((a, b) => a.x.compareTo(b.x));
          chart3.sort((a, b) => a.x.compareTo(b.x));
          barChart.sort((a, b) => a.cases.compareTo(b.cases));
          listYear.sort((a, b) => a.compareTo(b));
          minYear = listYear.first - 1;
          maxYear = listYear.last + 1;
          a1 = pieChart[pieChart.length - 4].number;
          a2 = pieChart[pieChart.length - 3].number;
          a3 = pieChart[pieChart.length - 2].number;
          a4 = pieChart[pieChart.length - 1].number;
        } else {}
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a circular progress indicator while waiting for data.
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          // Handle errors.
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        return SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _gap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Sort by: '),
                  DropdownButton<int>(
                    value: selectedYear,
                    items: listYear.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedYear = newValue!;

                        if (selectedYear == newValue) {
                          return;
                        } else {
                          getYearlyDataMonth(selectedYear).then((result) {
                            chart = result;
                          });
                          getYearlyDataWeek(selectedYear).then((result) {
                            chart2 = result;
                          });
                          queryAgeGroupsCount(selectedYear).then((result) {
                            pieChart = result;
                          });

                          getPurokCases(selectedYear).then((result) {
                            barChart = result;
                          });
                        }
                      });
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () =>
                        deleteAllDocumentsInCollection('denguelinelist'),
                    child: const Text('Clear Data'),
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    SfCartesianChart(
                      title:
                          ChartTitle(text: "Number of Active Cases Per Month"),
                      enableAxisAnimation: true,
                      primaryXAxis: NumericAxis(
                          title: AxisTitle(text: "Morbidity Month"),
                          minimum: 0,
                          maximum: 12,
                          interval: 1),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(text: "Number of Active Cases")),
                      tooltipBehavior: _tooltipBehavior,
                      series: <ChartSeries>[
                        LineSeries<DengueData, int>(
                            dataSource: chart,
                            xValueMapper: (DengueData data, _) => data.x,
                            yValueMapper: (DengueData data, _) => data.y,
                            markerSettings:
                                const MarkerSettings(isVisible: true)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    SfCartesianChart(
                      title:
                          ChartTitle(text: "Number of Active Cases Per Week"),
                      enableAxisAnimation: true,
                      primaryXAxis: NumericAxis(
                          title: AxisTitle(text: "Morbidity Week"),
                          minimum: 0,
                          maximum: 48,
                          interval: 1),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(text: "Number of Active Cases")),
                      tooltipBehavior: _tooltipBehavior2,
                      series: <ChartSeries>[
                        LineSeries<DengueData, int>(
                            dataSource: chart2,
                            xValueMapper: (DengueData data, _) => data.x,
                            yValueMapper: (DengueData data, _) => data.y,
                            markerSettings:
                                const MarkerSettings(isVisible: true)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    SfCartesianChart(
                      title:
                          ChartTitle(text: "Number of Active Cases Per Year"),
                      enableAxisAnimation: true,
                      primaryXAxis: NumericAxis(
                          title: AxisTitle(text: "Morbidity Yearly"),
                          minimum: minYear,
                          maximum: maxYear,
                          interval: 1),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(text: "Number of Active Cases")),
                      tooltipBehavior: _tooltipBehavior3,
                      series: <ChartSeries>[
                        LineSeries<DengueData, int>(
                            dataSource: chart3,
                            xValueMapper: (DengueData data, _) => data.x,
                            yValueMapper: (DengueData data, _) => data.y,
                            markerSettings:
                                const MarkerSettings(isVisible: true)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        flex: 1,
                        child: SfCircularChart(
                            title: ChartTitle(text: 'Active Cases Age Group'),
                            series: <CircularSeries>[
                              PieSeries<piechartData, String>(
                                dataSource: pieChart,
                                pointColorMapper: (piechartData data, _) =>
                                    data.color,
                                xValueMapper: (piechartData data, _) =>
                                    data.ageGroup,
                                yValueMapper: (piechartData data, _) =>
                                    data.number,
                                dataLabelMapper: (piechartData data, _) =>
                                    '${data.ageGroup}:${data.number}',
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside),
                              )
                            ])),
                    Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Child(0-16): $a1'),
                            Text('Young Adult(17-30): $a2'),
                            Text('Middle Adult(31-45): $a3'),
                            Text('Old Adult(45 above): $a4')
                          ],
                        ))
                  ],
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: Flexible(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1000,
                          child: SfCartesianChart(
                            //zoomPanBehavior: _zoomPanBehavior,
                            title: ChartTitle(
                                text: 'Active Cases Per Street/Purok'),
                            series: <ChartSeries>[
                              BarSeries<StreetPurokData, String>(
                                dataSource: barChart,
                                xValueMapper: (StreetPurokData data, _) =>
                                    data.purok,
                                yValueMapper: (StreetPurokData data, _) =>
                                    data.cases,

                                //borderWidth: 3,
                              )
                            ],
                            primaryXAxis: CategoryAxis(
                                labelStyle: TextStyle(fontSize: 5)),
                            primaryYAxis: NumericAxis(
                                title:
                                    AxisTitle(text: 'Number of Active Cases'),
                                interval: 1),
                          ),
                        )
                      ],
                    ),
                  )),
            ]),
          ),
        );
      },
    );
  }
}

Future<List<piechartData>> queryAgeGroupsCount(int year) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    double ageGroupCount = 0;
    double ageGroupCount2 = 0;
    double ageGroupCount3 = 0;
    double ageGroupCount4 = 0;

    int childAgeMax = 16;

    QuerySnapshot querySnapshot = await firestore
        .collection('denguelinelist')
        .where('AgeYears', isLessThanOrEqualTo: childAgeMax)
        .where('Year', isEqualTo: year)
        .get();

    ageGroupCount = querySnapshot.size.toDouble();
    pieChart = [];
    pieChart.add(piechartData('Child', ageGroupCount, Colors.blue));

    int yAdultAgeMin = 17;
    int yAdultAgeMax = 30;

    QuerySnapshot querySnapshot2 = await firestore
        .collection('denguelinelist')
        .where('AgeYears', isGreaterThanOrEqualTo: yAdultAgeMin)
        .where('AgeYears', isLessThanOrEqualTo: yAdultAgeMax)
        .where('Year', isEqualTo: year)
        .get();

    ageGroupCount2 = querySnapshot2.size.toDouble();
    pieChart.add(piechartData('Young Adult', ageGroupCount2, Colors.red));

    int mAdultAgeMin = 31;
    int mAdultAgeMax = 45;

    QuerySnapshot querySnapshot3 = await firestore
        .collection('denguelinelist')
        .where('AgeYears', isGreaterThanOrEqualTo: mAdultAgeMin)
        .where('AgeYears', isLessThanOrEqualTo: mAdultAgeMax)
        .where('Year', isEqualTo: year)
        .get();

    ageGroupCount3 = querySnapshot3.size.toDouble();
    pieChart.add(piechartData('Middle Adult', ageGroupCount3, Colors.green));

    int oAdultAgeMin = 45;

    QuerySnapshot querySnapshot4 = await firestore
        .collection('denguelinelist')
        .where('AgeYears', isGreaterThan: oAdultAgeMin)
        .where('Year', isEqualTo: year)
        .get();

    ageGroupCount4 = querySnapshot4.size.toDouble();
    pieChart.add(piechartData('Old Adult', ageGroupCount4, Colors.yellow));

    return Future.delayed(Duration(seconds: 1), () {
      return pieChart;
    });
  } catch (e) {
    return Future.value([]);
  }
}

Future<List<int>> getListYear() async {
  try {
    String x = 'Year';
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot =
        await firestore.collection('denguelinelist').get();

    Set<dynamic> uniqueValues = {};
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey(x)) {
        uniqueValues.add(data[x]);
      }
    }

    if (listYear.isEmpty) {
      uniqueValues.forEach((year) {
        listYear.add(year);
      });
    }

    return listYear;
  } catch (e) {
    print('Empty ListYear');
    return Future.value([]);
  }
}

Future<List<DengueData>> getYearlyDataMonth(int year) async {
  try {
    String x = 'MorbidityMonth';
    CollectionReference collection =
        FirebaseFirestore.instance.collection('denguelinelist');
    QuerySnapshot querySnapshot = await collection.get();

    Map<int, int> valueL = {};

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey(x) && data['Year'] == year) {
        var value = data[x];
        valueL[value] = (valueL[value] ?? 0) + 1;
      }
    }

    chart = [];
    Map<int, int> counts = valueL;
    counts.forEach((x, y) {
      chart.add(DengueData(x, y));
    });

    return Future.delayed(Duration(seconds: 1), () {
      return chart;
    });
  } catch (e) {
    print('Empty Chart');
    return Future.value([]);
  }
}

Future<List<DengueData>> getYearlyDataWeek(int year) async {
  try {
    String x = 'MorbidityWeek';
    CollectionReference collection =
        FirebaseFirestore.instance.collection('denguelinelist');
    QuerySnapshot querySnapshot = await collection.get();

    Map<int, int> valueL = {};

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey(x) && data['Year'] == year) {
        var value = data[x];
        valueL[value] = (valueL[value] ?? 0) + 1;
      }
    }

    chart2 = [];
    Map<int, int> counts = valueL;
    counts.forEach((x, y) {
      chart2.add(DengueData(x, y));
    });

    return Future.delayed(Duration(seconds: 1), () {
      return chart2;
    });
  } catch (e) {
    print('Empty Chart2');
    return Future.value([]);
  }
}

Future<List<DengueData>> getDataYear() async {
  try {
    String x = 'Year';
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

    chart3 = [];
    Map<int, int> counts = valueL;
    counts.forEach((x, y) {
      chart3.add(DengueData(x, y));
    });

    return chart3;
  } catch (e) {
    print('Empty Chart3');
    return Future.value([]);
  }
}

Future<List<StreetPurokData>> getPurokCases(int year) async {
  try {
    String x = 'Streetpurok';
    CollectionReference collection =
        FirebaseFirestore.instance.collection('denguelinelist');
    QuerySnapshot querySnapshot = await collection.get();

    Map<String, int> casesByPurok = {};

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey(x) && data['Year'] == year) {
        var value = data[x];
        casesByPurok[value] = (casesByPurok[value] ?? 0) + 1;
      }
    }

    barChart = [];
    casesByPurok.forEach((x, y) {
      barChart.add(StreetPurokData(x, y));
    });

    return Future.delayed(Duration(seconds: 1), () {
      return barChart;
    });
  } catch (e) {
    print('Empty BarChart');
    return Future.value([]);
  }
}

Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    final QuerySnapshot querySnapshot =
        await firestore.collection(collectionPath).get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (final document in documents) {
      await document.reference.delete();
    }
    a1 = 0;
    a2 = 0;
    a3 = 0;
    a4 = 0;
    print(
        'All documents in the collection "$collectionPath" have been deleted.');
  } catch (e) {
    print('Error deleting documents: $e');
  }
}

Widget _gap() => const SizedBox(height: 8);
