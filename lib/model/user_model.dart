class ChatUser {
  final String id;
  final String name;
  final String email;

  ChatUser({required this.id, required this.name, required this.email});

  factory ChatUser.fromMap(Map<String, dynamic> data, String id) {
    return ChatUser(
      id: id,
      name: data['name'],
      email: data['email'],
    );
  }
}