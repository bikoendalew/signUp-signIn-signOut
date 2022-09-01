import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/main.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:App()
    );
  }
}
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('HomePage'),
        centerTitle:true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color:Colors.black38,
        child: const Center(
           child: Text("Dashboard",style: TextStyle(fontSize: 50,fontWeight:FontWeight.bold,fontStyle: FontStyle.italic),)
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
       await FirebaseAuth.instance.signOut().then((value)=>Navigator.push(context,
           MaterialPageRoute(builder: (context)=>MyApp())));
        },
        child:const Text('Logout')
      ),
    );
  }
}
