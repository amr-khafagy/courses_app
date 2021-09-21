import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:course_app/constant/constant_widget.dart';
import 'package:course_app/constant/tools.dart';
import 'package:course_app/pages/Home_Page.dart';
import 'package:course_app/sign/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Validation validation=Validation();
  var email, password;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  signIn() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("No user found for that email"))
            ..show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Wrong password provided for that user"))
            ..show();
        }
      }
    } else {
      print("Not Vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
              key: formstate,
              child: Column(children: [
                Text(
                  "Sign UP",
                  style: TextStyle(
                      color: Color(0xFF0D1333),
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Textfield(
                  validator: ( val) {
                    return validation.emailvalidation(val);
                  },
                  saved: (val) {
                    email = val;
                  },
                  hintname: "email",
                  obscure: false,
                  suffixicon: Icon(Icons.alternate_email),
                ),
                Textfield(
                  validator: ( val) {
                    return validation.passwordvalidation(val);
                  },
                  saved: (val) {
                    password = val;
                  },
                  hintname: "Password",
                  suffixicon: Icon(Icons.lock),
                  obscure: true,
                ),
                SizedBox(
                  height: 20,
                ),
                Button(
                  text: "Login",
                  onpressed: () async {
                    var user = await signIn();
                    if (user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ));
                    }
                  },
                  backgroundcolor: Color(0xff6e8af9),
                  edgeInsets:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 150),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "If you have account you can",
                        style: TextStyle(fontSize: 19),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Sign(),
                              ));
                        },
                      )
                    ],
                  ),
                )
              ]),
            )))));
  }
}
