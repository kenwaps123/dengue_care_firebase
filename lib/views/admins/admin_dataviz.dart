import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:denguecare_firebase/charts/testchart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:denguecare_firebase/charts/linechart.dart';
// import 'package:denguecare_firebase/charts/linechart2.dart';

class AdminDataVizPage extends StatefulWidget {
  const AdminDataVizPage({super.key});

  @override
  State<AdminDataVizPage> createState() => _AdminDataVizPageState();
}

class _AdminDataVizPageState extends State<AdminDataVizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: testChart(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Pickerfile',
        onPressed:
            _pickAndUploadFile /*() async {
          PermissionStatus status = await Permission.storage.request();
          if (status == PermissionStatus.granted) {
            _pickAndUploadFile();
          }
          if (status == PermissionStatus.denied) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("this persdkfsf")));
          }

          print(status.toString());
        }*/
        ,
        tooltip: 'Pick A File',
        child: const Icon(Icons.add),
      ),
    );
  }

  // void requestStoragePermission() async {
  //   PermissionStatus status = await Permission.storage.request();

  //   if (status.isGranted) {
  //     _pickAndUploadFile();
  //     // You can now use the storage
  //   } else if (status.isPermanentlyDenied) {
  //     // The user chose to never ask again. You can instruct them to manually enable it from the settings.
  //   } else {
  //     // The permission was denied (possibly temporary)
  //   }
  // }

  Future<void> _pickAndUploadFile() async {
    final CollectionReference addDLL =
        FirebaseFirestore.instance.collection('denguelinelist');

    //List<Map<String, dynamic>> dataList = [];
    try {
      FilePickerResult? pickedfile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (pickedfile != null) {
        Uint8List bytes = pickedfile.files.single.bytes!;
        final csvString = String.fromCharCodes(bytes);
        List<List<dynamic>> csvTable =
            const CsvToListConverter().convert(csvString);
        //print(csvString);
        List<List<dynamic>> data = [];
        data = csvTable;

        for (var i = 0; i < data.length; i++) {
          var record = {
            'Region': data[i][0],
            'Province': data[i][1],
            'Muncity': data[i][2],
            'Streetpurok': data[i][3],
            'DateOfEntry': data[i][4],
            'DRU': data[i][5],
            'PatientNumber': data[i][6],
            'FirstName': data[i][7],
            'FamilyName': data[i][8],
            'FullName': data[i][9],
            'AgeYears': data[i][10],
            'AgeMons': data[i][11],
            'AgeDays': data[i][12],
            'Sex': data[i][13],
            'AddressOfDRU': data[i][14],
            'ProvOfDRU': data[i][15],
            'MuncityOfDRU': data[i][16],
            'DOB': data[i][17],
            'Admitted': data[i][18],
            'DAdmit': data[i][19],
            'DOnset': data[i][20],
            'Type': data[i][21],
            'LabTest': data[i][22],
            'LabRes': data[i][23],
            'ClinClass': data[i][24],
            'CaseClassification': data[i][25],
            'Outcome': data[i][26],
            'RegionOfDrU': data[i][27],
            'EPIID': data[i][28],
            'DateDied': data[i][29],
            'Icd10Code': data[i][30],
            'MorbidityMonth': data[i][31],
            'MorbidityWeek': data[i][32],
            'AdmitToEntry': data[i][33],
            'OnsetToAdmit': data[i][34],
            'SentinelSite': data[i][35],
            'DeleteRecord': data[i][36],
            'Year': data[i][37],
            'Recstatus': data[i][38],
            'UniqueKey': data[i][39],
            'NameOfDru': data[i][40],
            'ILHZ': data[i][41],
            'District': data[i][42],
            'Barangay': data[i][43],
            'TYPEHOSPITALCLINIC': data[i][44],
            'SENT': data[i][45],
            'ip': data[i][6],
            'ipgroup': data[i][47],
          };

          final existingRecords = await addDLL
              .where('FullName', isEqualTo: record['FullName'])
              .where('DateOfEntry', isEqualTo: record['DateOfEntry'])
              // Add more where clauses for other fields as needed
              .get();

          if (existingRecords.docs.isEmpty) {
            // If no similar record found, add it to Firestore
            await addDLL.add(record);
            print('Data Added');
          } else {
            // If a similar record exists, handle it (skip or update)
            print('Redundant data found for record $i');
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
