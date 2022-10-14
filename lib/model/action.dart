class ReceivedAction<T> {
  final String action;
  final T data;
  final String? error;
  ReceivedAction({
    required this.action,
    required this.data,
    this.error,
  });

  factory ReceivedAction.fromJson(Map<String, dynamic> json) {
    return ReceivedAction(
      action: json['action'],
      data: json['data'],
      error: json['error'],
    );
  }

  Map toJson() => {
        'action': action,
        'data': data,
      };
}
