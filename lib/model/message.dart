import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int id;
  final String message;
  final String status;

  const Message({
    required this.id,
    required this.message,
    required this.status,
  });

  Message copyWith({
    int? id,
    String? message,
    String? status,
  }) {
    return Message(
      id: this.id,
      message: this.message,
      status: this.message,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map toJson() => {
        'id': id,
        'message': message,
        'status': status,
      };

  @override
  List<Object> get props => [id, message, status];
}
