import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:denguecare_firebase/views/admins/admin_homepage.dart';
import 'package:denguecare_firebase/views/login_page.dart';
import 'package:denguecare_firebase/views/users/user_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //FirebaseFirestore.instance.settings =
  //const Settings(persistenceEnabled: true);
//SemaphoreAPI();
  runApp(const MyApp());
}

class CustomDotEnv extends DotEnv {
  void addAll(Map<String, String> other) {
    env.addAll(other);
  }
}

final customDotenv = CustomDotEnv();

Future<void> loadDotenv() async {
  final envString = await rootBundle.loadString('.env');
  final Map<String, String> envVars = <String, String>{};

  final lines = envString.split('\n');
  for (final line in lines) {
    final index = line.indexOf('=');
    if (index != -1) {
      final name = line.substring(0, index).trim();
      final value = line.substring(index + 1).trim();
      envVars[name] = value;
    }
  }

  customDotenv.addAll(envVars);
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        //scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        title: 'Dengue Care App',
        home: const MainPage(),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const RouterWidget();
            } else {
              return const LoginPage();
            }
          },
        ),
      );
}

// void router() {
//   User? user = FirebaseAuth.instance.currentUser;
//   var kk = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .get()
//       .then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//       if (documentSnapshot.get('role') == "Admin") {
//         return const AdminHomePage();
//       } else if (documentSnapshot.get('role') == "User") {
//         return const UserMainPage();
//       }
//     } else {
//       return const LoginPage();
//     }
//   });
// }

class RouterWidget extends StatelessWidget {
  const RouterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // You can return a loading indicator here if needed
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final role = snapshot.data?.get('role') ?? '';

          switch (role) {
            case 'Admin':
              return const AdminMainPage();
            case 'superadmin':
              return const AdminMainPage();
            case 'User':
              return const UserMainPage();
            default:
              return const LoginPage();
          }
        }
      },
    );
  }

  Future<DocumentSnapshot> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }
}
