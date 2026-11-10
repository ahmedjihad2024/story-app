enum Routes {
  splash('splash'),
  signIn('sign-in'),
  signUp('sign-up'),
  home('home'),
  products('products'),
  favorites('favorites'),
  cart('cart'),
  search('search'),
  filter('filter'),
  productDetails('product-details'),
  updateProfile('update-profile');

  final String name;
  const Routes(this.name);

  String get path => name == 'splash' ? '/' : '/$name';
}
