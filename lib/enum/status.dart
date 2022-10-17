enum StatusEnum {
  wait('wait'),
  transferred('transferred'),
  complete('complete');

  final String value;
  const StatusEnum(this.value);
}

StatusEnum? statusToEnum(String value) {
  try {
    return StatusEnum.values.firstWhere((e) => e.value == value);
  } catch (_) {
    return null;
  }
}
