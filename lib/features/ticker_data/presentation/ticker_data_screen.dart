import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/ticker_data/cubit/ticker_data_cubit.dart';
import 'package:haelo_flutter/features/ticker_data/cubit/ticker_data_state.dart';
import 'package:haelo_flutter/features/ticker_data/data/model/ticker_data_model.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class TickerDataTableScreen extends StatefulWidget {
  const TickerDataTableScreen({super.key});

  @override
  State<TickerDataTableScreen> createState() => _TickerDataTableScreenState();
}

class _TickerDataTableScreenState extends State<TickerDataTableScreen> {
  bool isLoading = true;
  var tickerTableData;
  List<String> tickerDateList = [];
  String? selectedTickerDate;
  bool isTickerTableFirstTime = true;

  int _currentSortColumn = 0;
  String _selectedCourtValue = "";
  bool _isAscending = true;
  List<TickerData> tickerTableList = [];
  List<TickerData> filterArray = [];
  List<TickerData> searchList = [];
  List<String> courtNoList = [];

  bool isSearch = false;
  bool isSearchFilter = false;

  @override
  void initState() {
    Map<String, String> tickerDataBody = {};
    BlocProvider.of<TickerDataCubit>(context).getTickerData(tickerDataBody);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.home_background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "Ticker Data",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: isSearch
            ? [
                Container(
                  width: mediaQW(context) * 0.8,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            searchFilterList(value.toLowerCase());
                          } else {
                            setState(() {
                              isSearchFilter = false;
                              searchList = [];
                            });
                          }
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isSearch = false;
                                  isSearchFilter = false;
                                  searchList = [];
                                });
                                /* Clear the search field */
                              },
                            ),
                            hintText: 'Search...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        goToHomePage(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.home_outlined,
                          size: 30,
                        ),
                      ),
                    )),
              ]
            : [
                IconButton(
                    onPressed: () => setState(() {
                          isSearch = true;
                        }),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
                // const SizedBox(
                //   width: 22,
                // ),
                GestureDetector(
                  onTap: () {
                    goToHomePage(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.home_outlined,
                      size: 30,
                    ),
                  ),
                )
              ],
      ),
      body: Stack(
        children: [
          BlocConsumer<TickerDataCubit, TickerDataState>(
              builder: (context, state) {
            return const SizedBox();
          }, listener: (context, state) {
            if (state is TickerDataLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is TickerDataLoaded) {
              final model = state.model;
              if (model.result == 1 && model.data != null) {
                setState(() {
                  tickerTableData = null;
                  tickerTableData = model.data;
                  tickerTableList = model.data!.tickerData!;
                  tickerDateList = tickerTableData.expiryList;
                  /* courtNoList = tickerTableList
                          .map((data) => (data.courtNo ?? '').toString())
                          .toList() ??
                      [];*/
                  List<int> courtSortingList = tickerTableList
                      .map((data) => int.tryParse(data.courtNo ?? '') ?? 0)
                      .toList();
                  courtSortingList.sort();

                  print("courtSortingList: $courtSortingList");
                  List<String> sortedCourtNoStrings = courtSortingList
                      .map((number) => number.toString())
                      .toList();

                  courtNoList = sortedCourtNoStrings;
                  courtNoList = courtNoList.toSet().toList();

                  courtNoList.insert(0, "Court");
                  print("courtNoList $courtNoList");

                  _selectedCourtValue = courtNoList[0];

                  if (isTickerTableFirstTime) {
                    selectedTickerDate = tickerTableData.expiryList[0];
                  }
                  isLoading = false;
                  isTickerTableFirstTime = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                  tickerTableData = null;
                });
              }
            }
          }),
          AbsorbPointer(
            absorbing: isLoading,
            child: Opacity(
              opacity: !isLoading ? 1.0 : 0.0,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: double.maxFinite,
                ),
                padding: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: tickerDateList.isNotEmpty &&
                          tickerTableList.isNotEmpty &&
                          courtNoList.isNotEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: mediaQH(context) * 0.05,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black54, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          underline: SizedBox(),
                                          // Initial Value
                                          value: selectedTickerDate,
                                          // Down Arrow Icon
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          // Array list of items
                                          items: tickerDateList.map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                  getddMMYYYY_with_splash(
                                                      items)),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedTickerDate = newValue;
                                              print(
                                                  "dropdownvalue $selectedTickerDate");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: mediaQH(context) * 0.05,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black54, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          underline: SizedBox(),
                                          // Initial Value
                                          value: _selectedCourtValue,
                                          // Down Arrow Icon
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          // Array list of items
                                          items: courtNoList.map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedCourtValue = newValue!;
                                              filterArray = tickerTableList
                                                  .where((element) =>
                                                      element.courtNo ==
                                                      _selectedCourtValue)
                                                  .toList();
                                              print(
                                                  "_selectedCourtValue $_selectedCourtValue");
                                              print(
                                                  "filterArrry ${filterArray}");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isTickerTableFirstTime = false;
                                        });
                                        Map<String, String> tickerDataBody = {
                                          "selectedDate": "$selectedTickerDate"
                                        };
                                        BlocProvider.of<TickerDataCubit>(
                                                context)
                                            .getTickerData(tickerDataBody);
                                      },
                                      child: Container(
                                        height: mediaQH(context) * 0.05,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: AppColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text("Update",
                                            style: appTextStyle(
                                                fontSize: 16,
                                                textColor: AppColor.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///dropdown
                            tickerTableList.isNotEmpty
                                ? searchList.isEmpty && !isSearchFilter
                                    ? Expanded(
                                        child: tableWidget(
                                            _selectedCourtValue ==
                                                    courtNoList[0]
                                                ? tickerTableList
                                                : filterArray),
                                      )
                                    : searchList.isNotEmpty
                                        ? Expanded(
                                            child: tableWidget(searchList),
                                          )
                                        : Column(
                                            children: [
                                              SizedBox(
                                                height: 100,
                                              ),
                                              NoDataAvailable(
                                                "Search data not found.",
                                                isTopmMargin: false,
                                              ),
                                            ],
                                          )
                                : NoDataAvailable(
                                    "Your Ticker Data will be shown here.")
                          ],
                        )
                      : NoDataAvailable("Your Ticker Data will be shown here."),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(child: AppProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget tableWidget(List<TickerData> list) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.black,
            )),
        child: DataTable2(
            dividerThickness: 0.0,
            columnSpacing: 0,
            horizontalMargin: 5,
            sortArrowBuilder: (a, b) {
              return Icon(
                Icons.swap_vert,
                size: 16,
              );
            },
            columns: [
              DataColumn(
                // numeric: false,
                label: Container(
                  // width: mediaQW(
                  //     context) *
                  //     0.14,
                  child: Center(
                    child: Text(
                      "S.No.",
                      style: appTextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // onSort: (columnIndex, _) {
                //   setState(() {
                //     _currentSortColumn = columnIndex;
                //     if (_isAscending == true) {
                //       _isAscending = false;
                //       // sort the product list in Ascending, order by Price
                //      tickerTableList.reversed;
                //     } else {
                //       _isAscending = true;
                //       // sort the product list in Descending, order by Price
                //       tickerTableList.sort((productA, productB) =>
                //           productA.courtNo!.compareTo(productB.courtNo!));
                //     }
                //   });
                //   print("ok columnIndex $columnIndex _currentSortColumn "
                //       "$_currentSortColumn _isAscending $_isAscending");
                // },
              ),
              DataColumn(
                label: Center(
                  child: Container(
                    // width:
                    // mediaQW(context) *
                    //     0.16,
                    child: Text(
                      "Court \n No.",
                      style: appTextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      list.sort((productA, productB) =>
                          int.parse(productB.courtNo!)
                              .compareTo(int.parse(productA.courtNo!)));

                      // List<TickerData> sortedList=list.map((e) => e).toList()
                      //   ..sort((productA, productB) =>
                      //       int.parse(productB.courtNo!).compareTo( int.parse(productA.courtNo!)));
                      // sort the product list in Ascending, order by Price
                      //list=  sortedList;
                    } else {
                      _isAscending = true;
                      list.sort((productA, productB) =>
                          int.parse(productA.courtNo!)
                              .compareTo(int.parse(productB.courtNo!)));
                      // sort the product list in Descending, order by Price
                      // List<TickerData> sortedList=list.map((e) => e).toList()..sort((productA, productB) =>
                      //     int.parse(productA.courtNo!).compareTo(int.parse(productB.courtNo!)));
                      //
                      // list=  sortedList;
                    }
                  });
                },
              ),
              DataColumn(
                label: Container(
                  child: Center(
                    child: Text(
                      "Item \n No.",
                      style: appTextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      // sort the product list in Ascending, order by Price
                      list.sort((productA, productB) => int.parse(productB
                              .itemNo!
                              .replaceAll("(", "")
                              .replaceAll(")", "")
                              .replaceAll("D", "")
                              .replaceAll("S", "")
                              .split("-")
                              .first)
                          .compareTo(int.parse(productA.itemNo!
                              .replaceAll("(", "")
                              .replaceAll(")", "")
                              .replaceAll("D", "")
                              .replaceAll("S", "")
                              .split("-")
                              .first)));
                    } else {
                      _isAscending = true;
                      // sort the product list in Descending, order by Price
                      list.sort((productA, productB) => int.parse(productA
                              .itemNo!
                              .replaceAll("(", "")
                              .replaceAll(")", "")
                              .replaceAll("D", "")
                              .replaceAll("S", "")
                              .split("-")
                              .first)
                          .compareTo(int.parse(productB.itemNo!
                              .replaceAll("(", "")
                              .replaceAll(")", "")
                              .replaceAll("D", "")
                              .replaceAll("S", "")
                              .split("-")
                              .first)));
                      // tickerTableList.sort((productA, productB) =>
                      //     productA.itemNo!.compareTo(productB.itemNo!));
                    }
                  });
                  print("ok columnIndex $columnIndex _currentSortColumn "
                      "$_currentSortColumn _isAscending $_isAscending");
                },
              ),
              DataColumn(
                label: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Start",
                          style: appTextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Time",
                          style: appTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;

                      list.sort((productA, productB) {
                        DateTime _dateTime =
                            DateFormat("hh:mm:ss a").parse(productA.time!);
                        DateTime _dateTime1 =
                            DateFormat("hh:mm:ss a").parse(productB.time!);
                        return _dateTime!.compareTo(_dateTime1);
                      });
                    } else {
                      _isAscending = true;
                      list.sort((productA, productB) {
                        DateTime _dateTime =
                            DateFormat("hh:mm:ss a").parse(productA.time!);
                        DateTime _dateTime1 =
                            DateFormat("hh:mm:ss a").parse(productB.time!);
                        return _dateTime1!.compareTo(_dateTime);
                      });
                    }
                  });
                },
              ),
              DataColumn(
                label: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "End",
                          style: appTextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Time",
                          style: appTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;

                      list.sort((productA, productB) {
                        DateTime _dateTime =
                            DateFormat("hh:mm:ss a").parse(productA.time!);
                        DateTime _dateTime1 =
                            DateFormat("hh:mm:ss a").parse(productB.time!);
                        // _dateTime = DateTime.(_dateTime);
                        //  print(_dateTime);
                        return _dateTime!.compareTo(_dateTime1);
                      });

                      // list.sort((productA, productB) =>
                      //     productB.time!.compareTo(productA.time!));
                    } else {
                      _isAscending = true;
                      // sort the product list in Descending, order by Price
                      list.sort((productA, productB) {
                        DateTime _dateTime =
                            DateFormat("hh:mm:ss a").parse(productA.time!);
                        DateTime _dateTime1 =
                            DateFormat("hh:mm:ss a").parse(productB.time!);
                        // _dateTime = DateTime.(_dateTime);
                        //  print(_dateTime);
                        return _dateTime1.compareTo(_dateTime);
                      });
                    }
                  });
                  print("ok columnIndex $columnIndex _currentSortColumn "
                      "$_currentSortColumn _isAscending $_isAscending");
                },
              ),
            ],
            sortColumnIndex: _currentSortColumn,
            sortAscending: _isAscending,
            rows: List<DataRow>.generate(
                tickerTableData != null ? list.length : 0, (int index) {
              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08);
                  }
                  if (index.isEven) {
                    return AppColor.display_board;
                  }
                  return null;
                }),
                cells: <DataCell>[
                  DataCell(
                    Center(
                      child: Text("${index + 1}",
                          style: mpHeadLine14(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                          list[index].courtNo.toString().isNotEmpty
                              ? list[index].courtNo.toString()
                              : "",
                          style: mpHeadLine14(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                          list[index].itemNo.toString().isNotEmpty
                              ? list[index].itemNo.toString()
                              : "",
                          style: mpHeadLine14(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                          list[index].startTime.toString().isNotEmpty
                              ? list[index].startTime.toString() != "null"
                                  ? covertTableTime(
                                      list[index].startTime.toString())
                                  : "-"
                              : "",
                          style: mpHeadLine14(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                          list[index].time.toString().isNotEmpty
                              ? covertTableTime(list[index].time.toString())
                              : "",
                          style: mpHeadLine14(fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              );
            })),
      ),
    );
  }

  void searchFilterList(String searchKey) {
    setState(() {
      searchList = [];
    });

    for (var item in tickerTableList) {
      if (item.courtNo!.toLowerCase().contains(searchKey) ||
          item.itemNo!.toLowerCase().contains(searchKey) ||
          item.time!.toLowerCase().contains(searchKey)) {
        if (!searchList.contains(item)) {
          searchList.add(item);
        }
      }
    }
    print("searchlist length ${searchList.length}");
    isSearchFilter = true;
    setState(() {});
  }

  String covertTableTime(String originalTime) {
    DateFormat inputFormat = DateFormat("h:mm:ss a");
    DateFormat outputFormat = DateFormat("h:mm a");

    DateTime dateTime = inputFormat.parse(originalTime);
    String convertedTime = outputFormat.format(dateTime);

    return convertedTime;
  }
}
