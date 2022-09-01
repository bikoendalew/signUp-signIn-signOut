import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_firebase/Home.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Reg()
    );
  }
}
class Reg extends StatefulWidget {
  const Reg({Key? key}) : super(key: key);

  @override
  State<Reg> createState() => _RegState();
}

class _RegState extends State<Reg> {
  final GlobalKey<FormState>_key=GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Sign Up Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color:Colors.brown,
        height: size.height,
          width: size.width,
          child: Form(
            key: _key,
            child: Column(

              children: [
                const  SizedBox(height: 40,),
                const Padding(
                    padding: EdgeInsets.all(30.0),
                    child:Text('Sign Up',style: TextStyle(fontStyle: FontStyle.italic,fontWeight:FontWeight.bold,fontSize: 60),)
                ),
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
                        child: MaterialButton(
                          color: Colors.purple,
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              _key.currentState!.save();

                              try {
                                final Newuser = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                Fluttertoast.showToast(
                                    msg: "Register Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                if (Newuser != null) {
                                  Navigator.push
                                    (context, MaterialPageRoute(
                                      builder: (context) => Home()));
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  Fluttertoast.showToast(
                                      msg: "The password provided is too weak",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                } else if (e.code == 'email-already-in-use') {
                                  Fluttertoast.showToast(
                                      msg: "The account already exists for that email.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
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

        ),
      ),
    );
  }
}

