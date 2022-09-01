import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_firebase/signup.dart';

import 'Home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState>_key=GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black38,
          height: size.height,
          width: size.width,
          child: Form(
            key: _key,
            child: Column(

              children: [
               const  SizedBox(height: 40,),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child:Text('Login',style: TextStyle(fontStyle: FontStyle.italic,fontWeight:FontWeight.bold,fontSize: 60),)
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    validator: (value){
                      if(value==null||value.isEmpty)return "Field is Required";
                      String pattern=r'\w+@\w+\.\w+';
                      if(!RegExp(pattern).hasMatch(value))
                        return 'Invalid E-mail Address format.';

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: email,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    validator: (value){
                      if(value==null||value.isEmpty)return "Field is Required";
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: password,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                     MaterialButton(
                            color: Colors.pink,
                            child: const Text('Sign In',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () async{
                              if(_key.currentState!.validate()){
                                _key.currentState!.save();
                                try {
                                  final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email:email.text,
                                      password: password.text
                                  );
                                  if (user!= null) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>Home()));
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    Fluttertoast.showToast(
                                        msg: "No user Found for that email",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );

                                  } else if (e.code == 'wrong-password') {
                                    Fluttertoast.showToast(
                                        msg: "Wrong password provided for that user.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );

                                  }
                                }


                              }}

                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: MaterialButton(
                          color: Colors.purple,
                          onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>const Signup()));
                          },
                          child:const Text('SignUp',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
