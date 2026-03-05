class BackendFormatter {
  const BackendFormatter._();

  static String isNotFound(String message, String? type) {
    if (message.contains("type 'Null' is not a subtype of type")) {
      return "Data $type tidak ditemukan";
    }

    return message;
  }
}
