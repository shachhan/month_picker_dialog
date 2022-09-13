import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/src/MonthSelector.dart';
import 'package:month_picker_dialog/src/YearSelector.dart';
import 'package:month_picker_dialog/src/common.dart';
import 'package:month_picker_dialog/src/date_period.dart';
import 'package:month_picker_dialog/src/locale_utils.dart';
import 'package:rxdart/rxdart.dart';

/// Displays week picker dialog.
/// [initialDate] is the initially selected month.
/// [firstDate] is the optional lower bound for month selection.
/// [lastDate] is the optional upper bound for month selection.
Future<DateTime?> showWeekPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Locale? locale,
}) async {
  assert(context != null);
  assert(initialDate != null);
  final localizations = locale == null
      ? MaterialLocalizations.of(context)
      : await GlobalMaterialLocalizations.delegate.load(locale);
  assert(localizations != null);
  return await showDialog<DateTime>(
    context: context,
    builder: (context) => _WeekPickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: locale,
      localizations: localizations,
    ),
  );
}

class _WeekPickerDialog extends StatefulWidget {
  final DateTime? initialDate, firstDate, lastDate;
  final MaterialLocalizations localizations;
  final locale;

  const _WeekPickerDialog({
    Key? key,
    required this.initialDate,
    required this.localizations,
    this.firstDate,
    this.lastDate,
    this.locale,
  }) : super(key: key);

  @override
  _WeekPickerDialogState createState() => _WeekPickerDialogState();
}

class _WeekPickerDialogState extends State<_WeekPickerDialog> {
  final GlobalKey<YearSelectorState> _weekSelectorState = new GlobalKey();

  PublishSubject<UpDownPageLimit>? _upDownPageLimitPublishSubject;
  PublishSubject<UpDownButtonEnableState>?
      _upDownButtonEnableStatePublishSubject;

  Widget? _selector;
  DateTime? selectedDate, _firstDate, _lastDate;

  int firstDayOfWeekIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate =
        DateTime(widget.initialDate!.year, widget.initialDate!.month);
    if (widget.firstDate != null)
      _firstDate = DateTime(widget.firstDate!.year, widget.firstDate!.month);
    if (widget.lastDate != null)
      _lastDate = DateTime(widget.lastDate!.year, widget.lastDate!.month);

    _upDownPageLimitPublishSubject = new PublishSubject();
    _upDownButtonEnableStatePublishSubject = new PublishSubject();

    _selector = new WeekSelector(
      key: _weekSelectorState,
      openDate: selectedDate!,
      selectedDate: selectedDate!,
      upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
      upDownButtonEnableStatePublishSubject:
          _upDownButtonEnableStatePublishSubject!,
      firstDate: _firstDate,
      lastDate: _lastDate,
      onWeekSelected: _onWeekSelected,
      locale: widget.locale,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _upDownPageLimitPublishSubject!.close();
    _upDownButtonEnableStatePublishSubject!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var locale = getLocale(context, selectedLocale: widget.locale);
    var header = buildHeader(theme, locale);
    var pager = buildPager(theme, locale);
    var content = Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [pager, buildButtonBar(context)],
      ),
      color: theme.dialogBackgroundColor,
    );

    return Theme(
      data:
          Theme.of(context).copyWith(dialogBackgroundColor: Colors.transparent),
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  return IntrinsicWidth(
                    child: Column(children: [header, content]),
                  );
                }
                return IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [header, content],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonBar(
    BuildContext context,
  ) {
    return ButtonBar(
      children: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(widget.localizations.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedDate),
          child: Text(widget.localizations.okButtonLabel),
        ),
      ],
    );
  }

  Widget buildHeader(ThemeData theme, String locale) {
    return Material(
      color: theme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${DateFormat.yMMM(locale).format(selectedDate!)}',
              style: theme.primaryTextTheme.subtitle1,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     _selector is MonthSelector
            //         ? GestureDetector(
            //       onTap: _onSelectYear,
            //       child: new StreamBuilder<UpDownPageLimit>(
            //         stream: _upDownPageLimitPublishSubject,
            //         initialData: const UpDownPageLimit(0, 0),
            //         builder: (_, snapshot) => Text(
            //           '${DateFormat.y(locale).format(DateTime(snapshot.data!.upLimit))}',
            //           style: theme.primaryTextTheme.headline5,
            //         ),
            //       ),
            //     )
            //         : new StreamBuilder<UpDownPageLimit>(
            //       stream: _upDownPageLimitPublishSubject,
            //       initialData: const UpDownPageLimit(0, 0),
            //       builder: (_, snapshot) => Row(
            //         mainAxisSize: MainAxisSize.min,
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: <Widget>[
            //           Text(
            //             '${DateFormat.y(locale).format(DateTime(snapshot.data!.upLimit))}',
            //             style: theme.primaryTextTheme.headline5,
            //           ),
            //           Text(
            //             '-',
            //             style: theme.primaryTextTheme.headline5,
            //           ),
            //           Text(
            //             '${DateFormat.y(locale).format(DateTime(snapshot.data!.downLimit))}',
            //             style: theme.primaryTextTheme.headline5,
            //           ),
            //         ],
            //       ),
            //     ),
            //     new StreamBuilder<UpDownButtonEnableState>(
            //       stream: _upDownButtonEnableStatePublishSubject,
            //       initialData: const UpDownButtonEnableState(true, true),
            //       builder: (_, snapshot) => Row(
            //         children: <Widget>[
            //           IconButton(
            //             icon: Icon(
            //               Icons.keyboard_arrow_up,
            //               color: snapshot.data!.upState
            //                   ? theme.primaryIconTheme.color
            //                   : theme.primaryIconTheme.color!.withOpacity(0.5),
            //             ),
            //             onPressed:
            //             snapshot.data!.upState ? _onUpButtonPressed : null,
            //           ),
            //           IconButton(
            //             icon: Icon(
            //               Icons.keyboard_arrow_down,
            //               color: snapshot.data!.downState
            //                   ? theme.primaryIconTheme.color
            //                   : theme.primaryIconTheme.color!.withOpacity(0.5),
            //             ),
            //             onPressed: snapshot.data!.downState
            //                 ? _onDownButtonPressed
            //                 : null,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildPager(ThemeData theme, String locale) {
    return SizedBox(
      height: 230.0,
      width: 300.0,
      child: Theme(
        data: theme.copyWith(
          buttonTheme: ButtonThemeData(
            padding: EdgeInsets.all(2.0),
            shape: CircleBorder(),
            minWidth: 4.0,
          ),
        ),
        child: new AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(child: child, scale: animation),
          child: _selector,
        ),
      ),
    );
  }

  void _onWeekSelected(final DateTime date) => setState(() {
        selectedDate = date;
        _selector = new WeekSelector(
          key: _weekSelectorState,
          openDate: selectedDate!,
          selectedDate: selectedDate!,
          upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
          upDownButtonEnableStatePublishSubject:
              _upDownButtonEnableStatePublishSubject!,
          firstDate: _firstDate,
          lastDate: _lastDate,
          onWeekSelected: _onWeekSelected,
          locale: widget.locale,
        );
      });

  void _onUpButtonPressed() {
    if (_weekSelectorState.currentState != null) {
      _weekSelectorState.currentState!.goUp();
    } else {
      _weekSelectorState.currentState!.goUp();
    }
  }
}
