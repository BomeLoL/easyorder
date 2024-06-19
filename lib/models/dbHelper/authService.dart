import 'package:easyorder/models/clases/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream<List<Usuario>> readUsers() => _fs.collection('users').snapshots().map((snapshot) => 
  //   snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList()
  // );

  Future<Usuario?> getUserByEmailAndAccount(String email, String cuenta) async {
    try {
      QuerySnapshot snapshot = await _fs.collection('users')
          .where('correo', isEqualTo: email)
          .where('cuenta', isEqualTo: cuenta)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return Usuario.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null; // No se encontró ningún usuario
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(Usuario usuario) async {
    try {
      final userDoc = _fs.collection('users').doc('${usuario.correo},${usuario.cuenta}');

      // Convertir el objeto Usuario a JSON
      Map<String, dynamic> updatedData = usuario.toJson();

      // Actualizar el documento con los nuevos datos
      await userDoc.update(updatedData);
    } catch (e) {
      print("Error updating user: $e");
    }
  }

Future<String?> signinwithGoogle() async {
  try {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(authCredential);
      User? user = userCredential.user;
        return user?.email;
    }
  } catch (e) {
    print("Error signing in with Google: $e");
  }
  return null;
}

  Future<void> createUserDoc({
    required String cuenta,
    required String nombre,
    required String correo,
    required String usertype,
  }) async {
    double saldo = 0;
    final newUser = _fs.collection('users').doc(correo+","+cuenta);
    final json = {
      'cuenta': cuenta,
      'nombre': nombre,
      'correo': correo,
      'usertype': usertype,
      'saldo': saldo,
    };
    await newUser.set(json);
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch (e) {
      print("Error creating user: $e");
      return null;
    }
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
