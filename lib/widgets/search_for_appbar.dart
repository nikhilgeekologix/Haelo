import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/home_page/presentation/screens/drawers.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Row(
        children: [
          Container(
            width: 280,
            height: 40,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          ),
          const Icon(
            Icons.filter_alt_outlined,
            size: 28,
            color: AppColor.bold_text_color_dark_blue,
          ),
        ],
      )),
      drawer: AppDrawer(),
    );
  }
}
