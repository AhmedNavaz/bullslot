class Product {
  String? id;
  String? title;
  String? image;
  DateTime? date;
  double? totalPrice;
  int? totalSlots;
  int? bookedSlots;
  double? weight; // in kg

  Product({
    this.id,
    this.title,
    this.image,
    this.date,
    this.totalPrice,
    this.totalSlots,
    this.bookedSlots,
    this.weight,
  });
}
