import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/orderhistory_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/orderhistory_state.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool isLoading = true;
  var orderHistoryData;

  @override
  void initState() {
    var order = {
      "downloadFile": "",
      "requestType": "",
    };
    BlocProvider.of<OrderHistoryCubit>(context).fetchOrderHistory(order);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
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
          "Order/Judgement History",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          orderHistoryData != null
              ? InkWell(
                  onTap: () {
                    var comments = {
                      "downloadFile": "excel",
                    };
                    BlocProvider.of<OrderHistoryCubit>(context)
                        .fetchOrderHistory(comments);
                  },
                  child: Icon(
                    Icons.download,
                    size: 22,
                  ),
                )
              : SizedBox(),
          const SizedBox(
            width: 10,
          ),
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
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note: History will be for last 7 days rolling.",
                      style: mpHeadLine12(textColor: Colors.red.shade800),
                    ),
                    BlocConsumer<OrderHistoryCubit, OrderHistoryState>(
                        builder: (context, state) {
                      return const SizedBox();
                    }, listener: (context, state) {
                      if (state is OrderHistoryLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      if (state is OrderHistoryLoaded) {
                        var orderList = state.orderHistoryModel;
                        if (orderList.result == 1) {
                          if (orderList.data != null) {
                            if (orderList.data!.orderDetails != null &&
                                orderList.data!.orderDetails!.isNotEmpty) {
                              setState(() {
                                orderHistoryData = orderList.data;
                                isLoading = false;
                              });
                            }

                            //for download data
                            if (orderList.data!.downloadFile != null &&
                                orderList.data!.downloadFile!.isNotEmpty) {
                              print("subclass ifff????");
                              toast(msg: "Downloading started");
                              DateTime now = DateTime.now();
                              var fileName =
                                  "HAeLO_History_${now.millisecondsSinceEpoch}.${orderList.data!.downloadFile!.toString().split(".").last}";
                              downloadData(
                                  orderList.data!.downloadFile!, fileName);
                            }
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        isLoading = false;
                        setState(() {});
                      }
                    }),
                    orderHistoryData != null
                        ? ListView.builder(
                            itemCount: orderHistoryData!.orderDetails!.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.only(top: 15),
                                color: AppColor.display_board,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CaseDetails(
                                                  caseId: orderHistoryData
                                                      .orderDetails![index]
                                                      .caseId
                                                      .toString(),
                                                  index: 2,
                                                )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderHistoryData
                                              .orderDetails![index].message
                                              .toString(),
                                          style: mpHeadLine14(
                                              textColor: AppColor
                                                  .bold_text_color_dark_blue,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orderHistoryData
                                                  .orderDetails![index].date
                                                  .toString(),
                                              style: mpHeadLine12(
                                                  textColor: AppColor
                                                      .bold_text_color_dark_blue),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : isLoading
                            ? SizedBox()
                            : NoDataAvailable(
                                "Your order history will be shown here.")
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const Center(child: AppProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  downloadData(String file, fileName) async {
    await downloadFiles(file, fileName);
  }
}
