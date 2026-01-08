enum HolidayOrientType {
  none("none"),

  fixedAnnualDate("fixed_annual_date"),

  variableAnnualDate("variable_annual_date"),

  oneOffDate("one_off_date");

  final String enumValue;

  const HolidayOrientType(this.enumValue);

  factory HolidayOrientType.fromPosition(int ordinalValue) {
    return values.firstWhere((e) => e.index == ordinalValue);
  }

  factory HolidayOrientType.fromName(String stringValue) {
    return values.firstWhere((e) => e.enumValue.toUpperCase() == stringValue.toUpperCase());
  }

  @override
  String toString() {
    return enumValue;
  }

}
