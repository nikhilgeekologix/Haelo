import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';

class ConnectedMatters extends StatefulWidget {
  final getConnectedMatters;
  const ConnectedMatters({Key? key, this.getConnectedMatters}) : super(key: key);

  @override
  State<ConnectedMatters> createState() => _ConnectedMattersState();
}

class _ConnectedMattersState extends State<ConnectedMatters> {
  @override
  Widget build(BuildContext context) {
    return widget.getConnectedMatters!=null?
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
                          TextSpan(
                              text: widget.getConnectedMatters!.connectedMatters!.type ?? "", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  // used Row in place of richtext so that card occupies appropriate space in page.
                  Row(
                    children: [
                      Text("Case No.: ", style: mpHeadLine12(fontWeight: FontWeight.w600)),
                      Text(widget.getConnectedMatters!.connectedMatters!.no ?? "", style: mpHeadLine12())
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ): NoDataAvailable("Connected Matters will be shown here.");
  }
}
