import 'dart:io';

import 'package:flutter/material.dart';


class Rules extends StatefulWidget {
  const Rules({super.key});


  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {


  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          _backgroundImage(),
          Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              _headerView()],
          ),
          // _bottomView(context),
        ]));
  }

  Widget _backgroundImage() {
    return Container(
        color: const Color(0xFF2C2623)
    );
  }

  Widget _headerView() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Rules",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "How to play",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }



}
