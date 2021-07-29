class AreaCode {
  final int code;
  final String name;

  AreaCode(this.code, this.name);

  @override
  String toString() {
    return 'AreaCode{code: $code, name: $name}';
  }

  AreaCode.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
      };
}
