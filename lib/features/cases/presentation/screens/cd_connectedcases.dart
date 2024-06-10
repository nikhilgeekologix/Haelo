import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';

class ConnectedCases extends StatefulWidget {
  final getConnectedCases;
  const ConnectedCases({Key? key, this.getConnectedCases}) : super(key: key);

  @override
  State<ConnectedCases> createState() => _ConnectedCasesState();
}

class _ConnectedCasesState extends State<ConnectedCases> {
  @override
  Widget build(BuildContext context) {
    return widget.getConnectedCases!=null?
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
                        text: "Case Type: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getConnectedCases!.connectedCases!.tYPE ?? "", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  // used Row in place of richtext so that card occupies appropriate space in page.
                  Row(
                    children: [
                      Text("Case No.: ", style: mpHeadLine12(fontWeight: FontWeight.w600)),
                      Text(widget.getConnectedCases!.connectedCases!.no ?? "",
                          style: mpHeadLine12(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ): NoDataAvailable("Connected Cases will be shown here.");
  }
}
