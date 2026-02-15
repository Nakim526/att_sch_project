extension StringExtension on String {
  String capitalizeEachWord() {
    return toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }
}
