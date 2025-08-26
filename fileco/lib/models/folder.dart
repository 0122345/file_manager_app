class Folder {
  final String name;
  final String createdAt; // ISO-8601 recommended
  final String owner;
  final String? icon; // optional
  final String? id;

  Map<String, dynamic> toJson() => {
        'name': name,
        'createdAt': createdAt,
        'owner': owner,
        'icon': icon,
        'id': id,
      };

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      name: json['name'],
      createdAt: json['createdAt'],
      owner: json['owner'],
      icon: json['icon'],
      id: json['id'],
    );
  }
  const Folder({
    //super.key,
    required this.name,
    required this.owner,
    required this.createdAt,
    this.icon,
    this.id,
  });

  DateTime? get createdAtDate => DateTime.tryParse(createdAt);
}

  