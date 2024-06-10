import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class MyWebView extends StatefulWidget {
  String url = '';
  String pageTitle;//hightlight, firm name

  MyWebView(this.url, this.pageTitle):super();

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  bool isLoading=true;

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
          widget.pageTitle,
          style: mpHeadLine16(fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: const [],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useOnDownloadStart: true,
                javaScriptEnabled: true,
              ),
            ),
            onLoadStop: (controller, url) {
              setState(() {
                isLoading=false;
              });
              _applyCustomStyle(controller);
            },
            onLoadStart: (controller, url){
              setState(() {
                isLoading=true;
              });
            },
          ),
          Visibility(
            visible: isLoading,
            child: const Center(child: AppProgressIndicator()),
          ),
        ],
      ),
    );
  }

  void _applyCustomStyle(InAppWebViewController controller) async {
    await controller.evaluateJavascript(source: '''
      var style = document.createElement('style');
      style.innerHTML = 'p {font-family: Roboto, sans-serif!important; font-size:14px!important; font-weight:400;line-height: 1.5!important; margin-top:5px!important;margin-bottom:5px!important;margin-left:0px!important; }';
      document.head.appendChild(style);
    ''');
    await controller.evaluateJavascript(source: '''
      var style = document.createElement('style');
      style.innerHTML = 'h2 {font-family: Roboto, sans-serif!important; font-size:20px!important; font-weight:600;margin-top:10px!important;margin-bottom:10px!important;padding-left:5px!important;}';
      document.head.appendChild(style);
    ''');
  }
}



