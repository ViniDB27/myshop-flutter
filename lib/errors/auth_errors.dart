class AuthErrors implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": 'E-mail já cadastrado',
    "OPERATION_NOT_ALLOWED": 'Operação não permitida!',
    "TOO_MANY_ATTEMPTS_TRY_LATER": 'Acesso bloqueado temporariamente, Tente mais tarde',
    "EMAIL_NOT_FOUND": 'Email não encontrado',
    "INVALID_PASSWORD": 'Senha informado não confere',
    "USER_DISABLED": 'A conta do usuário foi desabilidate',
  };

  final String key;
  AuthErrors(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação, contate o suporte para mais detalhes.';
  }
}
