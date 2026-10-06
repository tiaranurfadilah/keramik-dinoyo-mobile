class Product {
  final String name;
  final String category;
  final String image;
  final int price;

  const Product({
    required this.name,
    required this.category,
    required this.image,
    required this.price,
  });
}

const List<Product> products = [
  Product(
    name: 'Mug Dinoyo',
    category: 'Stoneware',
    image: 'assets/images/mug.jpg',
    price: 75000,
  ),
  Product(
    name: 'Vas Meja',
    category: 'Studio Craft',
    image: 'assets/images/vas.jpg',
    price: 115000,
  ),
  Product(
    name: 'Piring Saji',
    category: 'Tableware',
    image: 'assets/images/piring.jpg',
    price: 95000,
  ),
  Product(
    name: 'Tempat Dupa',
    category: 'Home Decor',
    image: 'assets/images/dupa.jpg',
    price: 45000,
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