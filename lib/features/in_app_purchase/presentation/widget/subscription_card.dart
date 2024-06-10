import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/my_subscription_model.dart';

import '../../../../widgets/date_format.dart';

class SubscriptionCard extends StatefulWidget {
  ActivePlans plans;
  SubscriptionCard(this.plans, {super.key});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("OrderID: #${widget.plans.orderCustomId}",
                        style: appTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      height: 3,
                    ),
                    Text("${widget.plans.startDate}",
                        style: appTextStyle(
                          fontSize: 14,
                        )),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.check_circle,
                        color: AppColor.complete_color_text, size: 20),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                        "${widget.plans.planCode == "A" ? "Active" : "Expired"}",
                        style: appTextStyle(
                            fontSize: 12,
                            textColor: AppColor.complete_color_text)),
                  ],
                )
              ],
            ),
          ),
          Divider(color: AppColor.hint_color_grey, height: 1),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text("${widget.plans.planName}",
                style: appTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    textColor: AppColor.primary)),
          ),
          Divider(color: AppColor.hint_color_grey, height: 1),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8, top: 8),
            child: Text("Txn ID: 9837598273527385972",
                style: appTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    textColor: AppColor.hint_color_grey)),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: AppColor.hint_color_grey.withOpacity(0.2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Plan Starting",
                        style: appTextStyle(
                          fontSize: 11,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.access_time,
                      size: 11,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(getddMMyyyyhhmm(widget.plans.startDate.toString()),
                        style: appTextStyle(fontSize: 11)),
                  ],
                ),
                Row(
                  children: [
                    Text("Expiring",
                        style: appTextStyle(
                            fontSize: 11, textColor: AppColor.primary)),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.access_time, size: 11, color: AppColor.primary),
                    SizedBox(
                      width: 5,
                    ),
                    Text(getddMMyyyyhhmm(widget.plans.endDate.toString()),
                        style: appTextStyle(
                            fontSize: 11, textColor: AppColor.primary)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
