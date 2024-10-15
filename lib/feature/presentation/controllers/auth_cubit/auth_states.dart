abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class ChangePasswordState extends AuthStates{}

/// Register states

class RegisterLoadingState extends AuthStates {}

// class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {
  final String error;

  RegisterErrorState(this.error);
}

/// login states

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState(this.error);
}

/// create user states
class CreateUserSuccessState extends AuthStates {}

class CreateUserErrorState extends AuthStates {
  final String error;

  CreateUserErrorState(this.error);
}

///Reset password states
class ResetPasswordLoadingState extends AuthStates {}

class ResetPasswordSuccessState extends AuthStates {}

class ResetPasswordErrorState extends AuthStates {
  final String error;

  ResetPasswordErrorState(this.error);
}

/// sign in with google  states
class GoogleSignLoadingState extends AuthStates {}
class GoogleSignSuccessState extends AuthStates {}

class GoogleSignErrorState extends AuthStates {
  final String error;

  GoogleSignErrorState(this.error);
}
