enum ChildSex {
  boy,
  girl,
}

class Child {
  final String id;
  final String name;
  final DateTime birthDate;
  final ChildSex sex;
  final String? photoPath;
  final DateTime createdAt;

  const Child({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.sex,
    this.photoPath,
    required this.createdAt,
  });

  Child copyWith({
    String? name,
    DateTime? birthDate,
    ChildSex? sex,
    String? photoPath,
  }) {
    return Child(
      id: id,
      name: name ?? this.name,
      birthDate:
          birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      photoPath:
          photoPath ?? this.photoPath,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date':
          birthDate.toIso8601String(),
      'sex': sex.name,
      'photo_path': photoPath,
      'created_at':
          createdAt.toIso8601String(),
    };
  }

  factory Child.fromMap(
    Map<String, Object?> map,
  ) {
    final String sexValue =
        map['sex'] as String;

    return Child(
      id: map['id'] as String,
      name: map['name'] as String,
      birthDate: DateTime.parse(
        map['birth_date'] as String,
      ),
      sex: sexValue == ChildSex.girl.name
          ? ChildSex.girl
          : ChildSex.boy,
      photoPath:
          map['photo_path'] as String?,
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ),
    );
  }
}