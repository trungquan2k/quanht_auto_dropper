class DropItem<T> {
  int id;
  String name;
  String? flag;
  int? index;
  T? data;

  DropItem(
      {required this.id, this.index, required this.name, this.flag, this.data});

  factory DropItem.fromJson(Map<String, dynamic> json) {
    return DropItem(
      id: json['id'] ?? 0,
      name: json['name'],
      flag: json['flag'],
      index: json['index'],
    );
  }

  void copyWith({
    String? nameSelected,
    int? id,
    int? index,
  }) {
    this.name = nameSelected ?? this.name;
    this.id = id ?? this.id;
    this.index = index ?? this.index;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
