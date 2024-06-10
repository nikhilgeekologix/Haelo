import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/my_subscription_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/my_subscription_state.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/my_subscription_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/plans.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/trial_page.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/widget/subscription_card.dart';
import 'package:haelo_flutter/widgets/app_button.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class MySubscription extends StatefulWidget {
  const MySubscription({super.key});

  @override
  State<MySubscription> createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> {

  @override
  void initState() {
    BlocProvider.of<MySubscriptionCubit>(context).fetchAllMySubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
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
          titleSpacing: 0,
          centerTitle: false,
          backgroundColor: AppColor.white,
          title: Text(
            "My Subscription",
            style: mpHeadLine16(
                fontWeight: FontWeight.w500,
                textColor: AppColor.bold_text_color_dark_blue),
          ),
        ),
          body: Column(
            children: [
              Expanded(
                child: BlocConsumer<MySubscriptionCubit, MySubscriptionState>(
                    builder: (context, state) {
                  if (state is MySubscriptionLoading) {
                    return AppProgressIndicator();
                  }
                  if(state is MySubscriptionLoaded){
                    var model = state.model;
                    if(model.result==1 && model.data!=null) {
                      return Column(
                      children: [
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10,
                              vertical: 10),
                          child: Container(
                            height: 45,
                            width: double.maxFinite,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0)
                            ),
                            child:  TabBar(
                              indicator: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius:  BorderRadius.circular(25.0)
                              ) ,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              isScrollable: false,

                              splashBorderRadius: BorderRadius.circular(25),
                              tabs: const  [
                                Tab(text: 'Active Plan',),
                                //Tab(text: 'Upcoming Plan',),
                                Tab(text: 'Expired Plan',),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: TabBarView(
                              children:  [
                                listView(context,model.data!.activePlans),
                                //listView(context, model.data!.expirePlans),
                                listView(context, model.data!.expirePlans),
                              ],
                            )
                        )
                      ],
                    );
                    }else{
                      return NoDataAvailable(
                          "Subscription data not found.");
                    }
                  }
                  return SizedBox();
                },
                    listener: (context, state) {
                      if (state is MySubscriptionError) {
                        if (state.message == "InternetFailure()") {
                          toast(msg: "Please check internet connection");
                        } else {
                          toast(msg: "Something went wrong");
                        }
                      }
                    }),
              ),
              SizedBox(height: 10,),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: AppButton(btnName: "Buy Now",
              //       voidCallback: (){
              //         goToPage(context, Plans());
              //       }),
              // ),
              // SizedBox(height: 5,),
            ],
          ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //     goToPage(context, PrimeTrialPage());
        //   },
        // ),
      ),
    );
  }


  Widget listView(context, List<ActivePlans>? plansList){
    return plansList!.isNotEmpty?
    ListView.builder(
        itemCount: plansList!.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
      return SubscriptionCard(plansList[index]);
    }):NoDataAvailable("No plan data found");
  }

}
