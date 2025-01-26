import 'package:example/anything_picker2.dart';
import 'package:example/example_page.dart';
import 'package:example/anything_data.dart';
import 'package:example/anything_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_info_plus/language_info_plus.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeLanguage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  showBottomModalDialog({
    required BuildContext context,
    required bool isLight,
    required List<Widget> children,
  }) {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext modalContext) => Container(
            decoration: BoxDecoration(
              // color: isLight
              //     ? LightThemeColors.white
              //     : DarkThemeColors.cardBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            child: Material(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25.0)),
                // color: isLight
                //     ? LightThemeColors.white
                //     : DarkThemeColors.cardBackground,
                child: Column(
                    mainAxisSize: MainAxisSize.max, children: children))));
  }

  void _incrementCounter() {
    Navigator.push(
        context,
        MaterialWithModalsPageRoute(
          builder: (_) => ExamplePage(),
        ));

    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //         fullscreenDialog: true, builder: (context) => ModalInsideModal()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            middle: Text('iOS13 Modal Presentation'),
            trailing: GestureDetector(
              child: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).pushNamed('ss'),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
