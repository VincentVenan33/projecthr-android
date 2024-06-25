import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project/home/dashboard/dashboard.dart';
import 'package:project/home/login/login.dart';
import 'package:project/services/pref_helper.dart';

import 'app/my_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Check if you received the link via `getInitialLink` first
  await FirebaseDynamicLinks.instance.getInitialLink();

  FirebaseDynamicLinks.instance.onLink.listen(
    (pendingDynamicLinkData) {
      // Set up the `onLink` event listener next as it may be received here
      final Uri deepLink = pendingDynamicLinkData.link;

      print('ini link $deepLink');
      // Example of using the dynamic link to push the user to a different screen
    },
  );
  final token = await PrefHelper().getToken();
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PrefHelper().getToken(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return const Dashboard();
        } else {
          //kalo ga ada tokennya maka ke halaman login
          return const Login();
        }
      },
    );
  }
}
