import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/paperdetail_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/paperdetail_state.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';

class PaperDetails extends StatefulWidget {
  final getCaseId;
  const PaperDetails({Key? key, this.getCaseId}) : super(key: key);

  @override
  State<PaperDetails> createState() => _PaperDetailsState();
}

class _PaperDetailsState extends State<PaperDetails> {
  void initState() {
    var caseIdDetails = {
      "caseId": widget.getCaseId.toString(),
    };
    BlocProvider.of<PaperDetailCubit>(context).fetchPaperDetail(caseIdDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: BlocConsumer<PaperDetailCubit, PaperDetailState>(
          builder: (context, state) {
            if(state is PaperDetailLoading){
              return TabProgressIndicator();
            }
            if (state is PaperDetailLoaded) {
              var myPaperDetailModel = state.paperDetailModel;
              if (myPaperDetailModel.result == 1) {
                if (myPaperDetailModel.data != null) {
                  var paperDetailData = myPaperDetailModel.data;
                  return paperDetailData!.paperDetail!.isNotEmpty?
                  ListView.builder(
                    itemCount: paperDetailData!.paperDetail!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Advocate: ",
                                    style: mpHeadLine12(fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: paperDetailData.paperDetail![index].advocate, style: mpHeadLine12()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Association: ",
                                    style: mpHeadLine12(fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: paperDetailData.paperDetail![index].association, style: mpHeadLine12()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Date: ",
                                    style: mpHeadLine12(fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(text: paperDetailData.paperDetail![index].date, style: mpHeadLine12()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Fees:",
                                    style: mpHeadLine12(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${paperDetailData.paperDetail![index].fees}",
                                        style: mpHeadLine12(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "No.: ",
                                    style: mpHeadLine12(fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(text: paperDetailData.paperDetail![index].no, style: mpHeadLine12()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Type: ",
                                    style: mpHeadLine12(fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(text: paperDetailData.paperDetail![index].type, style: mpHeadLine12()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ):NoDataAvailable("Paper Details will be shown here.");
                }
              } else {
                //toast(msg: myPaperDetailModel.msg.toString());
              }
              return NoDataAvailable("Paper Details will be shown here.");
            }
            return const SizedBox();
          },
          listener: (context, state) {},
        ));
  }
}
