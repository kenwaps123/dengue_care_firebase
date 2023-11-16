import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/views/admins/admin_viewreportedcasespage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportListWidget extends StatefulWidget {
  const ReportListWidget({super.key});

  @override
  State<ReportListWidget> createState() => _ReportListWidgetState();
}

class _ReportListWidgetState extends State<ReportListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('reports').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            // Convert the Timestamp to DateTime
            DateTime dateTime = (data['date'] as Timestamp).toDate();

            // Format the DateTime to display only the date
            String formattedDate = DateFormat('MM/d/yyyy').format(dateTime);

            return Container(
              width: 50,
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: data['checked'] == 'Yes'
                    ? Colors.grey
                    : (data['status'] == 'Suspected'
                        ? Colors.blue
                        : (data['status'] == 'Probable'
                            ? Colors.orange
                            : (data['status'] == 'Confirmed'
                                ? Colors.red
                                : Colors.white))),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ' + data['name'],
                        style: GoogleFonts.poppins(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Age: ' + data['age'],
                        style: GoogleFonts.poppins(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Contact number: ' + data['contact_number'],
                    style: GoogleFonts.poppins(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      //   'Status',
                      //   style: GoogleFonts.poppins(fontSize: 14),
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 1,
                      // ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Date: $formattedDate',
                        style: GoogleFonts.poppins(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      IconButton(
                        onPressed: () {
                          // Get.offAll(() => AdminViewReportedCasesPage(
                          //     reportedCaseData: data));
                          Get.to(() => AdminViewReportedCasesPage(
                              reportedCaseData: data));
                        },
                        icon: const Icon(Icons.edit_note_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          // children: snapshot.data!.docs.map((DocumentSnapshot document) {

          // }).toList(),
        );
      },
    );
  }
}
