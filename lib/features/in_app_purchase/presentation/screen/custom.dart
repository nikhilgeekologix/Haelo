import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:haelo_flutter/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/ui_helper.dart';

class Custom extends StatefulWidget {
  const Custom({Key? key}) : super(key: key);

  @override
  State<Custom> createState() => _CustomState();
}

class _CustomState extends State<Custom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0XFFFFD700), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Get upto 10% discount* by making a direct payment of the plan amount, at ',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            TextSpan(
                              text: 'below UPI id',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'haeloapp@ybl',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: AppColor.primary),
                            ),
                            TextSpan(
                              text: '\n\n',
                            ),
                            TextSpan(
                              text: 'Discounted* Plan amounts as below:\n\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Platinum',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '\n Monthly - Rs 229/- \n Half yearly - Rs 1099/- \n Yearly - Rs 2299/-\n\n',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Gold',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '\n Monthly - Rs 139/- \n Half yearly - Rs 699/- \n Yearly - Rs 1499/-\n\n',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Silver',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '\n Monthly - Rs 89/- \n Half yearly - Rs 449/- \n Yearly - Rs 999/-\n',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            TextSpan(
                              text: '\n\n',
                            ),
                            TextSpan(
                              text:
                                  '*--- Activation (in case payment is made to the above UPI handle) of respective plan would be made within 4 hours if the payment is confirmed between 8 am and 8 pm (at other times, the activation would be made within 12 hours). For this confirmation send the following details in a mail to ',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  'haeloapp@gmail.com', // Email address in bold
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: ':\n\n',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '1. Name (as in profile section of the app):\n'
                                  '2. Firm id (as in profile section of the app):\n'
                                  '3. Mobile no (as in profile section of the app):\n'
                                  '4. Transaction id (screenshot of your payment confirmation):',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _launchEmail();
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.primary),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text("Send us mail",
                          style: appTextStyle(
                            textColor: AppColor.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                )
                /*     Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: AppButton(
                    btnName: "Send us mail",
                    voidCallback: () {
                      _launchEmail();
                    },
                  ),
                ))*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchEmail() async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'haeloapp@gmail.com',
      queryParameters: {
        'subject': 'Your Subject Here',
        'body': 'Your body here'
      },
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      // Fallback to a default email app if the device doesn't have an email app installed
      await launch(
          'mailto:haeloapp@gmail.com?subject=Your Subject Here&body=Your body here');
    }
  }
}
