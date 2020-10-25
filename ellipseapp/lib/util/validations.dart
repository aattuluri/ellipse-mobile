extension Extension on Object {
  bool isNullOrEmpty() => this == null || this == "" || this == "undefined";

  bool isEmptyList(List list) => list.isEmpty;

  bool isNullEmptyOrFalse() => this == null || this == "" || !this;

  bool isFalse() => !this;
  bool isSelected() => this || !this;
  bool isTrue() => this;

  bool isNullEmptyZeroOrFalse() =>
      this == null || this == '' || !this || this == 0;

  bool validEmail() => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this);

  bool validAlphaNumeric() => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  bool validAlpha() => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  bool validNumeric() => RegExp(r'^[0-9]+$').hasMatch(this);

  bool validLength(int length) => this.toString().trim().length > length;
}
