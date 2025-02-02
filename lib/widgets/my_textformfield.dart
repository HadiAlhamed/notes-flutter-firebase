// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  final TextEditingController mycontroller;
  final String hintText;
  final String label;
  final String? Function(String?)? validator;
  final double? fieldHeight;
  final bool? expand;
  final Widget? addImageIcons;
  final File? imageFile;
  final Widget? suffixIconButton;
  final bool? obsecure;
  const MyTextformfield({
    Key? key,
    required this.mycontroller,
    required this.hintText,
    required this.label,
    required this.validator,
    this.fieldHeight,
    this.expand,
    this.addImageIcons,
    this.imageFile,
    this.suffixIconButton,
    this.obsecure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: fieldHeight ?? 60,
          child: TextFormField(
            obscureText: obsecure ?? false,
            maxLines: obsecure == null ? null : 1, // Allows infinite lines
            expands: expand ?? false, // Expands to fill the parent
            // textAlign: TextAlign.center, // Center text horizontally
            textAlignVertical: TextAlignVertical.top, // Align text at the top
            validator: validator,
            controller: mycontroller,

            decoration: InputDecoration(
              suffixIcon: suffixIconButton,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              filled: true,
              fillColor: Colors.grey[200],
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        imageFile == null
            ? const SizedBox()
            : SizedBox(
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.fill,
                ),
              ),
        addImageIcons ?? const SizedBox(),
      ],
    );
  }
}
