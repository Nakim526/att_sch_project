class RolesHelper {
  RolesHelper._();

  static List<String> toList(String roles) {
    roles = roles.substring(1, roles.length - 1);
    return roles.split(',').map((role) => role.trim()).toList();
  }

  static bool hasRole(List<String> roles, String role) {
    return roles.contains(role);
  }

  static bool hasAnyRole(List<String> roles, List<String> requiredRoles) {
    return requiredRoles.any((role) => roles.contains(role));
  }
}
