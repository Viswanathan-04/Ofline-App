import 'package:flutter/material.dart';

import '../../../Constants/color.dart';


class MySearchBar extends StatefulWidget {
  final String hintext;

  const MySearchBar({
    super.key,

    required this.hintext

  });


  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  bool showSearchField = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: showSearchField ? Colors.grey.withOpacity(0.07) : kWhite,
          borderRadius: BorderRadius.circular(showSearchField ? 19 : 360)),
      child: showSearchField ? searchField() : searchButton(),
    );
  }

  Widget searchField() {
    return Container(
        child: TextField(
      cursorHeight: 25,
      style: const TextStyle(fontWeight: FontWeight.w500, color: kGrey),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      cursorColor: kGrey,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        border: InputBorder.none,
        hintText: widget.hintext,
        hintStyle:  TextStyle(
          fontSize: 16,
          color: kGrey.withOpacity(0.37),
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: clearButton(),
      ),
    ));
  }

  Widget searchButton() {
    return IconButton(
      tooltip: '',
      icon: Container(
        child: const Icon(
          Icons.search,
          color: kGrey,
          size: 22,
        ),
      ),
      onPressed: () {
        if (mounted) {
          setState(() {
            showSearchField = true;
          });
        }
      },
    );
  }

  Widget clearButton() {
    return IconButton(
      tooltip: '',
      icon: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(360)),
        child: const Icon(
          Icons.search,
          color: kGrey,
          size: 21,
        ),
      ),
      onPressed: () {
        if (mounted) {
          setState(() {
            showSearchField = false;
          });
        }
      },
    );
  }
}
