class ValidateName {
  validate({String? name}) {
    if (name == null || name.isEmpty) {
      return 'O nome não pode estar vazio';
    }
    return null;
  }
}
