class Message {
  final int id;
  final String message;

  Message({
    required this.id,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      message: json['message'],
    );
  }
}
