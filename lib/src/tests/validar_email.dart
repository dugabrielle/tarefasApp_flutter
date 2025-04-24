class ValidateEmail {
  validate({String? email}) {
    if (email == null || email.isEmpty) {
      return 'O e-mail não pode estar vazio';
    }
    return null;
  }
}
