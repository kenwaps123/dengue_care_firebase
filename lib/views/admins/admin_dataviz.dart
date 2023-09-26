import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminDataVizPage extends StatefulWidget {
  const AdminDataVizPage({super.key});

  @override
  State<AdminDataVizPage> createState() => _AdminDataVizPageState();
}

class _AdminDataVizPageState extends State<AdminDataVizPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: const Text("Test"),
        floatingActionButton: FloatingActionButton(
          heroTag: 'Pickerfile',
          onPressed: () async {
            PermissionStatus status = await Permission.storage.request();
            if (status == PermissionStatus.granted) {
              _pickAndUploadFile();
            }
            if (status == PermissionStatus.denied) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("this persdkfsf")));
            }

            print(status.toString());
          },
          tooltip: 'Pick A File',
          child: const Icon(Icons.add),
        ),
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

  Future _pickAndUploadFile() async {
    final CollectionReference addDLL =
        FirebaseFirestore.instance.collection('dll');
    FilePicker? filePicker;

    List<Map<String, dynamic>> dataList = [];
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
        List<List<dynamic>> data = [];
        data = csvTable;

        for (var i = 0; i < data.length; i++) {
          var record = {
            'Region': data[i][1],
            'Province': data[i][2],
            'Muncity': data[i][3],
            'Streetpurok': data[i][4],
            'DateOfEntry': data[i][5],
            'DRU': data[i][6],
            'PatientNumber': data[i][7],
            'FirstName': data[i][8],
            'FamilyName': data[i][9],
            'FullName': data[i][10],
            'AgeYears': data[i][11],
            'AgeMons': data[i][12],
            'AgeDays': data[i][13],
            'Sex': data[i][14],
            'AddressOfDRU': data[i][15],
            'ProvOfDRU': data[i][16],
            'MuncityOfDRU': data[i][17],
            'DOB': data[i][18],
            'Admitted': data[i][19],
            'DAdmit': data[i][20],
            'DOnset': data[i][21],
            'Type': data[i][22],
            'LabTest': data[i][23],
            'LabRes': data[i][24],
            'ClinClass': data[i][25],
            'CaseClassification': data[i][26],
            'Outcome': data[i][27],
            'RegionOfDrU': data[i][28],
            'EPIID': data[i][29],
            'DateDied': data[i][30],
            'Icd10Code': data[i][31],
            'MorbidityMonth': data[i][32],
            'MorbidityWeek': data[i][33],
            'AdmitToEntry': data[i][34],
            'OnsetToAdmit': data[i][35],
            'SentinelSite': data[i][36],
            'DeleteRecord': data[i][37],
            'Year': data[i][38],
            'Recstatus': data[i][39],
            'UniqueKey': data[i][40],
            'NameOfDru': data[i][41],
            'ILHZ': data[i][42],
            'District': data[i][43],
            /*'Barangay': data[i][44],
          'TYPEHOSPITALCLINIC': data[i][45],
          'SENT': data[i][46],
          'ip': data[i][47],
          'ipgroup': data[i][48],*/
          };

          addDLL.add(record);
          dataList.add(record);
          print('Data Added');
        }

        await storeDataInFirestore(dataList);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> storeDataInFirestore(List<dynamic> jsonData) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      for (var entry in jsonData) {
        await firestore.collection('dll').add(entry);
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      print('Error storing data in Firestore: $e');
    }
  }
}
