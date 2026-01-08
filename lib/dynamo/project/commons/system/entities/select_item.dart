class SelectItem {
  String? label;
  Object? value;
  String? description;
  String? searchText;

  SelectItem.init() {
    label = "";
    value = null;
    description = "";
  }

  SelectItem.create(String inputLabel, Object inputValue, {String? descValue, String? searchTextVal}) {
    label = inputLabel;
    value = inputValue;

    if(descValue != null) {
      description = descValue;
    }

    if(searchTextVal != null) {
      searchText = searchTextVal;
    }
  }

  @override
  bool operator ==(Object other) {
    bool? equals = false;

    if (other is SelectItem) {
      if ((other.value != null) && (value != null)) {
        equals = other.value == value;
      }
    }

    return equals;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return label!;
  }
}