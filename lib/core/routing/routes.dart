enum Routes {
  splash('splash'),
  signIn('sign-in'),
  signUp('sign-up'),
  home('home'),
  products('products');

  final String name;
  const Routes(this.name);

  String get path => name == 'splash' ? '/' : '/$name';
}
