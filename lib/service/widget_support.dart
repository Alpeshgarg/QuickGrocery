import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle HeadlineTextfeildStyle(double textsize){
    return TextStyle(
      fontSize: textsize,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle NormalTextfeildStyle(double textsize){
    return TextStyle(
      fontSize: textsize,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }

  static TextStyle SimpleTextfeildStyle(){
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black38,
    );
  }
  static TextStyle SlowSimpleTextfeildStyle(){
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black38,
    );
  }

  static TextStyle WhiteTextfeildStyle(double textsize) {
    return TextStyle(
      color: Colors.white,
      fontSize: textsize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle SmallWhiteTextfeildStyle(){
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

    static TextStyle DiffWhiteTextfeildStyle(){
    return const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Colors.white54,
    );
  }
  
}

