/// Enum para diferenciar os tipos de notificação.
enum NotificationType { like, comment, follow }

/// Representa um único item na lista de notificações.
class NotificationItem {
  final String id;
  final String userAvatarUrl;
  final String userName;
  final String message;
  final String timeAgo;
  final NotificationType type;
  final String? postImageUrl; // Opcional: para notificações de 'like' ou 'comentário'

  const NotificationItem({
    required this.id,
    required this.userAvatarUrl,
    required this.userName,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.postImageUrl,
  });
}