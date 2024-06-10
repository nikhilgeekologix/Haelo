import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';

class FilingDetails extends StatefulWidget {
  final getFilingData;
  const FilingDetails({Key? key, this.getFilingData}) : super(key: key);

  @override
  State<FilingDetails> createState() => _FilingDetailsState();
}

class _FilingDetailsState extends State<FilingDetails> {
  @override
  Widget build(BuildContext context) {
    return widget.getFilingData!=null?
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
                        text: "Number: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getFilingData!.filingDetail!.number!=null?
                          widget.getFilingData!.filingDetail!.number:"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Court Fees: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getFilingData!.filingDetail!.courtFees!=null?
                          widget.getFilingData!.filingDetail!.courtFees:"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Filing Date: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getFilingData!.filingDetail!.filingDate!=null?
                          widget.getFilingData!.filingDetail!.filingDate:"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // used Row in place of richtext so that card occupies appropriate space in page.
                  Row(
                    children: [
                      Text("Main Case: ", style: mpHeadLine12(fontWeight: FontWeight.w600)),
                      widget.getFilingData!.filingDetail!.mainCase!=null?
                      Text(widget.getFilingData!.filingDetail!.mainCase, style: mpHeadLine12()):SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ): NoDataAvailable("Filling Details will be shown here.");
  }
}
