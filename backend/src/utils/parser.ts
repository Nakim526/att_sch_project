export function parseEnum<T extends Record<string, string>>(
  enumObj: T,
  value: unknown,
  field: string,
): T[keyof T] {
  const enumValues = Object.values(enumObj);

  if (!enumValues.includes(value as string)) {
    throw new Error(`Invalid ${field}. Allowed: ${enumValues.join(", ")}`);
  }

  return value as T[keyof T];
}

export function parseEnumArray<T extends Record<string, string>>(
  enumObj: T,
  values: unknown,
  field: string,
): Array<T[keyof T]> {
  if (!Array.isArray(values)) {
    throw new Error(`${field} must be an array`);
  }

  const enumValues = Object.values(enumObj);

  for (const v of values) {
    if (!enumValues.includes(v)) {
      throw new Error(
        `Invalid ${field} value: ${v}. Allowed: ${enumValues.join(", ")}`,
      );
    }
  }

  return values as Array<T[keyof T]>;
}
