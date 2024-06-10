import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class DynamicFields extends StatefulWidget {
  final bool isMobile;
  final mobileEmailController;
  List<TextEditingController> textControllers;
   DynamicFields({Key? key, this.isMobile = false,
     required this.mobileEmailController,
     this.textControllers=const []}) : super(key: key);

  @override
  State<DynamicFields> createState() => _DynamicFieldsState();
}

class _DynamicFieldsState extends State<DynamicFields> {
  List<Widget> list = [];
  int fieldCount = 0;
  List<FocusNode> focusList=[];

  List<Map<String, dynamic>> items = [];

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // List datalist=widget.mobileEmailController.text.toString().split(",");
    // for(int i=1; i<datalist.length;i++){
    //   fieldCount++;
    //   // list.add(buildField(fieldCount));
    //   widget.textControllers.add(TextEditingController(text: datalist[i]));
    // }
    // print("datalist ${datalist}");
    widget.mobileEmailController.text=widget.mobileEmailController.text;
    for(int i =0; i<widget.textControllers.length; i++){
      focusList.add(FocusNode());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.mobileEmailController,
                  inputFormatters: [widget.isMobile?FilteringTextInputFormatter.digitsOnly
                      :FilteringTextInputFormatter.singleLineFormatter,
                    LengthLimitingTextInputFormatter(
                        widget.isMobile?10:50)

                  ],
                  keyboardType: widget.isMobile?TextInputType.number:TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: widget.isMobile == true ? "Mobile No." : "Email",
                      labelStyle: TextStyle(color: Colors.black38),
                      contentPadding: EdgeInsets.only(left: 10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: AppColor.primary),
                      )),
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    fieldCount++;
                    widget.textControllers.add(TextEditingController());
                    focusList.add(FocusNode());
                    FocusScope.of(context).requestFocus(FocusNode());
                   focusList.last.requestFocus();
                    // list.add(buildField(fieldCount));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black38,
                  ),
                ),
              )
            ],
          ),
          ListView.builder(
            itemCount: widget.textControllers.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) => buildField(i),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildField(int i) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: mediaQW(context),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                inputFormatters: [widget.isMobile?FilteringTextInputFormatter.digitsOnly
                    :FilteringTextInputFormatter.singleLineFormatter,
                  LengthLimitingTextInputFormatter(
                      widget.isMobile?10:50)

                ],
                controller: widget.textControllers[i],
                focusNode: focusList[i],
                keyboardType: widget.isMobile?TextInputType.number:TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: AppColor.primary),
                  ),
                  labelText: widget.isMobile == true ? "Mobile No. ${i + 2}" : "Email ${i + 2}",
                ),
                //onChanged: (data) => storeValue(i + 1, data),
                validator: (val) {
                  if(val!.isNotEmpty){
                    if(widget.isMobile == true && val.length<10){
                      return "Please enter correct mobile number";
                    }
                    if(widget.isMobile==false && !isEmailValid(val)){
                      return "Please enter correct email";
                    }
                  }
                },
              autovalidateMode: AutovalidateMode.always,
              autofocus: true,
              // focusNode: focusList[i],
              ),
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.cancel, color: Colors.red),
            ),
            onTap: () {
              setState(() {
                fieldCount--;
                // list.add(buildField(fieldCount));
                widget.textControllers.removeAt(i);
                focusList.removeAt(i);
                // items.removeAt(i);
              });
            },
          ),
        ],
      ),
    );
  }

  dynamic storeValue(int i, String v) {
    bool valueFound = false;

    for (int j = 0; j < items.length; j++) {
      if (items[j].containsKey("field_id")) {
        if (items[j]["field_id"] == i) {
          valueFound = !valueFound;
          break;
        }
      }
    }

    /// If value is found
    if (valueFound) {
      items.removeWhere((e) => e["field_id"] == i);
    }
    items.add({
      "field_id": i,
      "itinerary": v,
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
