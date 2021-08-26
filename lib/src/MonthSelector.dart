import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/src/common.dart';
import 'package:rxdart/rxdart.dart';

import 'locale_utils.dart';

class MonthSelector extends StatefulWidget {
  final ValueChanged<DateTime> onMonthSelected;
  final DateTime? openDate, selectedDate, firstDate, lastDate;
  final PublishSubject<UpDownPageLimit> upDownPageLimitPublishSubject;
  final PublishSubject<UpDownButtonEnableState>
      upDownButtonEnableStatePublishSubject;
  final Locale? locale;
  const MonthSelector({
    Key? key,
    required DateTime this.openDate,
    required DateTime this.selectedDate,
    required this.onMonthSelected,
    required this.upDownPageLimitPublishSubject,
    required this.upDownButtonEnableStatePublishSubject,
    this.firstDate,
    this.lastDate,
    this.locale,
  })  : assert(openDate != null),
        assert(selectedDate != null),
        assert(onMonthSelected != null),
        assert(upDownPageLimitPublishSubject != null),
        assert(upDownButtonEnableStatePublishSubject != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => MonthSelectorState();
}

class MonthSelectorState extends State<MonthSelector> {
  PageController? _pageController;

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        onPageChanged: _onPageChange,
        itemCount: _getPageCount(),
        itemBuilder: _yearGridBuilder,
      );

