import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(
      MaterialApp(
        title: "Jogo da cobrinha",
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: HomePage()),
      )
  );
}

