dynamic parseToNull(String? value) {
  return (value?.toLowerCase() == "null" || value == null) ? null : value;
}
