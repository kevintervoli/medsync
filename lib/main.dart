import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:medsync/forgot_password.dart';
import 'package:medsync/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // login function
  static Future<User?> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

    } on FirebaseAuthException catch (e){
      if(e.code == "user-not-found"){
        print("No user found for that email!");
      }
    }
    return user;
  }
  @override
  Widget build(BuildContext context) {
    // create the textfield controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text("MedSync",
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 28.0,
          //       fontWeight: FontWeight.bold,
          //     )),
          // const Text("Login to Your App",
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 48,
          //       fontWeight: FontWeight.bold,
          //     )),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'assets/medicine.png',
                width: 100, // Adjust the width of the image
                height: 100, // Adjust the height of the image
                alignment:
                    Alignment.center, // Centers the image within its container
              ),
            ),
          ),
          const SizedBox(height: 44.0),
           TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "User Email",
                prefixIcon: Icon(Icons.mail, color: Colors.black)),
          ),
          const SizedBox(
            height: 26.0,
          ),
           TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "User Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black)),
          ),
          const SizedBox(height: 12.0),
          // const Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
         GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
            );
          },
          child : const Text("Forgot Password?", style: TextStyle(color: Colors.blue))
         ), 
          const SizedBox(height: 88.0),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor:const  Color(0xFF0069FE),
              elevation: 0.0,
              padding:const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);
                print(user);
                if(user !=null){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Profile()));
                }
              },
              child: const Text('Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initialize firebase app
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
