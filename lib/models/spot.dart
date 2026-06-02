class Spot {
  final String id;
  final String name;
  final String description;
  final String category;
  final String createdBy;

  Spot({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.createdBy,
  });

  factory Spot.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return Spot(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'createdBy': createdBy,
    };
  }
}