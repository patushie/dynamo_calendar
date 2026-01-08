class UniqueValueField {

  String? fieldValue;

  UniqueValueField.init(String? fValue) {
    fieldValue = fValue;
  }

  @override
  bool operator ==(Object other) {
    bool? equals = false;

    if (other is UniqueValueField) {
      if (other.fieldValue != null) {
        if ((other.fieldValue!.trim().isNotEmpty) && (fieldValue!.trim().isNotEmpty)) {
          equals = other.fieldValue == fieldValue;
        }
      }
    }

    return equals;
  }

  @override
  int get hashCode => fieldValue.hashCode;

  @override
  String toString() {
    return fieldValue!;
  }

}