  Widget _yearGridBuilder(final BuildContext context, final int page) =>
      GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        crossAxisCount: 4,
        children: List<Widget>.generate(
          12,
          (final int index) => _getMonthButton(
              DateTime(
                  widget.firstDate != null
                      ? widget.firstDate!.year + page
                      : page,
                  index + 1),
              getLocale(context, selectedLocale: widget.locale)),
        ).toList(growable: false),
      );

  Widget _getMonthButton(final DateTime date, final String locale) {
    final bool isEnabled = _isEnabled(date);
    return FlatButton(
      onPressed: isEnabled
          ? () => widget.onMonthSelected(DateTime(date.year, date.month))
          : null,
      color: date.month == widget.selectedDate!.month &&
              date.year == widget.selectedDate!.year
          ? Theme.of(context).accentColor
          : null,
      textColor: date.month == widget.selectedDate!.month &&
              date.year == widget.selectedDate!.year
          ? Theme.of(context).accentTextTheme.button!.color
          : date.month == DateTime.now().month &&
                  date.year == DateTime.now().year
              ? Theme.of(context).accentColor
              : null,
      child: Text(
        DateFormat.MMM(locale).format(date),
      ),
    );
  }

  void _onPageChange(final int page) {
    widget.upDownPageLimitPublishSubject.add(
      new UpDownPageLimit(
        widget.firstDate != null ? widget.firstDate!.year + page : page,
        0,
      ),
    );
    widget.upDownButtonEnableStatePublishSubject.add(
      new UpDownButtonEnableState(page > 0, page < _getPageCount() - 1),
    );
  }

  int _getPageCount() {
    if (widget.firstDate != null && widget.lastDate != null) {
      return widget.lastDate!.year - widget.firstDate!.year + 1;
    } else if (widget.firstDate != null && widget.lastDate == null) {
      return 9999 - widget.firstDate!.year;
    } else if (widget.firstDate == null && widget.lastDate != null) {
      return widget.lastDate!.year + 1;
    } else
      return 9999;
  }

  @override
  void initState() {
    _pageController = new PageController(
        initialPage: widget.firstDate == null
            ? widget.openDate!.year
            : widget.openDate!.year - widget.firstDate!.year);
    super.initState();
    new Future.delayed(Duration.zero, () {
      widget.upDownPageLimitPublishSubject.add(
        new UpDownPageLimit(
          widget.firstDate == null
              ? _pageController!.page!.toInt()
              : widget.firstDate!.year + _pageController!.page!.toInt(),
          0,
        ),
      );
      widget.upDownButtonEnableStatePublishSubject.add(
        new UpDownButtonEnableState(
          _pageController!.page!.toInt() > 0,
          _pageController!.page!.toInt() < _getPageCount() - 1,
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  bool _isEnabled(final DateTime date) {
    if (widget.firstDate == null && widget.lastDate == null)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate != null &&
        widget.firstDate!.compareTo(date) <= 0 &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate == null &&
        widget.firstDate!.compareTo(date) <= 0)
      return true;
    else if (widget.firstDate == null &&
        widget.lastDate != null &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else
      return false;
  }

  void goDown() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goUp() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

// yearSelector
class YearSelector1 extends StatefulWidget {
  final ValueChanged<DateTime> onYearSelected;
  final DateTime? openDate, selectedDate, firstDate, lastDate;
  final PublishSubject<UpDownPageLimit> upDownPageLimitPublishSubject;
  final PublishSubject<UpDownButtonEnableState>
      upDownButtonEnableStatePublishSubject;
  final Locale? locale;
  const YearSelector1({
    Key? key,
    required DateTime this.openDate,
    required DateTime this.selectedDate,
    required this.onYearSelected,
    required this.upDownPageLimitPublishSubject,
    required this.upDownButtonEnableStatePublishSubject,
    this.firstDate,
    this.lastDate,
    this.locale,
  })  : assert(openDate != null),
        assert(selectedDate != null),
        assert(onYearSelected != null),
        assert(upDownPageLimitPublishSubject != null),
        assert(upDownButtonEnableStatePublishSubject != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => YearSelector1State();
}

// yearSelectorState
class YearSelector1State extends State<YearSelector1> {
  PageController? _pageController;

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChange,
        itemCount: _getPageCount(),
        itemBuilder: _yearGridBuilder,
      );

  Widget _yearGridBuilder(final BuildContext context, final int page) =>
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _getYearButton(
            DateTime(
              widget.selectedDate != null
                  ? widget.selectedDate!.year == 2021
                    ? widget.selectedDate!.year - index
                    : DateTime.now().year - index
                  : 0,
              index + 1),
            getLocale(context, selectedLocale: widget.locale));
        }
      );
      // GridView.count(
      //   physics: const NeverScrollableScrollPhysics(),
      //   padding: EdgeInsets.all(8.0),
      //   crossAxisCount: 4,
      //   children: List<Widget>.generate(
      //     12,
      //     (final int index) => _getYearButton(
      //         DateTime(
      //             widget.firstDate != null
      //                 ? widget.firstDate!.year + page
      //                 : page,
      //             index + 1),
      //         getLocale(context, selectedLocale: widget.locale)),
      //   ).toList(growable: false),
      // );

  Widget _getYearButton(final DateTime date, final String locale) {
    final bool isEnabled = _isEnabled(date);
    return ElevatedButton(
      onPressed: isEnabled
          ? () => widget.onYearSelected(DateTime(date.year))
          : null,
      style: ElevatedButton.styleFrom(
        primary: date.year == widget.selectedDate!.year
            ? Colors.blueAccent
            : Colors.white,
      ),
      child: Text(
        DateFormat.y(locale).format(date),
        style: TextStyle(
          color: date.year == widget.selectedDate!.year ? Colors.white : Color(0xff707070)
        ),
      ),
    );
  }

  void _onPageChange(final int page) {
    widget.upDownPageLimitPublishSubject.add(
      new UpDownPageLimit(
        widget.firstDate != null ? widget.firstDate!.year + page : page,
        0,
      ),
    );
    widget.upDownButtonEnableStatePublishSubject.add(
      new UpDownButtonEnableState(page > 0, page < _getPageCount() - 1),
    );
  }

  int _getPageCount() {
    if (widget.firstDate != null && widget.lastDate != null) {
      return widget.lastDate!.year - widget.firstDate!.year + 1;
    } else if (widget.firstDate != null && widget.lastDate == null) {
      return 9999 - widget.firstDate!.year;
    } else if (widget.firstDate == null && widget.lastDate != null) {
      return widget.lastDate!.year + 1;
    } else
      return 9999;
  }

  @override
  void initState() {
    _pageController = new PageController(
        initialPage: widget.firstDate == null
            ? widget.openDate!.year
            : widget.openDate!.year - widget.firstDate!.year);
    super.initState();
    new Future.delayed(Duration.zero, () {
      widget.upDownPageLimitPublishSubject.add(
        new UpDownPageLimit(
          widget.firstDate == null
              ? _pageController!.page!.toInt()
              : widget.firstDate!.year + _pageController!.page!.toInt(),
          0,
        ),
      );
      widget.upDownButtonEnableStatePublishSubject.add(
        new UpDownButtonEnableState(
          _pageController!.page!.toInt() > 0,
          _pageController!.page!.toInt() < _getPageCount() - 1,
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  bool _isEnabled(final DateTime date) {
    if (widget.firstDate == null && widget.lastDate == null)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate != null &&
        widget.firstDate!.compareTo(date) <= 0 &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate == null &&
        widget.firstDate!.compareTo(date) <= 0)
      return true;
    else if (widget.firstDate == null &&
        widget.lastDate != null &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else
      return false;
  }

  void goDown() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goUp() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

// HalfSelector
class HalfSelector extends StatefulWidget {
  final ValueChanged<DateTime> onHalfSelected;
  final DateTime? openDate, selectedDate, firstDate, lastDate;
  final PublishSubject<UpDownPageLimit> upDownPageLimitPublishSubject;
  final PublishSubject<UpDownButtonEnableState>
  upDownButtonEnableStatePublishSubject;
  final Locale? locale;
  const HalfSelector({
    Key? key,
    required DateTime this.openDate,
    required DateTime this.selectedDate,
    required this.onHalfSelected,
    required this.upDownPageLimitPublishSubject,
    required this.upDownButtonEnableStatePublishSubject,
    this.firstDate,
    this.lastDate,
    this.locale,
  })  : assert(openDate != null),
        assert(selectedDate != null),
        assert(onHalfSelected != null),
        assert(upDownPageLimitPublishSubject != null),
        assert(upDownButtonEnableStatePublishSubject != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => HalfSelectorState();
}

// halfSelectorState
class HalfSelectorState extends State<HalfSelector> {
  PageController? _pageController;
  String type = 'H';

  @override
  Widget build(BuildContext context) => _halfGridBuilder(context);

  Widget _halfListBuilder(final BuildContext context) {
    var today =DateTime.now();
    List<dynamic> temp = makePeriod(today, type);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(8.0),
      itemCount: temp.length,
      itemBuilder: (context, index) {
        var period = DateTime.parse(temp[index][0]);

        return _getHalfBtn(
          period, getLocale(context, selectedLocale: widget.locale));
      },
    );
  }

  Widget _halfGridBuilder(final BuildContext context) {
    var today =DateTime.now();
    List<dynamic> temp = makePeriod(today, type);

    return GridView.count(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(8.0),
      crossAxisCount: 2,
      childAspectRatio: 3,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      children: List<Widget>.generate(
        temp.length,
        (final int index) {
          var period = DateTime.parse(temp[index][0]);

          return _getHalfBtn(period, getLocale(context, selectedLocale: widget.locale));
        }),
    );
  }

  // for HalfBtn
  Widget _getHalfBtn(final DateTime date, final String locale) {
    final bool isEnabled = _isEnabled(date);
    List<dynamic> temp = makePeriod(date, type);
    String title = searchWhen(date, type);


    return ElevatedButton(
      onPressed: isEnabled
          ? () => widget.onHalfSelected(DateTime(date.year, date.month))
          : null,
      style: ElevatedButton.styleFrom(
        primary: date.month == widget.selectedDate!.month &&
            date.year == widget.selectedDate!.year
            ? Colors.blue
            : Colors.white,
        // textStyle: TextStyle(
        //   color: date.month == widget.selectedDate!.month &&
        //       date.year == widget.selectedDate!.year
        //       ? Theme.of(context).accentTextTheme.button!.color
        //       : date.month == DateTime.now().month &&
        //       date.year == DateTime.now().year
        //       ? Theme.of(context).accentColor
        //       : null,
        // ),
      ),
        child: Text(
          title,
          style: TextStyle(
            color: date.month == widget.selectedDate!.month && date.year == widget.selectedDate!.year
                ? Colors.white
                : Color(0xff707070)
          ),
        ),
    );
  }

  void _onPageChange(final int page) {
    widget.upDownPageLimitPublishSubject.add(
      new UpDownPageLimit(
        widget.firstDate != null ? widget.firstDate!.year + page : page,
        0,
      ),
    );
    widget.upDownButtonEnableStatePublishSubject.add(
      new UpDownButtonEnableState(page > 0, page < _getPageCount() - 1),
    );
  }

  int _getPageCount() {
    if (widget.firstDate != null && widget.lastDate != null) {
      return widget.lastDate!.year - widget.firstDate!.year + 1;
    } else if (widget.firstDate != null && widget.lastDate == null) {
      return 9999 - widget.firstDate!.year;
    } else if (widget.firstDate == null && widget.lastDate != null) {
      return widget.lastDate!.year + 1;
    } else
      return 9999;
  }

  @override
  void initState() {
    _pageController = new PageController(
        initialPage: widget.firstDate == null
            ? widget.openDate!.year
            : widget.openDate!.year - widget.firstDate!.year);
    super.initState();
    new Future.delayed(Duration.zero, () {
      widget.upDownPageLimitPublishSubject.add(
        new UpDownPageLimit(
          widget.firstDate == null
              ? _pageController!.page!.toInt()
              : widget.firstDate!.year + _pageController!.page!.toInt(),
          0,
        ),
      );
      widget.upDownButtonEnableStatePublishSubject.add(
        new UpDownButtonEnableState(
          _pageController!.page!.toInt() > 0,
          _pageController!.page!.toInt() < _getPageCount() - 1,
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  bool _isEnabled(final DateTime date) {
    if (widget.firstDate == null && widget.lastDate == null)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate != null &&
        widget.firstDate!.compareTo(date) <= 0 &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate == null &&
        widget.firstDate!.compareTo(date) <= 0)
      return true;
    else if (widget.firstDate == null &&
        widget.lastDate != null &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else
      return false;
  }

  void goDown() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goUp() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // make List For Half
  makePeriod(DateTime date, String type) {
    // Init
    String temp = date.year.toString();
    //String oneYearAgo = DateTime(date.year - 1).toString();
    String aYearAgo = DateTime(date.year - 1).year.toString();
    String twoYearsAgo = DateTime(date.year - 2).year.toString();
    int typeNumb = 0;
    int genList = 0;
    int upperList = 0;
    String firstDate1 = temp + '0101';
    List<dynamic> resultList = [];

    switch (type) {
      case 'Q':
        typeNumb = 3;
        genList = 3;
        upperList = 12;

        List<dynamic> tempList = List.generate(
            upperList, (index) => List.generate(genList, (index) => null));

        // the current year
        var first1 = DateTime.parse(firstDate1);
        var first2 = DateTime(first1.year, first1.month + typeNumb, 1);
        var first3 = DateTime(first1.year, first2.month + typeNumb, 1);
        var first4 = DateTime(first1.year, first3.month + typeNumb, 1);

        var last1 = first2.subtract(Duration(days: 1));
        var last2 = first3.subtract(Duration(days: 1));
        var last3 = first4.subtract(Duration(days: 1));
        var last4 = DateTime(first1.year, first4.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // A Year ago
        var aYearAgoF1 = DateTime(first1.year - 1, first1.month, first1.day);
        var aYearAgoF2 =
        DateTime(aYearAgoF1.year, aYearAgoF1.month + typeNumb, 1);
        var aYearAgoF3 =
        DateTime(aYearAgoF1.year, aYearAgoF2.month + typeNumb, 1);
        var aYearAgoF4 =
        DateTime(aYearAgoF1.year, aYearAgoF3.month + typeNumb, 1);

        var aYearAgoL1 = aYearAgoF2.subtract(Duration(days: 1));
        var aYearAgoL2 = aYearAgoF3.subtract(Duration(days: 1));
        var aYearAgoL3 = aYearAgoF4.subtract(Duration(days: 1));
        var aYearAgoL4 = DateTime(aYearAgoF2.year, aYearAgoF4.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // Two Years ago
        var twoyAgoF1 = DateTime(first1.year - 2, first1.month, first1.day);
        var twoyAgoF2 = DateTime(twoyAgoF1.year, twoyAgoF1.month + typeNumb, 1);
        var twoyAgoF3 = DateTime(twoyAgoF1.year, twoyAgoF2.month + typeNumb, 1);
        var twoyAgoF4 = DateTime(twoyAgoF1.year, twoyAgoF3.month + typeNumb, 1);
        var twoyAgoL1 = twoyAgoF2.subtract(Duration(days: 1));
        var twoyAgoL2 = twoyAgoF3.subtract(Duration(days: 1));
        var twoyAgoL3 = twoyAgoF4.subtract(Duration(days: 1));
        var twoyAgoL4 = DateTime(twoyAgoF2.year, twoyAgoF4.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        tempList[0] = [first1.toString(), last1.toString(), '$temp 1분기'];
        tempList[1] = [first2.toString(), last2.toString(), '$temp 2분기'];
        tempList[2] = [first3.toString(), last3.toString(), '$temp 3분기'];
        tempList[3] = [first4.toString(), last4.toString(), '$temp 4분기'];

        tempList[4] = [
          aYearAgoF1.toString(),
          aYearAgoL1.toString(),
          '$aYearAgo 1분기'
        ];
        tempList[5] = [
          aYearAgoF2.toString(),
          aYearAgoL2.toString(),
          '$aYearAgo 2분기'
        ];
        tempList[6] = [
          aYearAgoF3.toString(),
          aYearAgoL3.toString(),
          '$aYearAgo 3분기'
        ];
        tempList[7] = [
          aYearAgoF4.toString(),
          aYearAgoL4.toString(),
          '$aYearAgo 4분기'
        ];
        tempList[8] = [
          twoyAgoF1.toString(),
          twoyAgoL1.toString(),
          '$twoYearsAgo 1분기'
        ];
        tempList[9] = [
          twoyAgoF2.toString(),
          twoyAgoL2.toString(),
          '$twoYearsAgo 2분기'
        ];
        tempList[10] = [
          twoyAgoF3.toString(),
          twoyAgoL3.toString(),
          '$twoYearsAgo 3분기'
        ];
        tempList[11] = [
          twoyAgoF4.toString(),
          twoyAgoL4.toString(),
          '$twoYearsAgo 4분기'
        ];

        resultList = tempList;
        break;
      case 'H':
        typeNumb = 6;
        genList = 3;
        upperList = 6;

        List<dynamic> tempList = List.generate(
            upperList, (index) => List.generate(genList, (index) => null));

        // the current year
        var first1 = DateTime.parse(firstDate1);
        var first2 = DateTime(first1.year, first1.month + typeNumb, 1);
        var last1 = first2.subtract(Duration(days: 1));
        var last2 = DateTime(first2.year, first2.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // A Year ago
        var aYearAgoF1 = DateTime(first1.year - 1, first1.month, first1.day);
        var aYearAgoF2 =
        DateTime(aYearAgoF1.year, aYearAgoF1.month + typeNumb, 1);
        var aYearAgoL1 = aYearAgoF2.subtract(Duration(days: 1));
        var aYearAgoL2 = DateTime(aYearAgoF2.year, aYearAgoF2.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // Two Years ago
        var twoyAgoF1 = DateTime(first1.year - 2, first1.month, first1.day);
        var twoyAgoF2 = DateTime(twoyAgoF1.year, twoyAgoF1.month + typeNumb, 1);
        var twoyAgoL1 = twoyAgoF2.subtract(Duration(days: 1));
        var twoyAgoL2 = DateTime(twoyAgoF2.year, twoyAgoF2.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        tempList[0] = [first1.toString(), last1.toString(), '$temp 상반기'];
        tempList[1] = [first2.toString(), last2.toString(), '$temp 하반기'];
        tempList[2] = [
          aYearAgoF1.toString(),
          aYearAgoL1.toString(),
          '$aYearAgo 상반기'
        ];
        tempList[3] = [
          aYearAgoF2.toString(),
          aYearAgoL2.toString(),
          '$aYearAgo 하반기'
        ];
        tempList[4] = [
          twoyAgoF1.toString(),
          twoyAgoL1.toString(),
          '$twoYearsAgo 상반기'
        ];
        tempList[5] = [
          twoyAgoF2.toString(),
          twoyAgoL2.toString(),
          '$twoYearsAgo 하반기'
        ];

        resultList = tempList;
        break;
    }

    return resultList;
  }

  // 언제인지 찾기
  searchWhen(DateTime date, String type) {
    var target = date;
    List<dynamic> period = makePeriod(date, type);
    var result;
    String title = '';

    for (int i = 0; i < period.length; i++) {
      var first = DateTime.parse(period[i][0]); // first
      var last = DateTime.parse(period[i][1]); // last

      if ((target.isAtSameMomentAs(first) || target.isAfter(first)) &&
          (target.isAtSameMomentAs(last) || target.isBefore(last))) {
        result = target;
        title = period[i][2];
      } else {
        result = first;
      }
    }

    return title;
  }
}

// quarterSelector
class QuarterSelector extends StatefulWidget {
  final ValueChanged<DateTime> onQtrSelected;
  final DateTime? openDate, selectedDate, firstDate, lastDate;
  final PublishSubject<UpDownPageLimit> upDownPageLimitPublishSubject;
  final PublishSubject<UpDownButtonEnableState>
  upDownButtonEnableStatePublishSubject;
  final Locale? locale;
  const QuarterSelector({
    Key? key,
    required DateTime this.openDate,
    required DateTime this.selectedDate,
    required this.onQtrSelected,
    required this.upDownPageLimitPublishSubject,
    required this.upDownButtonEnableStatePublishSubject,
    this.firstDate,
    this.lastDate,
    this.locale,
  })  : assert(openDate != null),
        assert(selectedDate != null),
        assert(onQtrSelected != null),
        assert(upDownPageLimitPublishSubject != null),
        assert(upDownButtonEnableStatePublishSubject != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => QuarterSelectorState();
}

// quarterSelectorState
class QuarterSelectorState extends State<QuarterSelector> {
  PageController? _pageController;
  String type = 'Q';

  @override
  Widget build(BuildContext context) => _halfGridBuilder(context);

  Widget _halfGridBuilder(final BuildContext context) {
    var today = DateTime.now();
    List<dynamic> temp = makePeriod(today, type);

    return GridView.count(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(8.0),
      crossAxisCount: 4,
      childAspectRatio: 1.5,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      children: List<Widget>.generate(
          temp.length,
              (final int index) {
            var period = DateTime.parse(temp[index][0]);

            return _getHalfBtn(period, getLocale(context, selectedLocale: widget.locale));
          }),
    );
  }

  // for HalfBtn
  Widget _getHalfBtn(final DateTime date, final String locale) {
    final bool isEnabled = _isEnabled(date);
    List<dynamic> temp = makePeriod(date, type);
    String title = searchWhen(date, type);


    return ElevatedButton(
      onPressed: isEnabled
          ? () => widget.onQtrSelected(DateTime(date.year, date.month))
          : null,
      style: ElevatedButton.styleFrom(
        primary: date.month == widget.selectedDate!.month &&
            date.year == widget.selectedDate!.year
            ? Colors.blueAccent
            : Colors.white,
        // textStyle: TextStyle(
        //   color: date.month == widget.selectedDate!.month &&
        //       date.year == widget.selectedDate!.year
        //       ? Theme.of(context).accentTextTheme.button!.color
        //       : date.month == DateTime.now().month &&
        //       date.year == DateTime.now().year
        //       ? Theme.of(context).accentColor
        //       : null,
        // ),
      ),
      child: Text(
        title,
        style: TextStyle(
            color: date.month == widget.selectedDate!.month && date.year == widget.selectedDate!.year
              ? Colors.white
              : Color(0xff707070)
        ),
      ),
    );
  }

  void _onPageChange(final int page) {
    widget.upDownPageLimitPublishSubject.add(
      new UpDownPageLimit(
        widget.firstDate != null ? widget.firstDate!.year + page : page,
        0,
      ),
    );
    widget.upDownButtonEnableStatePublishSubject.add(
      new UpDownButtonEnableState(page > 0, page < _getPageCount() - 1),
    );
  }

  int _getPageCount() {
    if (widget.firstDate != null && widget.lastDate != null) {
      return widget.lastDate!.year - widget.firstDate!.year + 1;
    } else if (widget.firstDate != null && widget.lastDate == null) {
      return 9999 - widget.firstDate!.year;
    } else if (widget.firstDate == null && widget.lastDate != null) {
      return widget.lastDate!.year + 1;
    } else
      return 9999;
  }

  @override
  void initState() {
    _pageController = new PageController(
        initialPage: widget.firstDate == null
            ? widget.openDate!.year
            : widget.openDate!.year - widget.firstDate!.year);
    super.initState();
    new Future.delayed(Duration.zero, () {
      widget.upDownPageLimitPublishSubject.add(
        new UpDownPageLimit(
          widget.firstDate == null
              ? _pageController!.page!.toInt()
              : widget.firstDate!.year + _pageController!.page!.toInt(),
          0,
        ),
      );
      widget.upDownButtonEnableStatePublishSubject.add(
        new UpDownButtonEnableState(
          _pageController!.page!.toInt() > 0,
          _pageController!.page!.toInt() < _getPageCount() - 1,
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  bool _isEnabled(final DateTime date) {
    if (widget.firstDate == null && widget.lastDate == null)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate != null &&
        widget.firstDate!.compareTo(date) <= 0 &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else if (widget.firstDate != null &&
        widget.lastDate == null &&
        widget.firstDate!.compareTo(date) <= 0)
      return true;
    else if (widget.firstDate == null &&
        widget.lastDate != null &&
        widget.lastDate!.compareTo(date) >= 0)
      return true;
    else
      return false;
  }

  void goDown() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goUp() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // make List For Half
  makePeriod(DateTime date, String type) {
    // Init
    String temp = date.year.toString();
    //String oneYearAgo = DateTime(date.year - 1).toString();
    String aYearAgo = DateTime(date.year - 1).year.toString();
    String twoYearsAgo = DateTime(date.year - 2).year.toString();
    int typeNumb = 0;
    int genList = 0;
    int upperList = 0;
    String firstDate1 = temp + '0101';
    List<dynamic> resultList = [];

    switch (type) {
      case 'Q':
        typeNumb = 3;
        genList = 3;
        upperList = 12;

        List<dynamic> tempList = List.generate(
            upperList, (index) => List.generate(genList, (index) => null));

        // the current year
        var first1 = DateTime.parse(firstDate1);
        var first2 = DateTime(first1.year, first1.month + typeNumb, 1);
        var first3 = DateTime(first1.year, first2.month + typeNumb, 1);
        var first4 = DateTime(first1.year, first3.month + typeNumb, 1);

        var last1 = first2.subtract(Duration(days: 1));
        var last2 = first3.subtract(Duration(days: 1));
        var last3 = first4.subtract(Duration(days: 1));
        var last4 = DateTime(first1.year, first4.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // A Year ago
        var aYearAgoF1 = DateTime(first1.year - 1, first1.month, first1.day);
        var aYearAgoF2 =
        DateTime(aYearAgoF1.year, aYearAgoF1.month + typeNumb, 1);
        var aYearAgoF3 =
        DateTime(aYearAgoF1.year, aYearAgoF2.month + typeNumb, 1);
        var aYearAgoF4 =
        DateTime(aYearAgoF1.year, aYearAgoF3.month + typeNumb, 1);

        var aYearAgoL1 = aYearAgoF2.subtract(Duration(days: 1));
        var aYearAgoL2 = aYearAgoF3.subtract(Duration(days: 1));
        var aYearAgoL3 = aYearAgoF4.subtract(Duration(days: 1));
        var aYearAgoL4 = DateTime(aYearAgoF2.year, aYearAgoF4.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // Two Years ago
        var twoyAgoF1 = DateTime(first1.year - 2, first1.month, first1.day);
        var twoyAgoF2 = DateTime(twoyAgoF1.year, twoyAgoF1.month + typeNumb, 1);
        var twoyAgoF3 = DateTime(twoyAgoF1.year, twoyAgoF2.month + typeNumb, 1);
        var twoyAgoF4 = DateTime(twoyAgoF1.year, twoyAgoF3.month + typeNumb, 1);
        var twoyAgoL1 = twoyAgoF2.subtract(Duration(days: 1));
        var twoyAgoL2 = twoyAgoF3.subtract(Duration(days: 1));
        var twoyAgoL3 = twoyAgoF4.subtract(Duration(days: 1));
        var twoyAgoL4 = DateTime(twoyAgoF2.year, twoyAgoF4.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        tempList[0] = [first1.toString(), last1.toString(), '$temp 1분기'];
        tempList[1] = [first2.toString(), last2.toString(), '$temp 2분기'];
        tempList[2] = [first3.toString(), last3.toString(), '$temp 3분기'];
        tempList[3] = [first4.toString(), last4.toString(), '$temp 4분기'];

        tempList[4] = [
          aYearAgoF1.toString(),
          aYearAgoL1.toString(),
          '$aYearAgo 1분기'
        ];
        tempList[5] = [
          aYearAgoF2.toString(),
          aYearAgoL2.toString(),
          '$aYearAgo 2분기'
        ];
        tempList[6] = [
          aYearAgoF3.toString(),
          aYearAgoL3.toString(),
          '$aYearAgo 3분기'
        ];
        tempList[7] = [
          aYearAgoF4.toString(),
          aYearAgoL4.toString(),
          '$aYearAgo 4분기'
        ];
        tempList[8] = [
          twoyAgoF1.toString(),
          twoyAgoL1.toString(),
          '$twoYearsAgo 1분기'
        ];
        tempList[9] = [
          twoyAgoF2.toString(),
          twoyAgoL2.toString(),
          '$twoYearsAgo 2분기'
        ];
        tempList[10] = [
          twoyAgoF3.toString(),
          twoyAgoL3.toString(),
          '$twoYearsAgo 3분기'
        ];
        tempList[11] = [
          twoyAgoF4.toString(),
          twoyAgoL4.toString(),
          '$twoYearsAgo 4분기'
        ];

        resultList = tempList;
        break;
      case 'H':
        typeNumb = 6;
        genList = 3;
        upperList = 6;

        List<dynamic> tempList = List.generate(
            upperList, (index) => List.generate(genList, (index) => null));

        // the current year
        var first1 = DateTime.parse(firstDate1);
        var first2 = DateTime(first1.year, first1.month + typeNumb, 1);
        var last1 = first2.subtract(Duration(days: 1));
        var last2 = DateTime(first2.year, first2.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // A Year ago
        var aYearAgoF1 = DateTime(first1.year - 1, first1.month, first1.day);
        var aYearAgoF2 =
        DateTime(aYearAgoF1.year, aYearAgoF1.month + typeNumb, 1);
        var aYearAgoL1 = aYearAgoF2.subtract(Duration(days: 1));
        var aYearAgoL2 = DateTime(aYearAgoF2.year, aYearAgoF2.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        // Two Years ago
        var twoyAgoF1 = DateTime(first1.year - 2, first1.month, first1.day);
        var twoyAgoF2 = DateTime(twoyAgoF1.year, twoyAgoF1.month + typeNumb, 1);
        var twoyAgoL1 = twoyAgoF2.subtract(Duration(days: 1));
        var twoyAgoL2 = DateTime(twoyAgoF2.year, twoyAgoF2.month + typeNumb, 1)
            .subtract(Duration(days: 1));

        tempList[0] = [first1.toString(), last1.toString(), '$temp 상반기'];
        tempList[1] = [first2.toString(), last2.toString(), '$temp 하반기'];
        tempList[2] = [
          aYearAgoF1.toString(),
          aYearAgoL1.toString(),
          '$aYearAgo 상반기'
        ];
        tempList[3] = [
          aYearAgoF2.toString(),
          aYearAgoL2.toString(),
          '$aYearAgo 하반기'
        ];
        tempList[4] = [
          twoyAgoF1.toString(),
          twoyAgoL1.toString(),
          '$twoYearsAgo 상반기'
        ];
        tempList[5] = [
          twoyAgoF2.toString(),
          twoyAgoL2.toString(),
          '$twoYearsAgo 하반기'
        ];

        resultList = tempList;
        break;
    }

    return resultList;
  }

  // 언제인지 찾기
  searchWhen(DateTime date, String type) {
    var target = date;
    List<dynamic> period = makePeriod(date, type);
    var result;
    String title = '';

    for (int i = 0; i < period.length; i++) {
      var first = DateTime.parse(period[i][0]); // first
      var last = DateTime.parse(period[i][1]); // last

      if ((target.isAtSameMomentAs(first) || target.isAfter(first)) &&
          (target.isAtSameMomentAs(last) || target.isBefore(last))) {
        result = target;
        title = period[i][2];
      } else {
        result = first;
      }
    }

    return title;
  }
}