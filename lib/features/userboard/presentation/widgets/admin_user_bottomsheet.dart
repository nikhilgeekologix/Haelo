import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/ui_helper.dart';
import '../../data/model/admin_user_model.dart';

class AdminUserBottomSheet extends StatefulWidget {
  List<AdminUsers>? adminUsers = [];
  final firmIdCallback;
  AdminUserBottomSheet({this.adminUsers, this.firmIdCallback}) : super();

  @override
  _RateUsState createState() => _RateUsState();
}

class _RateUsState extends State<AdminUserBottomSheet> {
  List<AdminUsers>? adminUsers = [];
  List<AdminUsers>? searchAdminUsers = [];
  int selectedIndex = 4;

  // int selectedAnswerId = -1;

  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool isLoading = true;
  bool isSearch = false;

  @override
  void initState() {
    adminUsers = widget.adminUsers!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: EdgeInsets.only(
              top: 25,
              bottom: 10,
            ),
            // margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 25, top: 5, bottom: 15),
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 14,
                        color: AppColor.text_grey_color,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 4, top: 5, bottom: 15),
                          child: Text(
                            "Back",
                            style: mpHeadLine20(textColor: AppColor.text_grey_color, fontWeight: FontWeight.w300),
                          )),
                    ),
                  ],
                ),
                Container(
                  // padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0XFF7C7979)),
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          controller: search_textController,
                          focusNode: _focusNode,
                          onChanged: (value) {
                            if(value.isNotEmpty) {
                              searchFilterList(value.toLowerCase());
                            }else{
                              setState(() {
                                isSearch=false;
                                searchAdminUsers=[];
                              });
                            }
                          },
                          style: mpHeadLine14(textColor: AppColor.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(fontSize: 18),
                              alignLabelWithHint: true),
                        ),
                      ),
                      search_textController.text.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                search_textController.clear();
                                if (searchAdminUsers!.isNotEmpty) {
                                  searchAdminUsers!.clear();
                                }
                                isSearch=false;
                                setState(() {});
                              },
                              child: Icon(Icons.close_outlined))
                          : SizedBox(),
                      SizedBox(
                        width: search_textController.text.isNotEmpty ? 5 : 0,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: searchAdminUsers!.isEmpty && !isSearch
                      ? ListView.builder(
                          itemCount: adminUsers!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var firmTitle = "";
                            if (adminUsers![index].firmName != null && adminUsers![index].firmName!.isNotEmpty) {
                              firmTitle = "${adminUsers![index].firmId} (${adminUsers![index].firmName.toString()})";
                            } else {
                              firmTitle = adminUsers![index].firmId!.toString();
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                widget.firmIdCallback(adminUsers![index].firmId!.toString());
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(bottom: 3),
                                child: Column(
                                  children: [
                                    Text("$firmTitle",
                                        style: mpHeadLine18(textColor: AppColor.black, fontFamily: "gilroy_medium")),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                        child: Divider(
                                          height: 1,
                                          color: Color(0XFFE1DFDF),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          })
                      : searchAdminUsers!.isNotEmpty?
                  ListView.builder(
                          itemCount: searchAdminUsers!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, SIndex) {
                            var firmTitle = "";
                            if (searchAdminUsers![SIndex].firmName != null &&
                                searchAdminUsers![SIndex].firmName!.isNotEmpty) {
                              firmTitle =
                                  "${searchAdminUsers![SIndex].firmId} (${searchAdminUsers![SIndex].firmName.toString()})";
                            } else {
                              firmTitle = searchAdminUsers![SIndex].firmId!.toString();
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                widget.firmIdCallback(searchAdminUsers![SIndex].firmId!.toString());
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(bottom: 3),
                                child: Column(
                                  children: [
                                    Text("$firmTitle",
                                        style: mpHeadLine14(textColor: AppColor.black, fontFamily: "gilroy_medium")),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                        child: Divider(
                                          height: 1,
                                          color: Color(0XFFE1DFDF),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }): Column(
                            children: [
                              SizedBox(height: 50,),
                              NoDataAvailable(
                      "Search data not found.",isTopmMargin: false),
                            ],
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void searchFilterList(String searchKey) {
    searchAdminUsers = [];
    var filterProductArray = <AdminUsers>[];
    List<AdminUsers> data = adminUsers!;

    for (var item in data) {
      if (item.firmId!=null && item.firmId!.toLowerCase().contains(searchKey)
          || (item.mobileNo!=null && item.mobileNo!.toLowerCase().contains(searchKey))
          || (item.firmName!=null && item.firmName!.toLowerCase().contains(searchKey))
      ) {
        if (!filterProductArray.contains(item)) {
          filterProductArray.add(item);
        }
      }
    }
    isSearch=true;
    searchAdminUsers = filterProductArray;
    setState(() {});
  }
}
