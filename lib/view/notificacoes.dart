import 'package:pet_network/view/notificacoes.dart';
import 'package:flutter/material.dart';
import 'package:pet_network/models/data.dart';
import 'package:pet_network/models/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Em um app real, você usaria um provider para buscar as notificações.
    final notifications = dummyNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificações',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma notificação ainda',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
              itemBuilder: (context, index) {
                return NotificationTile(notification: notifications[index]);
              },
            ),
    );
  }
}

/// Um widget para exibir um único item de notificação.
class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(notification.userAvatarUrl),
        radius: 25,
      ),
      title: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
          children: [
            TextSpan(
              text: '${notification.userName} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: notification.message),
          ],
        ),
      ),
      subtitle: Text(
        notification.timeAgo,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: _buildTrailingWidget(),
      onTap: () {
        // TODO: Implementar navegação para o post ou perfil do usuário
        print('Notificação ${notification.id} clicada!');
      },
    );
  }

  /// Constrói o widget à direita, que pode ser uma imagem do post ou um botão.
  Widget? _buildTrailingWidget() {
    if (notification.postImageUrl != null) {
      return SizedBox(
        width: 50,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            notification.postImageUrl!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return null;
  }
}