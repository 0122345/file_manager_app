class File {
  final int id;
  final String name;
  final String createdAt; 
  final String owner;
  final String? icon;  
  final String type; 
  final int? size;  

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt,
        'owner': owner,
        'icon': icon,
        'type': type,
        'size': size,
      };

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      owner: json['owner'],
      icon: json['icon'],
      type: json['type'],
      size: json['size'],
    );
  }

  const File({
    //super.key,
    required this.id,
    required this.name,
    required this.owner,
    required this.type,
    required this.createdAt,
    this.icon,
    this.size,
  });

  DateTime? get createdAtDate => DateTime.tryParse(createdAt);
}
