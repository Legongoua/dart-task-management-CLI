enum Priority {
  low('Basse', 1),
  medium('Moyenne', 2),
  high('Haute', 3);

  final String label;
  final int value;

  const Priority(this.label, this.value);

  static Priority fromString(String str) {
    return Priority.values.firstWhere(
      (p) => p.name.toLowerCase() == str.toLowerCase(),
      orElse: () => Priority.medium,
    );
  }
}