import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mealtime/models/constants.dart';

class SearchBar extends StatefulWidget {
  SearchBar({super.key, required this.controller});
  TextEditingController controller;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return TextField(
      style: GoogleFonts.inter(color: blackColor),
      decoration: InputDecoration(
        prefixIcon: Icon(
          FluentIcons.food_16_filled,
          color: fullGreyColor,
          size: 25,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87, width: 1),
          borderRadius: BorderRadius.circular(20.0),
        ),
        fillColor: Colors.transparent,
        filled: true,
        focusColor: Colors.black,
        hintText: "Enter ingredient",
        hintStyle: GoogleFonts.inter(color: fullGreyColor),
        contentPadding: const EdgeInsets.only(
          left: 15,
          bottom: 20,
          top: 20,
          right: 15,
        ),
      ),
      controller: widget.controller,
      keyboardType: TextInputType.text,
      // onSubmitted: (_) => submitData(),
      // onChanged: ((value) {
      //   amountInput = value;
      // }),
    );
  }
}
