extension StringExtension on String {
  String capitalizeEachWord() {
    return toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) {
          return word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1)
              : '';
        })
        .join(' ');
  }

  bool get isEmail {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+"
      r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
    );

    return emailRegex.hasMatch(trim());
  }
}
