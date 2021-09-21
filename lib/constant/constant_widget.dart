
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  final EdgeInsets edgeInsets;
  final Color backgroundcolor;

  const Button({
    Key key,
    this.text,
    this.onpressed,
    this.edgeInsets,
    this.backgroundcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          onPressed: onpressed,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          color: backgroundcolor,
          padding: edgeInsets,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none),
        ),
      ],
    );
  }
}

class Textfield extends StatelessWidget {
  final bool obscure;
  final String hintname;
  final Icon suffixicon;
final FormFieldValidator validator;
final String label;
final saved;
  const Textfield({
    Key key,
    this.hintname,
    this.suffixicon, this.validator, this.saved, this.label, this.obscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xFFF5F5F7), borderRadius: BorderRadius.circular(40)),
      child: TextFormField(
        validator: validator,
        onSaved: saved,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText:label ,
            labelStyle: TextStyle(fontSize:25,fontWeight: FontWeight.w500,color: Color(0xffa0a5bd)),
            prefixIcon: suffixicon,
            prefixStyle: TextStyle(color: Color(0xffa0a5bd)),
            hintText: hintname,
            hintStyle: TextStyle(
              fontSize: 24,
              color: Color(0xFFA0A5BD),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}
showLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please Wait"),
          content: Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              )),
        );
      });
}

class Profilefield extends StatelessWidget {
  final hittext;
  const Profilefield({
    Key key, this.hittext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:25),
      child: TextField(
        decoration: InputDecoration(
          hintText:
          hittext,
          hintStyle: TextStyle(
              color:  Color(0xff6e8af9),
              fontSize: 20,
              textBaseline: TextBaseline.ideographic,
              fontWeight: FontWeight.bold),
          disabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color:  Color(0xff6e8af9)),
              borderRadius: BorderRadius.circular(50)),
          enabled: false,
        ),
      ),
    );
  }
}
