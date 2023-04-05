import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double defaultPadding = 16.0;

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  SizedBox customButton(
      BuildContext context, String text, Color bgColor, double fontSize,
      {Color? textColor,
      FontWeight? fontWeight,
      double? width,
      Alignment? align,
      OutlinedBorder? shape}) {
    return SizedBox(
        height: 65,
        width: width ?? 65,
        child: ElevatedButton(
          onPressed: () {
            context.read<CalculatorFunctions>().change(text);
          },
          child: Align(
            alignment: align ?? Alignment.center,
            child: Text(
              text,
              textScaleFactor: fontSize,
              style: TextStyle(
                  color: textColor ?? Colors.white60,
                  fontWeight: fontWeight ?? FontWeight.w700),
            ),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              shape: shape ?? CircleBorder(),
              elevation: 0,
              shadowColor: null),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => context.read<ThemeChange>().setTheme(),
                icon: Icon(context.watch<ThemeChange>()._icon
                    ? Icons.sunny
                    : Icons.dark_mode)),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 39, 8),
                child: Text(
                  context.watch<CalculatorFunctions>()._result,
                  style: TextStyle(
                      color: context.watch<ThemeChange>()._icon
                          ? Colors.white
                          : Colors.black,
                      fontSize: 85,
                      fontWeight: FontWeight.w200),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customButton(context, "AC", Colors.grey, 1.80,
                  textColor: Colors.black, fontWeight: FontWeight.w500),
              customButton(context, "+/-", Colors.grey.shade500, 1.80,
                  textColor: Colors.black, fontWeight: FontWeight.w500),
              customButton(context, "%", Colors.grey.shade500, 1.80,
                  textColor: Colors.black, fontWeight: FontWeight.w500),
              customButton(context, "÷", Colors.orange, 1.80)
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customButton(context, "7", Colors.grey.shade800, 1.80),
              customButton(context, "8", Colors.grey.shade800, 1.80),
              customButton(context, "9", Colors.grey.shade800, 1.80),
              customButton(context, "x", Colors.orange, 1.80)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            customButton(context, '4', Colors.grey.shade800, 1.80),
            customButton(context, '5', Colors.grey.shade800, 1.80),
            customButton(context, '6', Colors.grey.shade800, 1.80),
            customButton(context, '-', Colors.orange, 1.80),
          ]),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            customButton(context, '1', Colors.grey.shade800, 1.80),
            customButton(context, '2', Colors.grey.shade800, 1.80),
            customButton(context, '3', Colors.grey.shade800, 1.80),
            customButton(context, '+', Colors.orange, 1.80),
          ]),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customButton(context, '0', Colors.grey.shade800, 1.80,
                  width: 160,
                  align: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40))),
              customButton(context, '.', Colors.grey.shade800, 1.80),
              customButton(context, '=', Colors.orange, 1.80),
            ],
          ),
          SizedBox(height: defaultPadding*2),
        ],
      )),
    );
  }
}

class ThemeChange with ChangeNotifier {
  bool _icon = false;

  bool get icon => _icon;

  void setTheme() {
    _icon = !_icon;
    notifyListeners();
  }
}

class CalculatorFunctions with ChangeNotifier {
  String _result = "0";
  double _doubleResult = 0;
  int tempIndex=-1;
  String lastNumber="";

  String get result => _result;

