enum Routes {
  signIn('sign-in'),
  signUp('sign-up'),
  home('home');

  final String name;
  const Routes(this.name);

  String get path => '/$name';
}
