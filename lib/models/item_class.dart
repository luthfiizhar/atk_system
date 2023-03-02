class Item {
  Item({
    this.itemId = "",
    this.itemName = "",
    this.unit = "",
    this.basePrice = 0,
    this.qty = 0,
    this.totalPrice = 0,
  });

  String itemId;
  String itemName;
  String unit;
  int basePrice;
  int qty;
  int totalPrice;

  Map<String, dynamic> toJson() => {
        '"ItemID"': '"$itemId"',
        '"ItemName"': '"$itemName"',
        '"Unit"': unit,
        '"BasePrice"': basePrice,
        '"Qty"': qty,
        '"TotalPrice"': totalPrice
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
