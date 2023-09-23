import 'package:denguecare_firebase/views/widgets/report_list.dart';
import 'package:flutter/material.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ReportListWidget(),
    );
  }
}
