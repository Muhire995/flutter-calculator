import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String displayText = '0';
  String expression = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        displayText = '0';
        expression = '';
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          displayText = eval.toString();
        } catch (e) {
          displayText = 'Error';
        }
      } else {
        if (displayText == '0' && buttonText != '.') {
          displayText = buttonText;
        } else {
          displayText += buttonText;
        }
        expression += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              displayText,
              style: TextStyle(fontSize: 36, color: Colors.white),
            ),
          ),
          Divider(color: Colors.white),
          _buildButtonRow('7', '8', '9', '/'),
          _buildButtonRow('4', '5', '6', '*'),
          _buildButtonRow('1', '2', '3', '-'),
          _buildButtonRow('.', '0', '=', '+'),
          _buildButtonRow('C'), // Remove 'AC' from here
        ],
      ),
    );
  }

  Widget _buildButtonRow(String first, [String second = '', String third = '', String fourth = '']) {
    List<String> buttons = [first];
    if (second.isNotEmpty) buttons.add(second);
    if (third.isNotEmpty) buttons.add(third);
    if (fourth.isNotEmpty) buttons.add(fourth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((buttonText) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.all(4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(buttonText),
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _buttonPressed(buttonText),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getButtonColor(String buttonText) {
    if (buttonText == 'C') {
      return Colors.redAccent;
    } else if (buttonText == '=') {
      return Colors.orangeAccent;
    } else {
      return Colors.grey[850]!;
    }
  }
}
