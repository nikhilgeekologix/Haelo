import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';

class LowerCourtDetails extends StatefulWidget {
  final getLowerCourt;
  const LowerCourtDetails({Key? key, this.getLowerCourt}) : super(key: key);

  @override
  State<LowerCourtDetails> createState() => _LowerCourtDetailsState();
}

class _LowerCourtDetailsState extends State<LowerCourtDetails> {
  @override
  Widget build(BuildContext context) {
    return widget.getLowerCourt!=null?
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: "Case No.: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getLowerCourt!.lowerCourtDetails!.caseNo ?? "", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Judgeship: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.getLowerCourt!.lowerCourtDetails!.judgeship ?? "", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Place: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getLowerCourt!.lowerCourtDetails!.place ?? "", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Court: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getLowerCourt!.lowerCourtDetails!.court ?? "", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // used Row in place of richtext so that card occupies appropriate space in page.
                  Row(
                    children: [
                      Text("Date of impugned order: ", style: mpHeadLine12(fontWeight: FontWeight.w600)),
                      Text(widget.getLowerCourt!.lowerCourtDetails!.dateOfImpugnedOrder ?? "", style: mpHeadLine12()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ):NoDataAvailable("Lower Court Details will be shown here.");
  }
}
