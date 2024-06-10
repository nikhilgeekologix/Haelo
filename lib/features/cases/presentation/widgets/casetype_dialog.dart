import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';

class CaseTypeDialog extends StatefulWidget {
  final list;
  final listName;
  final callback;

  const CaseTypeDialog(this.list, this.listName, this.callback,
      {Key? key})
      : super(key: key);

  @override
  _CauseListFilterDialogState createState() => _CauseListFilterDialogState();
}

class _CauseListFilterDialogState extends State<CaseTypeDialog> {
  List dataList = [];

  //done by rahul
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List searchList = [];
  bool isSearch = false;

  @override
  void initState() {
    //print("widget lst ${widget.list}");
    dataList = widget.list;
    // dataList.insert(0, "None");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          constraints:
          BoxConstraints(maxHeight: mediaQH(context) * 0.8),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                child: TextFormField(
                  cursorHeight: 25,
                  controller: search_textController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      searchFilterList(value.toLowerCase());
                    } else {
                      setState(() {
                        isSearch = false;
                        searchList = [];
                      });
                    }
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search",
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: boarder,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: search_textController.text.isNotEmpty?
                    IconButton(
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearch = false;
                          search_textController.text="";
                          //isSearchFilter = false;
                          searchList = [];
                        });
                        /* Clear the search field */
                      },
                    ):SizedBox(),
                  ),
                ),
              ),
              searchList.isEmpty && !isSearch
                  ? Flexible(
                child: SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: dataList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            String selectedString=dataList![index].toString();
                              widget.callback(selectedString);
                              Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: AppColor.grey_color,
                                    ))),
                            alignment: Alignment.center,
                            child: Text(
                              dataList[index]
                                  .toString(),
                              textAlign: TextAlign.center,
                            )
                          ),
                        );
                      }),
                ),
              ):searchList.isNotEmpty
                  ? Flexible(
                child: ListView.builder(
                    itemCount: searchList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          String selectedString=searchList![index].toString();
                          widget.callback(selectedString);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: AppColor.grey_color,
                                  ))),
                          alignment: Alignment.center,
                          child:
                          Text(
                            searchList[index]
                                .toString(),
                            textAlign: TextAlign.center,
                          )
                        ),
                      );
                    }),
              ):
              Column( mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30,),
                  NoDataAvailable(
                      "Search data not found.",isTopmMargin: false),
                  SizedBox(height: 30,),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void searchFilterList(String searchKey) {
    searchList = [];
    // var filterProductArray = <AdminUsers>[];

    for (int i = 0; i < dataList.length; i++) {

        if(dataList[i].toString().toLowerCase().contains(searchKey)){
          if (!searchList!.contains(dataList[i])) {
            searchList!.add(dataList[i]);
          }
        }

    }

    // print("searchlist length ${searchList.length}");
    isSearch=true;
    setState(() {});
  }
}
