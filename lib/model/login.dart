class LoginModel {
  final String organizationName;
  final String email;
  final String password;

  LoginModel({
    this.organizationName = '',
    this.email = '',
    this.password = '',
  });

  LoginModel copyWith({
    String? organizationName,
    String? email,
    String? password,
  }) {
    return LoginModel(
      organizationName: organizationName ?? this.organizationName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  LoginModel merge(LoginModel other) {
    return copyWith(
      organizationName: other.organizationName.isNotEmpty ? other.organizationName : null,
      email: other.email.isNotEmpty ? other.email : null,
      password: other.password.isNotEmpty ? other.password : null,
    );
  }
}