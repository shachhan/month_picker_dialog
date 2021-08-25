import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:month_picker_dialog/year_picker_dialog.dart';
import 'package:month_picker_dialog/half_picker_dialog.dart';
import 'package:month_picker_dialog/quarter_picker_dialog.dart';

void main() => runApp(MyApp(
      initialDate: DateTime.now(),
    ));

class MyApp extends StatefulWidget {
  final DateTime initialDate;

  const MyApp({Key? key, required this.initialDate}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('zh'),
        Locale('fr'),
        Locale('es'),
        Locale('de'),
        Locale('ru'),
        Locale('ja'),
        Locale('ar'),
        Locale('fa'),
        Locale("es"),
        Locale("ko"),
      ],
      theme: ThemeData(
          primarySwatch: Colors.indigo, accentColor: Colors.pinkAccent),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Month Picker Example App'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Year: ${selectedDate?.year}\nMonth: ${selectedDate?.month}',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showYearPicker(
                      context: context,
                      firstDate: DateTime(selectedDate!.year - 3, 5),
                      lastDate: DateTime(selectedDate!.year + 3, 9),
                      initialDate: selectedDate ?? widget.initialDate,
                      locale: Locale("ko"),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    });
                  },
                  child: Text('Year Picker'),
                ),
              ),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showHalfPicker(
                      context: context,
                      firstDate: DateTime(selectedDate!.year - 3, 5),
                      lastDate: DateTime(selectedDate!.year + 3, 9),
                      initialDate: selectedDate ?? widget.initialDate,
                      locale: Locale("ko"),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    });
                  },
                  child: Text('Half Picker'),
                ),
              ),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showQuarterPicker(
                      context: context,
                      firstDate: DateTime(selectedDate!.year - 3, 5),
                      lastDate: DateTime(selectedDate!.year + 3, 9),
                      initialDate: selectedDate ?? widget.initialDate,
                      locale: Locale("ko"),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    });
                  },
                  child: Text('Quarter Picker'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              showMonthPicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 5, 5),
                lastDate: DateTime(DateTime.now().year, 12),
                initialDate: selectedDate ?? widget.initialDate,
                locale: Locale("ko"),
              ).then((date) {
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              });
            },
            child: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}
