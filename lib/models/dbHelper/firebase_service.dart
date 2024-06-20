import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  Future<String?> uploadImage(File image) async {
    try {
      final storageReference = _storage.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageReference.putFile(image);
      final completedTask = await uploadTask.whenComplete(() => null);
      final downloadUrl = await completedTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error al subir imagen: $e');
      return null;
    }
  }

  static Future<void> deleteImageFromStorage(String imageUrl) async {
  try {
    // Obtener la referencia al archivo en Firebase Storage usando la URL
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);

    // Eliminar el archivo
    await ref.delete();

    print('Imagen eliminada correctamente del Firebase Storage.');
  } catch (e) {
    print('Error al eliminar la imagen del Firebase Storage: $e');
    throw Exception('Error al eliminar la imagen del Firebase Storage.');
  }
}

  
}