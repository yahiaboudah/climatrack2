
import 'package:flutter/material.dart';
import 'package:climatrack2/screens/login.dart';
import 'package:climatrack2/screens/signup.dart';
import 'package:climatrack2/screens/home.dart';
import 'package:climatrack2/screens/homeAdmin.dart';

import 'package:firebase_core/firebase_core.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        "/login": (context) => const LoginPage(),
        "/signup": (context) => SignupPage(),
        '/home': (context) => const Home(),
        '/homeAdmin': (context) => const HomeAdmin(),
      }
    )
  );
}



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text("Welcome", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  ),
                  ),
                  const SizedBox(height: 20,),
                  Text("Register to start monitoring rooms using ClimaTrack", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15
                  ),),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo1.png')
                  )
                ),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black
                      ),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Text("Login", style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 18
                    ),),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: const Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Text("Sign up", style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 18
                      ),),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
