import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/bottom_sheet_dialog.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/alert/presentation/myalerts.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/mycases.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist.dart';
import 'package:haelo_flutter/features/home_page/presentation/screens/drawers.dart';
import 'package:haelo_flutter/features/home_page/presentation/screens/home_pages.dart';
import 'package:haelo_flutter/features/task/presentation/screens/mytasks.dart';
import 'package:haelo_flutter/features/task/presentation/screens/mytasks_bottom_sheet.dart';
import 'package:haelo_flutter/widgets/go_prime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class BottomNavBar extends StatefulWidget {
  int bottom;
  var selectedWatchlistData;

  BottomNavBar({required this.bottom, this.selectedWatchlistData = const {}});

  @override
  State<BottomNavBar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomNavBar> {
  int _selectedScreenIndex = 0;
  late SharedPreferences pref;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late DateTime _lastQuitTime;
  bool isSearch = false;
  List _screens = [];
  List<BottomNavigationBarItem> items = [];

  @override
  void initState() {
    print("in bottomnav bar");
    pref = di.locator();
    _screens = [];
    _screens.add(HomePage());

    _screens.add(MyTasks());

    _screens.add(CauseList());

    _screens.add(MyCases(selectedData: widget.selectedWatchlistData));
    // }

    items = [];
    items.add(BottomNavigationBarItem(
        icon: SvgPicture.asset(
          ImageConstant.home,
          colorFilter: ColorFilter.mode(
              _selectedScreenIndex == 0
                  ? AppColor.primary
                  : AppColor.hint_color_grey,
              BlendMode.srcIn),
          height: 20,
          width: 20,
        ),
        label: 'Home'));

    items.add(BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"));

    items.add(
      BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded), label: "Causes List"),
    );

    items.add(
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.document_edit,
            colorFilter: ColorFilter.mode(
                _selectedScreenIndex == 3
                    ? AppColor.primary
                    : AppColor.hint_color_grey,
                BlendMode.srcIn),
            height: 24,
            width: 25,
          ),
          label: "Cases"),
    );

    setState(() {
      _selectedScreenIndex = widget.bottom ?? 0;
    });

    super.initState();
  }

  void _selectScreen(int index) {
    if (!isPrime(pref) && (index == 1 || index == 3)) {
      FocusScope.of(context).requestFocus(FocusNode());
      showDialog(
          context: context,
          builder: (ctx) => const SafeArea(
                child: GoPrime(),
              ));
    } else {
      if (planName(pref) == Constants.silverPlan && index == 1) {
        FocusScope.of(context).requestFocus(FocusNode());
        showDialog(
            context: context,
            builder: (ctx) => const SafeArea(
                  child: GoPrime(),
                ));
        return;
      }

      setState(() {
        widget.selectedWatchlistData = const {};
        print("bottomnav index changed");
        if (index == 3) {
          _screens.removeLast();
          _screens.add(MyCases(selectedData: widget.selectedWatchlistData));
        }
        _selectedScreenIndex = index;
        // widget.selectedWatchlistData = const {};
      });
    }
    // if (index == 1 ) {
    //   if (isPrime(pref) && planName(pref) == Constants.goldPlan) {
    //     setState(() {
    //       _selectedScreenIndex = index;
    //     });
    //   } else {
    //
    //   }
    // } else {
    //   setState(() {
    //     widget.selectedWatchlistData = const {};
    //     print("bottomnav index changed");
    //     if(index==3){
    //       _screens.removeLast();
    //       _screens.add (MyCases(selectedData: widget.selectedWatchlistData));
    //     }
    //     _selectedScreenIndex = index;
    //    // widget.selectedWatchlistData = const {};
    //   });
    //  }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("object1 $_selectedScreenIndex");
        if (_selectedScreenIndex == 0) {
          print("object11");
          return true;
          if (DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
            print('Press again Back Button exit');
            // Fluttertoast.showToast(msg: 'Press again Back Button exit');
            setState(() {
              _lastQuitTime = DateTime.now();
            });
            return false;
          } else {
            print("object");
            SystemNavigator.pop();
            return false;
          }
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavBar(bottom: 0)));
          return false;
        }
      },
      child: Scaffold(
        key: _key,
        appBar: _selectedScreenIndex == 0
            ? AppBar(
                elevation: 0,
                titleSpacing: 0,
                title: Text(
                  "HAeLO",
                  style: mpHeadLine18(
                      fontWeight: FontWeight.w500,
                      textColor: AppColor.bold_text_color_dark_blue),
                ),
                actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyAlerts()));
                        },
                        child: SvgPicture.asset(ImageConstant.bell),
                      ),
                    )
                  ])
            : null,
        drawer: AppDrawer(),
        resizeToAvoidBottomInset: true,
        body: _screens[_selectedScreenIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedScreenIndex,
          onTap: _selectScreen,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: AppColor.hint_color_grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  ImageConstant.home,
                  colorFilter: ColorFilter.mode(
                      _selectedScreenIndex == 0
                          ? AppColor.primary
                          : AppColor.hint_color_grey,
                      BlendMode.srcIn),
                  height: 20,
                  width: 20,
                ),
                label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded), label: "Causes List"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  ImageConstant.document_edit,
                  colorFilter: ColorFilter.mode(
                      _selectedScreenIndex == 3
                          ? AppColor.primary
                          : AppColor.hint_color_grey,
                      BlendMode.srcIn),
                  height: 24,
                  width: 25,
                ),
                label: "Cases"),
          ],
        ),
      ),
    );
  }
}
