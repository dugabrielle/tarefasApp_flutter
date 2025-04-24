import 'package:app_tarefas/src/model/todo.dart';
import 'package:app_tarefas/src/provider/theme_provider.dart';
import 'package:app_tarefas/src/services/firebase_auth.dart';
import 'package:app_tarefas/src/services/firebase_firestore.dart';
import 'package:app_tarefas/src/theme/app_theme.dart';
import 'package:app_tarefas/src/widgets/task_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ToDo> tarefas = [];
  List<ToDo> _filtrarNota = [];

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _carregarUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBarMethod(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                buscarNota(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Tarefas',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                StreamBuilder<List<ToDo>>(
                  stream: _firestoreService.getTodos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Center(
                          child: Text(
                            'Nenhuma tarefa encontrada.',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    tarefas = snapshot.data!;
                    List<ToDo> tarefasPendentes =
                        _filtrarNota.where((todo) => !todo.checkbox).toList();
                    List<ToDo> tarefasConcluidas =
                        _filtrarNota.where((todo) => todo.checkbox).toList();

                    return Column(
                      children: [
                        if (tarefasPendentes.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Center(
                              child: Text(
                                'Nenhuma tarefa pendente.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        else
                          for (var todo in tarefasPendentes)
                            TaskCheckbox(
                              todo: todo,
                              completarTarefa: completarTarefa,
                              excluirTarefa: excluirTarefa,
                              editarTarefa: editarTarefa,
                            ),

                        if (tarefasConcluidas.isNotEmpty) ...[
                          const Divider(color: Colors.grey),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tarefas Concluídas',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          for (var todo in tarefasConcluidas)
                            TaskCheckbox(
                              todo: todo,
                              completarTarefa: completarTarefa,
                              excluirTarefa: excluirTarefa,
                              editarTarefa: editarTarefa,
                            ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 15, right: 15, left: 10),
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  _addNota();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 35,
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // tarefas do firestore em tempo real
  void _carregarUser() {
    _firestoreService.getTodos().listen((todos) {
      if (!mounted) return;
      setState(() {
        tarefas = todos;
        _filtrarNota = todos;
      });
    });
  }

  void completarTarefa(ToDo todo) {
    setState(() {
      todo.checkbox = !todo.checkbox;
    });

    // atualiza
    _firestoreService.editarTarefa(todo.id, todo);
  }

  void editarTarefa(ToDo todo) {
    _tituloController.text = todo.titulo;
    _descricaoController.text = todo.descricao ?? "";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Nota'),
              content: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _tituloController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        maxLength: 80,
                        maxLines: null,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição (opcional)',
                        ),
                        maxLength: 80,
                        maxLines: null,
                      ),
                      if (_tituloController.text.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'O Título não pode ser vazio!',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.purple),
                      iconSize: 22,
                    ),
                    IconButton(
                      onPressed: () {
                        if (_tituloController.text.isEmpty) {
                          setState(() {});
                          return;
                        }

                        todo.titulo = _tituloController.text;
                        todo.descricao = _descricaoController.text;

                        // atualiza
                        _firestoreService.editarTarefa(todo.id, todo);

                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save, color: Colors.purple),
                      iconSize: 22,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void filtrarNota(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filtrarNota = List.from(tarefas); // recupera a lista original
      } else {
        _filtrarNota =
            tarefas
                .where(
                  (todo) =>
                      todo.titulo.toLowerCase().contains(
                        keyword.toLowerCase(),
                      ) ||
                      (todo.descricao?.toLowerCase().contains(
                            keyword.toLowerCase(),
                          ) ??
                          false),
                )
                .toList();
      }
    });
  }

  void _addNota() {
    _tituloController.clear();
    _descricaoController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Adicionar Nota',
                style: TextStyle(fontSize: 28),
              ),

              content: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          labelStyle: TextStyle(fontSize: 18),
                        ),
                        maxLength: 80,
                        maxLines: null,
                        style: const TextStyle(fontSize: 26),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição (opcional)',
                          labelStyle: TextStyle(fontSize: 18),
                        ),
                        maxLength: 80,
                        maxLines: null,
                        style: const TextStyle(fontSize: 26),
                      ),
                      if (_tituloController.text.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'O Título não pode ser vazio!',
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.purple),
                      iconSize: 30,
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_tituloController.text.isEmpty) {
                          setState(() {});
                          return;
                        }

                        final novaTarefa = ToDo(
                          id: DateTime.now().toString(), // gera o id
                          titulo: _tituloController.text,
                          descricao: _descricaoController.text,
                          checkbox: false,
                        );

                        await _firestoreService.addNota(novaTarefa);

                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save, color: Colors.purple),
                      iconSize: 30,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void excluirTarefa(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Nota'),
          content: const Text(
            'Tem certeza que deseja excluir? A nota será permanentemente perdida.',
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tarefas.removeWhere((nota) => nota.id == id);
                });
                _firestoreService.excluirTarefa(id);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Excluir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) async {
    final auth = AuthService();
    await auth.logout();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  AppBar appBarMethod(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return AppBar(
      toolbarHeight: 80,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'ToDo App',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 28),
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(
              provider.theme == AppTheme.darkTheme
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,

              size: 30,
            ),
            onPressed: () => provider.alternarTema(),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              onPressed: () => logout(context),
              icon: Icon(
                Icons.logout,
                size: 30,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buscarNota() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: TextField(
          onChanged: filtrarNota,
          style: const TextStyle(color: Colors.grey, fontSize: 20),
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 30),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 35,
              minWidth: 40,
            ),
            border: InputBorder.none,
            hintText: "Pesquisar",
            hintStyle: TextStyle(color: Colors.grey[700], fontSize: 20),
          ),
        ),
      ),
    );
  }
}
