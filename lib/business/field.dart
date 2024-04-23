class Field {
  final int number;
  final List schedules;

  const Field({
    required this.number,
    required this.schedules,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'number': int number,
        'schedules': List schedules,
      } =>
        Field(
          number: number,
          schedules: schedules,
        ),
      _ => throw const FormatException('Failed to load field.'),
    };
  }
}