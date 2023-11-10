import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/views/admins/admin_homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class adminLogs extends StatefulWidget {
  const adminLogs({super.key});

  @override
  State<adminLogs> createState() => _adminLogsState();
}

class _adminLogsState extends State<adminLogs> {
  late Stream<QuerySnapshot> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = FirebaseFirestore.instance
        .collection('admin_logs')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Logs'),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => const AdminMainPage());
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          }

          // Create a list of DataRow based on the documents in the collection
          List<DataRow> dataRows =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            // Modify the columns according to your data structure
            return DataRow(
              cells: [
                DataCell(Text(data['action'].toString())),
                DataCell(Text(data['admin_email'].toString())),
                DataCell(Text(data['document_id'].toString())),
                DataCell(Text(data['timestamp'].toString())),
                // Add more DataCells for each field
              ],
            );
          }).toList();

          // Create DataColumn for each field
          List<DataColumn> dataColumns = [
            DataColumn(label: Text('Action')),
            DataColumn(label: Text('Admin Email')),
            DataColumn(label: Text('Document ID')),
            DataColumn(label: Text('Time Stamp')),
            // Add more DataColumns for each field
          ];

          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  columns: dataColumns,
                  rowsPerPage: 10,
                  header: Text('Admin Logs'),
                  source: MyDataTableSource(dataRows),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<DataRow> _dataRows;

  MyDataTableSource(this._dataRows);

  @override
  DataRow getRow(int index) {
    return _dataRows[index];
  }

  @override
  int get rowCount => _dataRows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
