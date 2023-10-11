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
      stream: FirebaseFirestore.instance
          .collection('reports')
          .orderBy('date', descending: true)
          .snapshots(),
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
            String formattedDate = DateFormat('MMMMd').format(dateTime);
            return Container(
              width: 50,
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  title: Text(
                    '${'' + data['name']} | Age: ' + data['age'],
                    style: GoogleFonts.poppins(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    data['contact_number'],
                    style: GoogleFonts.poppins(fontSize: 14),
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
                      // const SizedBox(
                      //   width: 8,
                      // ),

                      Text(
                        formattedDate,
                        style: GoogleFonts.poppins(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.offAll(() => AdminViewReportedCasesPage(
                              reportedCaseData: data));
                        },
                        icon: const Icon(Icons.edit_note_rounded),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.check_rounded),
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

class StatusIcon extends StatelessWidget {
  final Color color;

  const StatusIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.0, // diameter
      height: 10.0, // diameter
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
