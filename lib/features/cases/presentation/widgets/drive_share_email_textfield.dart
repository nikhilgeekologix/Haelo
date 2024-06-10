import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/plans.dart';
import 'package:haelo_flutter/widgets/app_button.dart';

class ShareToEmailWidget extends StatelessWidget {
  final callback;

  ShareToEmailWidget(this.callback, {super.key});

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            // constraints: BoxConstraints(maxHeight: mediaQH(context) * 0.5),
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "To share documents\nPlease enter an Email address",
                          style: mpHeadLine14(
                              textColor: Colors.black,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: TextFormField(
                                controller: emailController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Enter email",
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1.5, color: Colors.black54),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorBorder: errorboarder,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: AppColor.primary),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: boarder,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AppButton(
                              btnName: "Share",
                              voidCallback: () {
                                if (emailController.text.trim().isEmpty) {
                                  toast(msg: "Please enter email");
                                } else if (emailController.text
                                        .trim()
                                        .isNotEmpty &&
                                    !isEmailValid(emailController.text)) {
                                  toast(msg: "Please enter correct email.");
                                  return;
                                }else{
                                  callback(emailController.text.trim());
                                  Navigator.pop(context);
                                }
                              },
                              isLoading: false,
                              cornerRadius: 10,
                              borderColor: AppColor.primary,
                              backgroundColor: AppColor.primary,
                              textColor: AppColor.white,
                              textSize: 14,
                              buttonHeight: 40,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.cancel_outlined,
                          size: 20,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
