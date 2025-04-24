import 'package:app_tarefas/src/model/todo.dart';
import 'package:flutter/material.dart';

class TaskCheckbox extends StatelessWidget {
  final ToDo todo;
  final Function completarTarefa;
  final Function excluirTarefa;
  final Function editarTarefa;

  const TaskCheckbox({
    super.key,
    required this.todo,
    required this.completarTarefa,
    required this.excluirTarefa,
    required this.editarTarefa,
  });

  @override
  Widget build(BuildContext context) {
    Color titleColor = Theme.of(context).colorScheme.tertiary;
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
         isThreeLine: true,
        tileColor: titleColor,
        titleAlignment: ListTileTitleAlignment.center, 
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: todo.checkbox,
            onChanged: (bool? value) {
              completarTarefa(todo);
            },
            activeColor: Colors.black,
            checkColor: Colors.white,
            hoverColor: const Color(0xFFECD4F0),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        title: Text(
          todo.titulo,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 24,
            decoration: todo.checkbox ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          todo.descricao ?? '',
          style: const TextStyle(color: Colors.grey, fontSize: 22),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                excluirTarefa(todo.id);
              },
              icon: const Icon(Icons.delete),
              iconSize: 35,
              color: Colors.grey[500],
              hoverColor: const Color(0xFFECD4F0),
            ),
           
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {
                editarTarefa(todo);
              },
              icon: const Icon(Icons.edit_note),
              iconSize: 35,
              color: Theme.of(context).colorScheme.secondary,
              hoverColor: const Color(0xFFECD4F0),
            ),
          ],
        ),
      ),
    );
  }
}
