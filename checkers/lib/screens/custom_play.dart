
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPlay extends StatelessWidget {
  final String message;
  const CustomPlay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {

    Object result;

    if (message == "NOT FOUND") {
      result = "The checkerboard could not be recognized";
    }
    else {
      result = processResponse(message);

    }

    return Scaffold(
      body: Center(
        child: Text(
          '{$result}',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }


  List<List<String>> processResponse(String response) {

    List<String> charList = response.split('');

    // Create an empty 8x8 matrix
    List<List<String>> matrix = List.generate(8, (_) => List.filled(8, ''));

    // Fill the matrix with characters from the list
    for (int i = 0; i < charList.length; i++) {
      int row = i ~/ 8;
      int col = i % 8;
      matrix[row][col] = charList[i];
    }

    // Print the resulting matrix
    print(matrix);

    return matrix;
  }

}