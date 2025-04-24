import 'package:app_tarefas/src/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // usuário
  Future<void> addUser(String uid, String email, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'uid': uid,
      });
    } catch (e) {
      throw Exception("Erro ao adicionar usuário no Firestore: $e");
    }
  }

  // add
  Future<void> addNota(ToDo todo) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      await _firestore.collection('notes').add({
        'todoText': todo.titulo,
        'description': todo.descricao,
        'isCompleted': todo.checkbox,
        'uid': uid,
      });
    } catch (e) {
      throw ("Erro ao adicionar tarefa: $e");
    }
  }

  // update
  Future<void> editarTarefa(String noteId, ToDo todo) async {
    try {
      await _firestore.collection('notes').doc(noteId).update({
        'todoText': todo.titulo,
        'description': todo.descricao,
        'isCompleted': todo.checkbox,
      });
    } catch (e) {
      throw Exception("Erro ao atualizar tarefa: $e");
    }
  }

  // delete
  Future<void> excluirTarefa(String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      throw Exception("Erro ao excluir tarefa: $e");
    }
  }

  // tarefas em tempo real
  Stream<List<ToDo>> getTodos() {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection('notes')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ToDo(
              id: doc.id,
              titulo: doc['todoText'],
              descricao: doc['description'],
              checkbox: doc['isCompleted'],
            );
          }).toList();
        });
  }
}
