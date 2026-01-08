enum DateElementType{

  day("day"),

  week("week"),

  month("month"),

  year("year");

  final String enumValue;

  const DateElementType(this.enumValue);

  factory DateElementType.fromPosition(int ordinalValue) {
    return values.firstWhere((e) => e.index == ordinalValue);
  }

  factory DateElementType.fromName(String stringValue) {
    return values.firstWhere((e) => e.enumValue.toUpperCase() == stringValue.toUpperCase());
  }

  @override
  String toString() {
    return enumValue;
  }

}