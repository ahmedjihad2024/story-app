class PromoBannerModel {
  final String id;
  final String tag;
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageAsset;

  const PromoBannerModel({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageAsset,
  });

  static const List<PromoBannerModel> sampleBanners = [
    PromoBannerModel(
      id: 'banner_1',
      tag: 'NEW ARRIVAL',
      title: 'Latest Smartphones',
      subtitle: 'Flagship cameras. All-day battery.',
      buttonText: 'Shop Now',
      imageAsset: 'assets/images/promo_banner_bg.png',
    ),
    PromoBannerModel(
      id: 'banner_2',
      tag: 'SPECIAL OFFER',
      title: 'Pro Laptops 2026',
      subtitle: 'Engineered for power and performance.',
      buttonText: 'Shop Now',
      imageAsset: 'assets/images/popular_zenbook.png',
    ),
    PromoBannerModel(
      id: 'banner_3',
      tag: 'HOT DEALS',
      title: 'Audio & Wearables',
      subtitle: 'Immersive sound and smart tracking.',
      buttonText: 'Shop Now',
      imageAsset: 'assets/images/featured_iphone5s.png',
    ),
  ];
}
