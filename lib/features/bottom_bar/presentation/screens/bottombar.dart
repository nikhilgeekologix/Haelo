// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:haelo_flutter/constants.dart';
// import 'package:haelo_flutter/core/utils/ui_helper.dart';
// import 'package:haelo_flutter/core/utils/bottom_sheet_dialog.dart';
// import 'package:haelo_flutter/features/cases/presentation/screens/mycases.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist.dart';
// import 'package:haelo_flutter/features/alert/presentation/myalerts.dart';
// import 'package:haelo_flutter/features/task/presentation/screens/mytasks.dart';
// import 'package:haelo_flutter/features/task/presentation/screens/mytasks_bottom_sheet.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:haelo_flutter/locators.dart' as di;
// import '../../../../widgets/search_for_appbar.dart';
// import '../../../home_page/presentation/screens/drawers.dart';
// import '../../../home_page/presentation/screens/home_pages.dart';
//
// class BottomBar extends StatefulWidget {
//   int bottom;
//   var selectedWatchlistData;
//   BottomBar({required this.bottom, this.selectedWatchlistData= const {}});
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<BottomBar> {
// // index given for tabs
//   int currentIndex = 0;
//   int _selectedItemIndex = 0;
//
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//
//   List pages =[];
//
//   setBottomBarIndex(index) {
//     setState(() {
//       _selectedItemIndex = index;
//       widget.selectedWatchlistData={};
//     });
//   }
//   late SharedPreferences pref;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("widget.selectedWatchlistData ${widget.selectedWatchlistData}");
//     pages= [
//       HomePage(),
//       MyTasks(),
//       CauseList(),
//       MyCases(selectedData: widget.selectedWatchlistData),
//        // MyCasesScrollbar(selectedCase: widget.selectedWatchlistData),
//     ];
//     setState(() {
//       _selectedItemIndex = widget.bottom == null ? 0 : widget.bottom;
//     });
//     pref = di.locator();
//   }
//
//   late DateTime _lastQuitTime;
//   bool isSearch = false;
//
//   Icon customIcon = const Icon(Icons.search);
//   Widget customSearchBar = const Text('Search...');
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_selectedItemIndex == 0) {
//           if (_lastQuitTime == null || DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
//             print('Press again Back Button exit');
//
//             // Fluttertoast.showToast(msg: 'Press again Back Button exit');
//
//             _lastQuitTime = DateTime.now();
//
//             return false;
//           } else {
//             print('sign out');
//             SystemNavigator.pop();
//
//             //Navigator.of(context).pop(true);
//             return true;
//           }
//         }
//         else {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(bottom: 0)));
//           return false;
//         }
//       },
//       child: Scaffold(
//         key: _key,
//         appBar: _selectedItemIndex ==3 || _selectedItemIndex == 1 ?null:AppBar(
//           elevation: 0,
//           titleSpacing: 0,
//           title: Text(
//             _selectedItemIndex == 0
//                 ? "HAeLO"
//                 : _selectedItemIndex == 1
//                     ? isSearch
//                         ? ""
//                         : "My Tasks"
//                     : _selectedItemIndex == 2
//                         ? "Cause List"
//                         : "My Cases",
//             style: mpHeadLine18(fontWeight: FontWeight.w500, textColor: AppColor.bold_text_color_dark_blue),
//           ),
//           actions: _selectedItemIndex == 0
//               ? [
//                   Container(
//                     margin: const EdgeInsets.only(right: 15),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => MyAlerts()));
//                       },
//                       child: SvgPicture.asset(ImageConstant.bell),
//                     ),
//                   )
//                 ]
//               : _selectedItemIndex == 1 && isSearch
//                   ? [
//                       // Container(
//                       //   width: mediaQW(context) * 0.8,
//                       //   height: 40,
//                       //   decoration: BoxDecoration(color: Colors.white,
//                       //       borderRadius: BorderRadius.circular(5)),
//                       //   child: Center(
//                       //     child: TextField(
//                       //       decoration: InputDecoration(
//                       //           prefixIcon: const Icon(
//                       //             Icons.search,
//                       //             color: Colors.black,
//                       //           ),
//                       //           suffixIcon: IconButton(
//                       //             icon: const Icon(
//                       //               Icons.clear,
//                       //               color: Colors.black,
//                       //             ),
//                       //             onPressed: () {
//                       //               setState(() {
//                       //                 isSearch = false;
//                       //               });
//                       //               /* Clear the search field */
//                       //             },
//                       //           ),
//                       //           hintText: 'Search...',
//                       //           border: InputBorder.none),
//                       //     ),
//                       //   ),
//                       // ),
//                       // Padding(
//                       //   padding: const EdgeInsets.only(right: 15),
//                       //   child: InkWell(
//                       //     onTap: () {
//                       //       BottomSheetDialog(context, TaskBottomSheet()).showScreen();
//                       //     },
//                       //     child: const Icon(
//                       //       Icons.filter_alt_outlined,
//                       //       size: 28,
//                       //       color: AppColor.bold_text_color_dark_blue,
//                       //     ),
//                       //   ),
//                       // ),
//                     ]
//                   : _selectedItemIndex == 1
//                       ? [
//                           // Padding(
//                           //     padding: const EdgeInsets.only(right: 10),
//                           //     child:
//                           //         // TextField(
//                           //         //   cursorColor: Colors.white,
//                           //         //   decoration: InputDecoration(
//                           //         //       hintText: " Search...",
//                           //         //       border: InputBorder.none,
//                           //         //       suffixIcon: IconButton(
//                           //         //         icon: Icon(Icons.search),
//                           //         //         color: Colors.black,
//                           //         //         onPressed: () {},
//                           //         //       )),
//                           //         //   style: TextStyle(color: Colors.white, fontSize: 15.0),
//                           //         // ),
//                           //
//                           //         IconButton(
//                           //             onPressed: () => setState(() {
//                           //                   isSearch = true;
//                           //                 }),
//                           //             // TextField(
//                           //             //   decoration: InputDecoration(
//                           //             //       prefixIcon: const Icon(Icons.search),
//                           //             //       suffixIcon: IconButton(
//                           //             //         icon: const Icon(Icons.clear),
//                           //             //         onPressed: () {
//                           //             //           /* Clear the search field */
//                           //             //         },
//                           //             //       ),
//                           //             //       hintText: 'Search...',
//                           //             //       border: InputBorder.none),
//                           //             // ),
//                           //             // Navigator.of(context).push(
//                           //             //   MaterialPageRoute(
//                           //             //     builder: (_) => const SearchPage(),
//                           //             //   ),
//                           //             // ),
//                           //             icon: const Icon(
//                           //               Icons.search,
//                           //               color: Colors.black,
//                           //             ))
//                           //
//                           //     // Icon(
//                           //     //   Icons.search,
//                           //     //   size: 25,
//                           //     //   color: AppColor.bold_text_color_dark_blue,
//                           //     // ),
//                           //     ),
//                           // Container(
//                           //   margin: const EdgeInsets.only(right: 15),
//                           //   child: InkWell(
//                           //     onTap: () {
//                           //       BottomSheetDialog(context, TaskBottomSheet()).showScreen();
//                           //     },
//                           //     child: const Icon(
//                           //       Icons.filter_alt_outlined,
//                           //       size: 28,
//                           //       color: AppColor.bold_text_color_dark_blue,
//                           //     ),
//                           //   ),
//                           // )
//                         ]
//                       : _selectedItemIndex == 2
//                           ? [
//                               Container(
//                                 margin: const EdgeInsets.only(right: 15),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => MyAlerts()));
//                                   },
//                                   child: const Icon(
//                                     Icons.notifications_none_outlined,
//                                     size: 25,
//                                     color: AppColor.bold_text_color_dark_blue,
//                                   ),
//                                 ),
//                               )
//                             ]
//                           : isSearch
//                               ? [
//                                   Container(
//                                     width: mediaQW(context) * 0.8,
//                                     height: 40,
//                                     decoration:
//                                         BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//                                     child: Center(
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(left: 12),
//                                         child: TextField(
//                                           decoration: InputDecoration(
//                                               suffixIcon: IconButton(
//                                                 icon: const Icon(
//                                                   Icons.clear,
//                                                   color: Colors.black,
//                                                 ),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     isSearch = false;
//                                                   });
//                                                   /* Clear the search field */
//                                                 },
//                                               ),
//                                               hintText: 'Search...',
//                                               border: InputBorder.none),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 15),
//                                     child: InkWell(
//                                       onTap: () {
//                                         BottomSheetDialog(context, TaskBottomSheet()).showScreen();
//                                       },
//                                       child: const Icon(
//                                         Icons.filter_alt_outlined,
//                                         size: 28,
//                                         color: AppColor.bold_text_color_dark_blue,
//                                       ),
//                                     ),
//                                   ),
//                                 ]
//                               : [
//                                 ],
//         ),
//         drawer: AppDrawer(),
//         resizeToAvoidBottomInset: true,
//         body: pages[_selectedItemIndex],
//         // bottom app bar
//         bottomNavigationBar: BottomAppBar(
//           color: AppColor.white,
//           shape: CircularNotchedRectangle(),
//           child: Container(
//             height: 70,
//             padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
//             margin: EdgeInsets.only(top: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // button 1
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       setBottomBarIndex(0);
//                     });
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         // color: Colors.red,
//                         child: SvgPicture.asset(ImageConstant.home,
//                         colorFilter: ColorFilter.mode(_selectedItemIndex == 0 ?
//                         AppColor.primary : AppColor.hint_color_grey,
//                             BlendMode.srcIn),//_selectedItemIndex == 0 ? AppColor.primary : AppColor.hint_color_grey,
//                         height: 20, width: 20,),
//
//                       ),
//                       SizedBox(height: 4,),
//                       Text(
//                         "Home",
//                         style: mpHeadLine14(
//                           textColor: _selectedItemIndex == 0 ? AppColor.primary : AppColor.hint_color_grey,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 // button 2
//                 pref.getBool(Constants.is_prime)!=null && pref.getBool(Constants.is_prime)==true
//                     &&
//                     pref.getString(Constants.plan_name)!=null &&
//                     pref.getString(Constants.plan_name)!.toLowerCase()=="gold"? GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       setBottomBarIndex(1);
//                     });
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         // color: Colors.red,
//                         child:Icon(Icons.task,
//                     color: _selectedItemIndex == 1 ?
//                     AppColor.primary : Colors.grey.shade300,)
//                   // SvgPicture.asset(ImageConstant.document,
//                   //   colorFilter: ColorFilter.mode(_selectedItemIndex == 1 ? AppColor.primary : AppColor.hint_color_grey,
//                   //       BlendMode.srcIn),//_selectedItemIndex == 0 ? AppColor.primary : AppColor.hint_color_grey,
//                   //   height: 20, width: 20,)
//                       ),
//                       SizedBox(height: 4,),
//                       Text(
//                         "Task",
//                         style: mpHeadLine14(
//                           textColor: _selectedItemIndex == 1 ? AppColor.primary : AppColor.hint_color_grey,
//                         ),
//                       )
//                     ],
//                   ),
//                 ):SizedBox(),
//                 // button 3
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       setBottomBarIndex(2);
//                     });
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         // color: Colors.red,
//                         child:  Icon(Icons.list_alt_rounded,
//                   color: _selectedItemIndex == 2 ? AppColor.primary : Colors.grey.shade300,)
//
//                         // SvgPicture.asset(ImageConstant.document,
//                         //     colorFilter: ColorFilter.mode(_selectedItemIndex == 2 ? AppColor.primary : AppColor.hint_color_grey,
//                         //         BlendMode.srcIn),//_selectedItemIndex == 0 ? AppColor.primary : AppColor.hint_color_grey,
//                         //     height: 20, width: 20,)
//                       ),
//                       SizedBox(height: 4,),
//                       Text(
//                         "Causes List",
//                         style: mpHeadLine14(
//                           textColor: _selectedItemIndex == 2 ? AppColor.primary : AppColor.hint_color_grey,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 // button 4
//                 pref.getBool(Constants.is_prime)!=null && pref.getBool(Constants.is_prime)==true
//                     &&
//                     pref.getString(Constants.plan_name)!=null &&
//                     pref.getString(Constants.plan_name)!.toLowerCase()=="gold"?
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       pages.removeLast();
//                       pages.add (MyCases(selectedData: widget.selectedWatchlistData));
//                       // pages.add (MyCasesScrollbar(selectedCase: widget.selectedWatchlistData));
//                       setBottomBarIndex(3);
//                     });
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         // color: Colors.red,
//                         child: SvgPicture.asset(ImageConstant.document_edit,
//                     colorFilter: ColorFilter.mode(_selectedItemIndex == 3 ? AppColor.primary : AppColor.hint_color_grey,
//                         BlendMode.srcIn),//_selectedItemIndex == 0 ? AppColor.primary : AppColor.hint_color_grey,
//                     height: 20, width: 25,)
//                       ),
//                       SizedBox(height: 4,),
//                       Text(
//                         "Cases",
//                         style: mpHeadLine14(
//                           textColor: _selectedItemIndex == 3 ? AppColor.primary : AppColor.hint_color_grey,
//                         ),
//                       )
//                     ],
//                   ),
//                 ):SizedBox(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
