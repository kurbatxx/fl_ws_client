enum ActionEnum {
  getMessages('get_messages'),
  addMessage('add_message');

  final String value;
  const ActionEnum(this.value);
}

ActionEnum? toEnum(String value) {
  try {
    return ActionEnum.values.firstWhere((e) => e.value == value);
  } catch (_) {
    return null;
  }
}
