import 'package:course_app/pages/Home_Page.dart';
import 'package:course_app/sign/signin.dart';
import 'package:course_app/courses/session_video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
var issign;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user=await FirebaseAuth.instance.currentUser;
if(user==null){
  issign=false;
}else{
  issign=true;
}
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:issign==false?Sign():Home()
    );
  }
}
