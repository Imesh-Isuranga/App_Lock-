import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Application> _apps = [];
  List<bool> _apps_lock_Status = [];
  bool _isLoading = true;
  bool light = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _fetchApps();
  }

  void _fetchApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeAppIcons: true,
        includeSystemApps: true);

    for (Application a in apps) {
      _apps_lock_Status.add(false);
    }

    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Locker for Students',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Locker'),
        ),
        body: SingleChildScrollView(
          child: Table(
            children: _apps.map((app) {
              // Convert the app's icon to an Image
              Widget appIcon;
              int index = _apps.indexOf(app);
              if (app is ApplicationWithIcon) {
                appIcon = Image.memory(
                  app.icon,
                  width: 2, // Set icon size
                  height: 40,
                  fit: BoxFit.scaleDown, // Fit the icon properly
                );
              } else {
                appIcon = const Icon(Icons.broken_image); // Fallback if no icon
              }

              // Create a new TableRow for each app in the _apps list
              return TableRow(children: [
                appIcon, // A random icon, you can change it
                Text(app.appName), // App name
                Switch(
                  // This bool value toggles the switch.
                  value: _apps_lock_Status[index],
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      _apps_lock_Status[index] = value;
                      light = value;
                    });
                  },
                ), // Package name
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
