import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class AppExpandedTile extends StatefulWidget {
  final tileTitle;
  final tileContent;
  bool isOpen;
  final setCallback;
  final index;

  AppExpandedTile(
      {Key? key,
      required this.tileTitle,
      required this.tileContent,
      required this.isOpen,
      this.setCallback,
      this.index})
      : super(key: key);

  @override
  State<AppExpandedTile> createState() => _AppExpandedTileState();
}

class _AppExpandedTileState extends State<AppExpandedTile> {
  // bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                widget.setCallback(widget.index, true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: mediaQW(context) * 0.8,
                    child: Text(
                      widget.tileTitle,
                      style: appTextStyle(fontSize:13,
                          textColor: AppColor.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  !widget.isOpen
                      ? const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: AppColor.primary,
                        )
                      : const Icon(Icons.keyboard_arrow_up_outlined)
                ],
              ),
            ),
            Visibility(
              visible: widget.isOpen,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: mediaQW(context) * 0.86,
                    child: Text(
                      widget.tileContent,
                      style: mpHeadLine12(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Divider(
              thickness: 1,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