  void change(String val) {
    switch (val) {
      case 'AC':
        _result = "0";
        break;
      case '%':
        if(!_result.contains(RegExp(r'[+÷x]')) && (_result.lastIndexOf("-")==-1 || _result.lastIndexOf("-")==0)  && _result[_result.length-1]!="."){
          _doubleResult = double.parse(_result) / 100;
          _result = _doubleResult.toString();
        }
        break;
      case '+/-':
        tempIndex=_result.lastIndexOf(RegExp(r'[+\-÷x]'));

        if(tempIndex==-1){
          lastNumber=result;
        }
        else if(tempIndex==_result.length-1 || _result[_result.length-1]=="."){
          break;
        }
        else if(tempIndex==0 && _result[tempIndex]=="-"){
          _result=_result.replaceFirst("-", "");
          break;
        }
        else if(_result[tempIndex]=="-" && (_result[tempIndex-1]=="x" || _result[tempIndex-1]=="÷")){
          _result="${_result.substring(0,tempIndex)}${_result.substring(tempIndex+1, _result.length)}";
          break;
        }
        else if(_result[tempIndex]=="-"){
          _result="${_result.substring(0,tempIndex)}+${_result.substring(tempIndex+1, _result.length)}";
          break;
        }
        else if(_result[tempIndex]=="+"){
          _result="${_result.substring(0,tempIndex)}-${_result.substring(tempIndex+1, _result.length)}";
          break;
        }
        else{
          lastNumber=_result.substring(tempIndex+1);
        }

        if(lastNumber=="0"){
          break;
        }
        else if(lastNumber[0]=="-"){
          lastNumber=lastNumber.replaceFirst("-", "");
        }
        else{
          lastNumber="-$lastNumber";
        }

        if(tempIndex==-1){
          _result=lastNumber;
        }
        else{
          _result=_result.substring(0,tempIndex+1)+lastNumber;
        }
        break;
      case '.':
        tempIndex=_result.lastIndexOf(RegExp(r'[+\-÷x]'));
        if((tempIndex==-1 || tempIndex==0) && !_result.contains(".")){
          _result='$_result.';
          break;
        }

        lastNumber=_result.substring(tempIndex+1);
        if(!lastNumber.contains('.')){
          _result='$_result.';
        }
        break;
      case '+':
        if(_result.lastIndexOf(RegExp(r'[.+\-÷x]'))!=_result.length-1){
          _result="$_result+";
        }
        break;
      case '-':
        if(_result.lastIndexOf(RegExp(r'[.+\-÷x]'))!=_result.length-1){
          _result="$_result-";
        }
        break;
      case 'x':
        if(_result.lastIndexOf(RegExp(r'[.+\-÷x]'))!=_result.length-1){
          _result="${_result}x";
        }
        break;
      case '÷':
        if(_result.lastIndexOf(RegExp(r'[.+\-÷x]'))!=_result.length-1){
          _result="$_result÷";
        }
        break;
      case '=':
        if(_result.lastIndexOf(RegExp(r'[.+\-÷x]'))!=_result.length-1){
          _calculation();
        }
        break;
      default:
        if(_result=="0"){
          _result=val;
        }
        else{
          _result=_result+val;
        }
    }
    notifyListeners();
  }

