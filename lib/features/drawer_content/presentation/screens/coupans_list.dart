import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/coupons_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/coupons_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/functions.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../../widgets/progress_indicator.dart';
import '../../../cases/presentation/widgets/no_data_widget.dart';
import '../../cubit/coupons_state.dart';

class CouponList extends StatefulWidget {
  const CouponList({Key? key}) : super(key: key);

  @override
  State<CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  bool isLoading = true;

  List<Data> promoCodeList = [];

  @override
  void initState() {
    // couponsList = widget.couponList ?? [];
    BlocProvider.of<CouponsCubit>(context).fetchCouponsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
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
          "My coupons",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
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
      body: Stack(children: [
        BlocConsumer<CouponsCubit, CouponState>(builder: (context, state) {
          return SizedBox();
        }, listener: (context, state) {
          if (state is CouponLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is CouponLoaded) {
            var model = state.couponsModel;
            if (model.result == 1 && model.data != null) {
              setState(() {
                isLoading = false;
              });
              setState(() {
                promoCodeList = model.data!;
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }
          }
          if (state is CouponError) {
            setState(() {
              isLoading = false;
            });
            if (state.message == "InternetFailure()") {
              toast(msg: "Please check internet connection");
            } else {
              toast(msg: "Something went wrong");
            }
          }
        }),
        promoCodeList.isNotEmpty
            ? ListView.builder(
                itemCount: promoCodeList.length,
                itemBuilder: (BuildContext context, int index) {
                  var model = promoCodeList[index];
                  DateTime dateTime =
                      DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'")
                          .parse(model.expiryDate.toString());

                  String formattedDate =
                      DateFormat("dd-MM-yyyy").format(dateTime);
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0XFFFFD700), width: 2),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    model.planName.toString().toUpperCase(),
                                    style: appTextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        textColor: AppColor.primary),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "${model.validity} Month",
                                    style: appTextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppColor.primary),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                model.promocode.toString(),
                                style: appTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    textColor: AppColor.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Expiry Date: $formattedDate",
                                style: appTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColor.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.content_copy),
                                onPressed: () {
                                  toast(msg: "Coupon Copied");
                                  FlutterClipboard.copy(
                                          model.promocode.toString())
                                      .then((_) => print(
                                          'Copied to clipboard: ${model.promocode.toString()}'));
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share(
                                      'Check out this coupon: ${model.promocode.toString()}');
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : NoDataAvailable("No Coupons found."),
        Visibility(
          visible: isLoading,
          child: const Center(child: AppProgressIndicator()),
        ),
      ]),
    );
  }
}
