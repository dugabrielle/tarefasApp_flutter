class ToDo {
  String id;
  String titulo;
  String? descricao;
  bool checkbox;

  ToDo({
    required this.id,
    required this.titulo,
    this.descricao,
    this.checkbox = false,
  });
}
