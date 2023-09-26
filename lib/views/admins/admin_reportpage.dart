import 'package:denguecare_firebase/views/widgets/report_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_homepage.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List of reported cases'),
          leading: BackButton(
            onPressed: () {
              Get.offAll(() => const AdminMainPage());
            },
          ),
        ),
        body: const ReportListWidget(),
      ),
    );
  }
}
