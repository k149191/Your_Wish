class Wish{
  final String id;
  final String title;
  final String price;
  final String category;
  final String notes;

  Wish ({
    required this.id,
    required this.title,
    this.price = '',
    this.category = '',
    this.notes = '',
  });
}