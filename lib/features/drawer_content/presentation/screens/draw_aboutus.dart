import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/aboutus_state.dart';

import '../../cubit/aboutus_cubit.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  void initState() {
    BlocProvider.of<AboutUsCubit>(context).fetchAboutUs();
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
          "About Us",
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
            BlocConsumer<AboutUsCubit, AboutUsState>(
                builder: (context, state) {
                  if (state is AboutUsLoading) {
                    return SizedBox(
                      height: mediaQH(context) * 0.8,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is AboutUsLoaded) {
                    var aboutUsList = state.aboutUsModel;
                    if (aboutUsList.result == 1) {
                      if (aboutUsList.data != null) {
                        var aboutUsData = aboutUsList.data;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About the App",
                                style: mpHeadLine14(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                aboutUsData!.description.toString(),
                                style: mpHeadLine12(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1.5,
                                color: AppColor.text_grey_color,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "About Founder",
                                style: mpHeadLine14(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.network(
                                aboutUsData.imgLink!,
                                height: 120,
                                width: 110,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                aboutUsData!.aboutFounder.toString(),
                                style: mpHeadLine12(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      toast(msg: aboutUsList.msg.toString());
                    }
                  }
                  return const SizedBox();
                },
                listener: (context, state) {})
          ],
        ),
      ),
    );
  }
}
