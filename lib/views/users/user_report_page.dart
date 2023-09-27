import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/views/widgets/input_contact_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utility/utils_success.dart';
import '../widgets/input_address_widget.dart';
import '../widgets/input_age_widget.dart';
import '../widgets/input_widget.dart';

class UserReportPage extends StatefulWidget {
  const UserReportPage({super.key});

  @override
  State<UserReportPage> createState() => _UserReportPageState();
}

class _UserReportPageState extends State<UserReportPage> {
  bool _isSubmitting = false;
  Widget _buildProgressIndicator() {
    if (_isSubmitting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(); // Return an empty container if _isSubmitting is false
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactnumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _headache = false;
  bool _bodymalaise = false;
  bool _myalgia = false;
  bool _arthralgia = false;
  bool _retroOrbitalPain = false;
  bool _anorexia = false;
  bool _nausea = false;
  bool _vomiting = false;
  bool _diarrhea = false;
  bool _flushedSkin = false;
  bool _fever = false;
  bool _lowPlateLet = false;
  String? value;
  final sex = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a case'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          PopupMenuButton<int>(
            padding: EdgeInsets.zero,
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: const Icon(
                    Icons.translate,
                    color: Colors.black,
                    size: 26,
                  ),
                  title: const Text('Language'),
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Choose Language"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            TextButton(
                              onPressed: () {},
                              child: const Text("English"),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Tagalog"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("Report a case",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      _gap(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Please enter the following details.",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center),
                      ),
                      _gap(),
                      InputWidget(
                        hintText: "Name",
                        controller: _nameController,
                        obscureText: false,
                      ),
                      _gap(),
                      Row(
                        children: [
                          Expanded(
                            child: InputAgeWidget(
                              hintText: "Age",
                              controller: _ageController,
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  items: sex.map(buildMenuItem).toList(),
                                  value: value,
                                  hint: const Text('Sex'),
                                  onChanged: (value) =>
                                      setState(() => this.value = value),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _gap(),
                      //! CONTACT NUMBER
                      InputContactNumber(
                        hintText: "Contact Number (10-digit)",
                        controller: _contactnumberController,
                        obscureText: false,
                      ),
                      _gap(),
                      InputAddressWidget(
                        labelText: "Address",
                        controller: _addressController,
                        obscureText: false,
                      ),
                      _gap(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("Symptoms",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      _gap(),
                      Row(
                        //! row for headache & body malaise
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              value: _headache,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _headache = value;
                                });
                              },
                              title: const Text('Headache'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _bodymalaise,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _bodymalaise = value;
                                });
                              },
                              title: const Text('Body Malaise'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        //! row for Myalgia & Arthralgia
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              value: _myalgia,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myalgia = value;
                                });
                              },
                              title: const Text('Myalgia'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _arthralgia,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _arthralgia = value;
                                });
                              },
                              title: const Text('Arthralgia'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        //! row for retro_orbital_pain & anorexia
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              value: _retroOrbitalPain,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _retroOrbitalPain = value;
                                });
                              },
                              title: const Text('Retro Orbital Pain'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _anorexia,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _anorexia = value;
                                });
                              },
                              title: const Text('Anorexia'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        //! row for nausea & vomiting
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              value: _nausea,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _nausea = value;
                                });
                              },
                              title: const Text('Nausea'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _vomiting,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _vomiting = value;
                                });
                              },
                              title: const Text('Vomiting'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        //! row for Diarrhea & Flushed skin and Skin rash
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              value: _diarrhea,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _diarrhea = value;
                                });
                              },
                              title: const Text('Diarrhea'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _flushedSkin,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _flushedSkin = value;
                                });
                              },
                              title: const Text('Rashes'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        //! row for On and off fever and Low PlateLet Count
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              value: _fever,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _fever = value;
                                });
                              },
                              title: const Text('On and Off Fever'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _lowPlateLet,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _lowPlateLet = value;
                                });
                              },
                              title: const Text('Low platelet count'),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      _gap(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            uploadDataToFirebase();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void uploadDataToFirebase() async {
    setState(() {
      _isSubmitting = true; // Begin submission
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    try {
      CollectionReference reports =
          FirebaseFirestore.instance.collection('reports');
      const CircularProgressIndicator();
      await reports.add({
        'name': _nameController.text,
        'age': _ageController.text,
        'sex': value,
        'contact_number': _contactnumberController.text,
        'address': _addressController.text,
        'headache': _headache,
        'body_malaise': _bodymalaise,
        'myalgia': _myalgia,
        'arthralgia': _arthralgia,
        'retroOrbitalPain': _retroOrbitalPain,
        'anorexia': _anorexia,
        'nausea': _nausea,
        'vomiting': _vomiting,
        'diarrhea': _diarrhea,
        'flushedSkin': _flushedSkin,
        'fever': _retroOrbitalPain,
        'lowPlateLet': _lowPlateLet,
        'date': FieldValue.serverTimestamp(),
        'emailid': user!.email!,
        // Add other fields as necessary
      });

      UtilSuccess.showSuccessSnackBar(
        text: 'Success!',
        action: SnackBarAction(label: 'text', onPressed: () {}),
      );
    } catch (e) {
      //  Utils.showSnackBar(e.toString());
    } finally {
      _isSubmitting = false;
      resetForm();
    }
  }

  void resetForm() {
    setState(() {
      _nameController.clear();
      _ageController.clear();
      _addressController.clear();
      _contactnumberController.clear();
      _addressController.clear();
      value = 'Male';
      _headache = false;
      _bodymalaise = false;
      _myalgia = false;
      _arthralgia = false;
      _retroOrbitalPain = false;
      _anorexia = false;
      _nausea = false;
      _vomiting = false;
      _diarrhea = false;
      _flushedSkin = false;
      _fever = false;
      _lowPlateLet = false;
    });
  }
}

Widget _gap() => const SizedBox(height: 16);
DropdownMenuItem<String> buildMenuItem(String sex) => DropdownMenuItem(
      value: sex,
      child: Text(sex),
    );

void handleClick(int item) {
  switch (item) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
  }
}
