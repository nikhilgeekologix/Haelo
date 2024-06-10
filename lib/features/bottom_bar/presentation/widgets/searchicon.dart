import 'package:flutter/material.dart';

class SearchFunc extends StatefulWidget {
  const SearchFunc({Key? key}) : super(key: key);

  @override
  State<SearchFunc> createState() => _SearchFuncState();
}

class _SearchFuncState extends State<SearchFunc> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Search...');

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: customIcon,
      onPressed: () {
        setState(() {
          if (customIcon.icon == Icons.search) {
            customIcon = const Icon(Icons.cancel);
            customSearchBar = const ListTile(
              leading: Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 50,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            );
          }
        });
      },
    );
  }
}
