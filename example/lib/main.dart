//import 'package:flex_color_picker/flex_color_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:updat/updat.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:updat/theme/chips/floating_with_silent_download.dart';

void main() {
  runApp(MyApp());
}

  class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeModeManager(
        defaultThemeMode: ThemeMode.light,
        builder: (themeMode) {
          return MaterialApp(
            title: 'Updat Demo',
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
              primaryColor: Color(0xff1890ff),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData.dark()
                .copyWith(primaryColor: Colors.blue, useMaterial3: true),
            themeMode: themeMode,
            home: MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var show = true;
  var elevated = false;

  TextEditingController titleController =
      TextEditingController(text: "Update Available");
  TextEditingController subtitleController =
      TextEditingController(text: "New version available");
  Color color = Color(0xff1890ff);

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    titleController.addListener(() {
      setState(() {});
    });
    subtitleController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: UpdatWidget(
        getLatestVersion: () async {
          // Github gives us a super useful latest endpoint, and we can use it to get the latest stable release
          final data = await http.get(Uri.parse(
            "https://api.github.com/repos/fluttertools/sidekick/releases/latest",
          ));

          // Return the tag name, which is always a semantically versioned string.
          return jsonDecode(data.body)["tag_name"];
        },
        getBinaryUrl: (version) async {
          // Github also gives us a great way to download the binary for a certain release (as long as we use a consistent naming scheme)

          // Make sure that this link includes the platform extension with which to save your binary.
          // If you use https://exapmle.com/latest/macos for instance then you need to create your own file using `getDownloadFileLocation`
          return "https://github.com/fluttertools/sidekick/releases/download/$version/sidekick-${Platform.operatingSystem}-$version.$platformExt";
        },
        appName: "Updat Example", // This is used to name the downloaded files.
        getChangelog: (_, __) async {
          // That same latest endpoint gives us access to a markdown-flavored release body. Perfect!
          final data = await http.get(Uri.parse(
            "https://api.github.com/repos/fluttertools/sidekick/releases/latest",
          ));
          return jsonDecode(data.body)["body"];
        },
        updateChipBuilder: floatingExtendedChipWithSilentDownload,
        currentVersion: '0.0.1',
        callback: (status) {
          print(status);
        },
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 50, right: 50),
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Updat Flutter Demo",
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.code_rounded),
                      onPressed: () {
                        launchUrlString("https://github.com/aguilaair/updat");
                      },
                      label: Text("View the code"),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.open_in_browser_rounded,
                        color: Color(0xff1890ff),
                      ),
                      onPressed: () {
                        launchUrlString("https://pub.dev/packages/updat");
                      },
                      label: Text(
                        "View the Package",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Hello! Try customizing the update widget's display text and colors."),
                Divider(
                  height: 20,
                ),
                Wrap(
                  spacing: 40,
                  runSpacing: 20,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Change the theme:"),
                        SizedBox(
                          height: 22,
                        ),
                        Switch(
                            value: ThemeModeManager.of(context)!._themeMode ==
                                ThemeMode.dark,
                            onChanged: (value) {
                              ThemeModeManager.of(context)!.themeMode =
                                  value ? ThemeMode.dark : ThemeMode.light;
                            }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Credits to https://github.com/BlueCowGroup/thememode_selector for this section
// Copyright (c) 2021 Blue Cow Group, LLC
class ThemeModeManager extends StatefulWidget {
  final Widget Function(ThemeMode? themeMode)? builder;
  final ThemeMode? defaultThemeMode;

  const ThemeModeManager({Key? key, this.builder, this.defaultThemeMode})
      : super(key: key);

  @override
  _ThemeModeManagerState createState() =>
      _ThemeModeManagerState(themeMode: defaultThemeMode);

  static _ThemeModeManagerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeModeManagerState>();
  }
}

class _ThemeModeManagerState extends State<ThemeModeManager> {
  ThemeMode? _themeMode;

  _ThemeModeManagerState({ThemeMode? themeMode}) : _themeMode = themeMode;

  set themeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      setState(() {
        _themeMode = mode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(_themeMode);
  }
}

String get platformExt {
  switch (Platform.operatingSystem) {
    case 'windows':
      {
        return 'msix';
      }

    case 'macos':
      {
        return 'dmg';
      }

    case 'linux':
      {
        return 'AppImage';
      }
    default:
      {
        return 'zip';
      }
  }
}
