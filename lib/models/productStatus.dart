import 'package:bullslot/models/product.dart';

enum Status { PENDING, PAID, DELIVERED, REJECTED, REFUNDED }

class ProductStatus {
  Product? product;
  Status? status;

  ProductStatus({this.product, this.status});
}
