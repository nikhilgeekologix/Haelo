import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/task/cubit/task_caseno_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/task_caseno_state.dart';

import '../../../drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/features/task/data/model/task_caseno_model.dart';

class TaskCaseList extends StatefulWidget {
  final selectedCaseCallback;
  const TaskCaseList(this.selectedCaseCallback,{super.key});

  @override
  State<TaskCaseList> createState() => _TaskCaseListState();
}

class _TaskCaseListState extends State<TaskCaseList> {
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<Data>?  caseList = [];
  List<Data>?  searchList = [];
  bool isSearch=false;

  @override
  void initState() {
    BlocProvider.of<TaskCaseNoCubit>(context).fetchTaskCaseNo();
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
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(20),

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocConsumer<TaskCaseNoCubit, TaskCaseNoState>(
                    builder: (context, state) {
                      return const SizedBox();
                    }, listener: (context, state) {
                  if (state is TaskCaseNoLoaded) {
                    var model = state.taskCaseNoModel;
                    if (model.result == 1 && model.data != null) {
                      caseList = model.data;
                      setState(() {
                      });
                    }
                    else{
                      caseList = model.data;
                      setState(() {
                      });
                    }
                  }else{
                    caseList =[];
                    setState(() {
                    });
                  }
                }),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            // width: mediaQW(context) * 0.62,
                            child: TextFormField(
                              expands: false,
                              autofocus: true,
                              cursorColor: Colors.black,
                              controller: search_textController,
                              focusNode: _focusNode,
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
                              style: mpHeadLine14(textColor: AppColor.black),
                              decoration: InputDecoration(
                                hintText: "Search",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                border: boarder,
                                focusedBorder: focusboarder,
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
                        ],
                      ),
                      SizedBox(height: 10,),
                      searchList!.isEmpty && !isSearch?
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: ListView.builder(
                          itemCount: caseList!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                widget.selectedCaseCallback(caseList![index].validCaseno!=null ?
                                caseList![index].validCaseno.toString():
                                caseList![index].caseNo.toString(),caseList![index].caseId.toString());
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      caseList![index].validCaseno!=null ?
                                      caseList![index].validCaseno.toString():
                                      caseList![index].caseNo.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  index!=caseList!.length-1?
                                  Divider(
                                    color: Colors.grey[300],
                                    thickness: 1.5,
                                  ):SizedBox()
                                ],
                              ),
                            );
                          },
                        ),
                      ): searchList!=null && searchList!.isNotEmpty?
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child:  ListView.builder(
                          itemCount: searchList!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                widget.selectedCaseCallback(searchList![index].validCaseno!=null ?
                                searchList![index].validCaseno.toString():
                                searchList![index].caseNo.toString(),searchList![index].caseId.toString());
                                // _caseNoController.text =
                                // caseNoData[index].validCaseno!=null ?
                                // caseNoData[index].validCaseno.toString():
                                // caseNoData[index].caseNo.toString();
                                // caseIdBox = caseNoData[index].caseNo.toString();
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      searchList![index].validCaseno!=null ?
                                      searchList![index].validCaseno.toString():
                                      searchList![index].caseNo.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  index!=searchList!.length-1?
                                  Divider(
                                    color: Colors.grey[300],
                                    thickness: 1.5,
                                  ):SizedBox()
                                ],
                              ),
                            );
                          },
                        ),
                      ):
                      Column(
                        children: [
                          SizedBox(height: 50,),
                          NoDataAvailable(
                              "Search data not found.",isTopmMargin: false),
                          SizedBox(height: 50,),
                        ],
                      ),
                      SizedBox(height: 5,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void searchFilterList(String searchKey) {
    searchList = [];

    for (var item in caseList!) {
      if (
      item.caseNo!.toString().toLowerCase().contains(searchKey) ||
          (item.validCaseno!=null && item.validCaseno!.toString().toLowerCase().contains(searchKey))
      ) {
        if (!searchList!.contains(item)) {
          searchList!.add(item);
        }
      }
    }
    isSearch=true;
    //searchAdminUsers = filterProductArray;
    setState(() {});
  }

}
