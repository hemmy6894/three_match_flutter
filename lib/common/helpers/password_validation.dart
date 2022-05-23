class PasswordValidation {
  static bool validate(value) {
    bool password = value.length > 1;
    return !password;
  }

  static String message() {
    return "Minimu pasword lenght is 1";
  }
}
