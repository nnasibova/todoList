import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todolist_firebase/main.dart';
import 'package:todolist_firebase/screens/home_page.dart';
import '../../utils/styles.dart';
import '../../widgets/text_form.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  "assets/images/Teamwork.png",
                ),
              )),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Register",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldContainer(
              text: "Name",
              controller: nameController,
              icon: FontAwesomeIcons.user,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldContainer(
              text: "Email",
              controller: emailController,
              icon: FontAwesomeIcons.user,
             
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldContainer(
              text: "Password",
              controller: passwordController,
              icon: FontAwesomeIcons.key,
             
            ),
            const SizedBox(
              height: 40,
            ),
            Ink(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 13.4,
                decoration: BoxDecoration(
                    color: Styles.appColor,
                    borderRadius: BorderRadius.circular(25)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  child: const Center(
                      child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
                  onTap: () {
                    setState(() {
                      signUp();
                    });
                  },
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Already have an account?",
                    style: TextStyle(color: Colors.grey[500], fontSize: 20)),
                TextButton(
                    onPressed: () {
                      Get.to(LoginScreen());
                    },
                    child: const Text(" Sign in",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)))
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ));
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
