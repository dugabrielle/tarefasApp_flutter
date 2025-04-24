class ValidatePassword {
  validate({String? pass}) {
    if (pass == null || pass.isEmpty) {
      return 'A senha não pode estar vazia';
    }
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%*!])[A-Za-z\d@#$%*!]{8,}$',
    );
    if (!regex.hasMatch(pass)) {
      return 'A senha deve conter pelo menos 8 caracteres, incluindo letra maiúscula, letra minúscula, número e um caractere especial (@, #, \$, %, *, !).';
    }
    return null;
  }
}
