import 'package:flutter/material.dart';

class CustomMethods{

 static customButton({required VoidCallback onPressed, required String buttonText}) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.teal.shade100,
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }

  static customTextField(
      {required String labelText,
      required TextEditingController textEditingController}) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        color: Color.fromARGB(89, 178, 212, 223),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none, // Remove the default border
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
      ),
    );
  }

}