abstract class AuthStatusEvent {}

class AppStarted extends AuthStatusEvent {}

class LoggedIn extends AuthStatusEvent {}

class LoggedOut extends AuthStatusEvent {}
