import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/faq_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/faq_state.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/appExpandedTile.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  void initState() {
    BlocProvider.of<FAQCubit>(context).fetchFAQ();
    super.initState();
  }

  var isOpen = false;
  List<bool> booleanList = [];
  var fAQData;
  setCallback(int index, isClick) {
    if (isClick) {
      for (int i = 0; i < fAQData.length; i++) {
        booleanList[i] = (false);
      }
      booleanList[index] = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "FAQs",
          style: mpHeadLine16(fontWeight: FontWeight.w500, textColor: AppColor.bold_text_color_dark_blue),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<FAQCubit, FAQState>(builder: (context, state) {
              if (state is FAQLoading) {
                return SizedBox(
                  height: mediaQH(context) * 0.8,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is FAQLoaded) {
                var fAQList = state.fAQModel;
                if (fAQList.result == 1) {
                  if (fAQList.data != null) {
                    fAQData = fAQList.data;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: fAQData!.length,
                        itemBuilder: (state, index) {
                          return AppExpandedTile(
                              tileTitle: fAQData[index].question!.toString(),
                              tileContent: fAQData[index].answer.toString(),
                              isOpen: booleanList[index],
                              index: index,
                              setCallback: setCallback);
                          //   Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                          //       child: InkWell(
                          //         onTap: () {
                          //           setState(() {
                          //             isOpen = !isOpen;
                          //           });
                          //         },
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //               fAQData[index].question!.toString(),
                          //               style:
                          //                   mpHeadLine12(textColor: AppColor.primary, fontWeight: FontWeight.w600),
                          //             ),
                          //             const Icon(
                          //               Icons.keyboard_arrow_down_outlined,
                          //               color: AppColor.primary,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     Visibility(
                          //       visible: isOpen,
                          //       child: Column(
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(
                          //               left: 10,
                          //               right: 10,
                          //               top: 15,
                          //             ),
                          //             child: Text(
                          //               fAQData[index].answer.toString(),
                          //               style: mpHeadLine12(fontWeight: FontWeight.w500),
                          //             ),
                          //           ),
                          //           const Padding(
                          //             padding: EdgeInsets.symmetric(horizontal: 10),
                          //             child: Divider(
                          //               thickness: 1.5,
                          //               color: AppColor.text_grey_color,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // );
                        });
                  }
                } else {
                  toast(msg: fAQList.msg.toString());
                }
              }
              return const SizedBox();
            }, listener: (context, state) {
              if (state is FAQLoaded) {
                var fAQSList = state.fAQModel;
                if (fAQSList.result == 1) {
                  if (fAQSList.data != null) {
                    for (int i = 0; i < fAQSList.data!.length; i++) {
                      if(i==0){
                        booleanList.add(true);
                      }else
                      booleanList.add(false);
                    }
                  }
                }
              }
            })
          ],
        ),
      ),
    );
  }
}