  void _calculation() {
    String firstVal="";
    String secondVal="";
    double doubleFirstVal=0;
    double doubleSecondVal=0;
    int operatorIndex=0;
    int startIndex=0;
    int endIndex=0;
    double doubleCalculatedVal=0;
    String calculatedVal="";
    while(_result.contains('÷')){
      operatorIndex=_result.indexOf("÷");
      firstVal=_result.substring(0,operatorIndex);
      secondVal=_result.substring(operatorIndex+1, _result.length);
      startIndex=firstVal.lastIndexOf(RegExp(r'[+\-÷x]'));

      if(startIndex==-1){
        doubleFirstVal=double.parse(firstVal);
      }
      else if(startIndex==0){
        startIndex--;
        doubleFirstVal=double.parse(firstVal);
      }
      else if((firstVal[startIndex]=="-" && firstVal[startIndex-1]=="x")||(firstVal[startIndex]=="-" && firstVal[startIndex-1]=="÷")){
        startIndex--;
        doubleFirstVal=double.parse(firstVal.substring(startIndex+1));
      }
      else{
        doubleFirstVal=double.parse(firstVal.substring(startIndex+1));
      }

      endIndex=secondVal.indexOf(RegExp(r'[+\-÷x]'));
      if(endIndex==-1){
        endIndex=_result.length;
        doubleSecondVal=double.parse(secondVal);
      }
      else if(endIndex==0){
        secondVal=secondVal.replaceFirst("-", "");
        endIndex=secondVal.indexOf(RegExp(r'[+\-÷x]'));
        if(endIndex==-1){
          endIndex=_result.length;
          doubleSecondVal=double.parse(secondVal)*-1;
        }
        else{
          endIndex=endIndex+firstVal.length+2;
          doubleSecondVal=double.parse(_result.substring(operatorIndex+1, endIndex));
        }
      }
      else{
        endIndex=endIndex+firstVal.length+1;
        doubleSecondVal=double.parse(_result.substring(operatorIndex+1, endIndex));
      }

      doubleCalculatedVal=doubleFirstVal/doubleSecondVal;
      calculatedVal=doubleCalculatedVal.toString();
      _result=_result.substring(0,startIndex+1)+calculatedVal+_result.substring(endIndex, _result.length);

      tempIndex=_result.indexOf("--");
      if(tempIndex!=-1){
        _result="${_result.substring(0,tempIndex)}+${result.substring(tempIndex+2)}";
      }
      tempIndex=_result.indexOf("+-");
      if(tempIndex!=-1){
        _result="${_result.substring(0,tempIndex)}-${result.substring(tempIndex+2)}";
      }
    }
    while(_result.contains('x')){
      operatorIndex=_result.indexOf("x");
      firstVal=_result.substring(0,operatorIndex);
      secondVal=_result.substring(operatorIndex+1, _result.length);
      startIndex=firstVal.lastIndexOf(RegExp(r'[+\-x]'));

      if(startIndex==-1){
        doubleFirstVal=double.parse(firstVal);
      }
      else if(startIndex==0){
        startIndex--;
        doubleFirstVal=double.parse(firstVal);
      }
      else if(firstVal[startIndex]=="-" && firstVal[startIndex-1]=="x"){
        startIndex--;
        doubleFirstVal=double.parse(firstVal.substring(startIndex+1));
      }
      else{
        doubleFirstVal=double.parse(firstVal.substring(startIndex+1));
      }

      endIndex=secondVal.indexOf(RegExp(r'[+\-x]'));
      if(endIndex==-1){
        endIndex=_result.length;
        doubleSecondVal=double.parse(secondVal);
      }
      else if(endIndex==0){
        secondVal=secondVal.replaceFirst("-", "");
        endIndex=secondVal.indexOf(RegExp(r'[+\-÷x]'));
        if(endIndex==-1){
          endIndex=_result.length;
          doubleSecondVal=double.parse(secondVal)*-1;
        }
        else{
          endIndex=endIndex+firstVal.length+2;
          doubleSecondVal=double.parse(_result.substring(operatorIndex+1, endIndex));
        }
      }
      else{
        endIndex=endIndex+firstVal.length+1;
        doubleSecondVal=double.parse(_result.substring(operatorIndex+1, endIndex));
      }

      doubleCalculatedVal=doubleFirstVal*doubleSecondVal;
      calculatedVal=doubleCalculatedVal.toString();
      _result=_result.substring(0,startIndex+1)+calculatedVal+_result.substring(endIndex, _result.length);

      tempIndex=_result.indexOf("--");
      if(tempIndex!=-1){
        _result="${_result.substring(0,tempIndex)}+${result.substring(tempIndex+2)}";
      }
      tempIndex=_result.indexOf("+-");
      if(tempIndex!=-1){
        _result="${_result.substring(0,tempIndex)}-${result.substring(tempIndex+2)}";
      }
    }

    while(_result.contains('+') || (_result.lastIndexOf('-')!=-1 && _result.lastIndexOf('-')!=0)){
      operatorIndex=_result.lastIndexOf(RegExp(r'[+\-]'));
      String operator=_result[operatorIndex];
      firstVal=_result.substring(0,operatorIndex);
      secondVal=_result.substring(operatorIndex+1, _result.length);
      startIndex=firstVal.lastIndexOf(RegExp(r'[+\-]'));

      if(startIndex==-1){
        doubleFirstVal=double.parse(firstVal);
      }
      else if(startIndex==0){
        startIndex--;
        doubleFirstVal=double.parse(firstVal);
      }
      else{
        doubleFirstVal=double.parse(firstVal.substring(startIndex+1));
      }

      endIndex=secondVal.indexOf(RegExp(r'[+\-]'));
      if(endIndex==-1){
        endIndex=_result.length;
        doubleSecondVal=double.parse(secondVal);
      }
      else if(endIndex==0){
        secondVal=secondVal.replaceFirst("-", "");
        endIndex=secondVal.indexOf(RegExp(r'[+\-]'));
        if(endIndex==-1){
          endIndex=_result.length;
          doubleSecondVal=double.parse(secondVal)*-1;
        }
        else{
          endIndex=endIndex+firstVal.length+2;
          doubleSecondVal=double.parse(_result.substring(operatorIndex+1, endIndex));
        }
      }
      else{
        endIndex=endIndex+firstVal.length+1;
        doubleSecondVal=double.parse(_result.substring(operatorIndex+1, endIndex));
      }

      if(operator=='+'){
        doubleCalculatedVal=doubleFirstVal+doubleSecondVal;
      }
      else{
        doubleCalculatedVal=doubleFirstVal-doubleSecondVal;
      }
      calculatedVal=doubleCalculatedVal.toString();
      _result=_result.substring(0,startIndex+1)+calculatedVal+_result.substring(endIndex, _result.length);

      tempIndex=_result.indexOf("--");
      if(tempIndex!=-1){
        _result="${_result.substring(0,tempIndex)}+${result.substring(tempIndex+2)}";
      }
      tempIndex=_result.indexOf("+-");
      if(tempIndex!=-1){
        _result="${_result.substring(0,tempIndex)}-${result.substring(tempIndex+2)}";
      }
    }
  }
}
