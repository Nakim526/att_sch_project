class BackendFormatter {
  const BackendFormatter._();

  static String isNotFound(String message) {
    if (message.contains("type 'Null' is not a subtype of type ")) {
      return "Data not found";
    }

    return message;
  }
}
