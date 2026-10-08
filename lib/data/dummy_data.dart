class Product {
  final String name;
  final String category;
  final String image;
  final int price;
  final String shopName;
  final double rating;
  final int ratingCount;
  final String description;
  final String material;
  final String capacity;
  final String finishing;
  final String character;
  final bool limitedBatch;

  const Product({
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.shopName,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.material,
    required this.capacity,
    required this.finishing,
    required this.character,
    this.limitedBatch = false,
  });
}

const List<Product> products = [
  Product(
    name: 'Mug Dinoyo',
    category: 'Stoneware',
    image: 'assets/images/produk1.png',
    price: 75000,
    shopName: 'Studio Pak Slamet',
    rating: 4.9,
    ratingCount: 56,
    description:
        'Setiap cangkir memiliki guratan dan corak glasir unik yang dihasilkan dari proses pembakaran suhu tinggi di tungku Dinoyo. Tekstur bintik alami kaolin menyajikan sentuhan hangat pada setiap ritual seduhan kopi Anda.',
    material: 'Tanah Liat Lokal',
    capacity: '250 ml',
    finishing: 'Glasir Natural',
    character: 'Tahan Panas',
    limitedBatch: true,
  ),
  Product(
    name: 'Vas Meja',
    category: 'Hand-built',
    image: 'assets/images/produk3.png',
    price: 115000,
    shopName: 'Toko Keramik Bu Sari',
    rating: 4.8,
    ratingCount: 32,
    description:
        'Vas dekoratif yang dibentuk dan diselesaikan dengan tangan. Setiap lekuknya menghadirkan karakter unik untuk mempercantik ruang favorit Anda.',
    material: 'Tanah Liat Lokal',
    capacity: 'Tinggi 20 cm',
    finishing: 'Glasir Matte',
    character: 'Buatan Tangan',
  ),
  Product(
    name: 'Piring Saji',
    category: 'Gas Kiln',
    image: 'assets/images/produk2.png',
    price: 95000,
    shopName: 'Sentra Keramik Dinoyo',
    rating: 4.9,
    ratingCount: 41,
    description:
        'Piring saji bermotif khas Dinoyo dengan warna yang terinspirasi dari ragam hias lokal. Cocok untuk menyajikan hidangan maupun sebagai dekorasi.',
    material: 'Tanah Liat Lokal',
    capacity: 'Diameter 22 cm',
    finishing: 'Glasir Motif',
    character: 'Food Safe',
  ),
  Product(
    name: 'Tempat Dupa',
    category: 'Celadon',
    image: 'assets/images/produk4.png',
    price: 45000,
    shopName: 'Studio Pak Slamet',
    rating: 4.7,
    ratingCount: 24,
    description:
        'Tempat dupa mungil dengan bentuk organik dan glasir lembut. Dibuat satu per satu sehingga setiap karya memiliki corak yang berbeda.',
    material: 'Tanah Liat Lokal',
    capacity: 'Panjang 12 cm',
    finishing: 'Glasir Celadon',
    character: 'Buatan Tangan',
  ),
];

String formatRupiah(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return 'Rp$buffer';
}
