class Item {
  Item({
    this.itemId = "",
    this.itemName = "",
    this.unit = "",
    this.basePrice = 0,
    this.qty = 0,
    this.totalPrice = 0,
    this.estimatedPrice = 0,
    this.reqQty = 0,
    this.reqPrice = 0,
    this.actualPrice = 0,
    this.actualQty = 0,
    this.actualTotalPrice = 0,
    this.isExpanded = false,
  });

  String itemId;
  String itemName;
  String unit;
  int basePrice;
  int estimatedPrice;
  int qty;
  int totalPrice;
  int reqQty;
  int reqPrice;
  int actualPrice;
  int actualQty;
  int actualTotalPrice;
  bool isExpanded;

  Map<String, dynamic> toJson() => {
        '"ItemID"': '"$itemId"',
        '"ItemName"': '"$itemName"',
        '"Price"': basePrice,
        '"Quantity"': qty,
        '"TotalPrice"': totalPrice,
        '"ActualQuantity"': actualQty,
        '"ActualPrice"': actualPrice
      };

  // Map<String, dynamic> jsonSubmitSettlement() => {
  //       '"ItemID"': '"$itemId"',
  //       '"ActualQuantity"': actualQty,
  //       '"ActualPrice"': actualPrice
  //     };

  @override
  String toString() {
    return toJson().toString();
  }
}
