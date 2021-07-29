class Plan {
  final String id;
  final String name;
  final int freeTimeInMinutes;
  final double additionalMinuteRate;

  Plan(this.id, this.name, this.freeTimeInMinutes, this.additionalMinuteRate);

  @override
  String toString() {
    return 'Plan{id: $id, name: $name, freeTimeInMinutes: $freeTimeInMinutes, additionalMinuteRate: $additionalMinuteRate}';
  }

  Plan.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        freeTimeInMinutes = json['freeTimeInMinutes'],
        additionalMinuteRate = (json['additionalMinuteRate']).toDouble();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'freeTimeInMinutes': freeTimeInMinutes,
        'additionalMinuteRate': additionalMinuteRate
      };
}
