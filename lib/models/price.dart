class Price {
  final int fromCode;
  final int toCode;
  final double price;

  Price(this.fromCode, this.toCode, this.price);

  Price.fromJson(Map<String, dynamic> json)
      : fromCode = json['fromCode'],
        toCode = json['toCode'],
        price = json['price'];

  Map<String, dynamic> toJson() =>
      {'fromCode': fromCode, 'toCode': toCode, 'price': price};
}
