import 'package:firebase_auth/firebase_auth.dart';

class Authservice{
  final _auth = FirebaseAuth.instance;


  Future<User?> createUserWithEmailAndPassword(
    String email, String password)async{
      try{
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return cred.user;}
    catch(e){

    }
    return null;
  }

    Future<User?> loginUserWithEmailAndPassword(
    String email, String password)async{
      try{
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;}
    catch(e){
      
    }
    return null;
  }

  Future<void> singout()async {
    try{
      await _auth.signOut();
    }catch(e){

    } 
  }
}