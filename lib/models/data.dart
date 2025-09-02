import 'package:pet_network/models/pets_post.dart';
import 'package:pet_network/models/notification_item.dart';
import 'package:pet_network/models/profile.dart';

// Lista de posts de exemplo. Em um app real, isso viria de uma API.
// As imagens agora são de pets, para deixar o app mais temático.
// usando serviços de placeholder estáveis.
const List<PetPost> dummyPetPosts = [
  PetPost(id: '1', petName: 'Rex', imageUrl: 'https://placedog.net/500/500?id=1', likes: 10),
  PetPost(id: '2', petName: 'Milo', imageUrl: 'https://placekitten.com/500/500?image=2', likes: 25),
  PetPost(id: '3', petName: 'Buddy', imageUrl: 'https://placedog.net/500/500?id=3', likes: 15),
  PetPost(id: '4', petName: 'Lucy', imageUrl: 'https://placekitten.com/500/500?image=4', likes: 30),
  PetPost(id: '5', petName: 'Max', imageUrl: 'https://placedog.net/500/500?id=5', likes: 5),
  PetPost(id: '6', petName: 'Bella', imageUrl: 'https://placekitten.com/500/500?image=6', likes: 42),
  PetPost(id: '7', petName: 'Charlie', imageUrl: 'https://placedog.net/500/500?id=7', likes: 18),
  PetPost(id: '8', petName: 'Daisy', imageUrl: 'https://placekitten.com/500/500?image=8', likes: 22),
  PetPost(id: '9', petName: 'Rocky', imageUrl: 'https://placedog.net/500/500?id=9', likes: 35),
  PetPost(id: '10', petName: 'Zoe', imageUrl: 'https://placekitten.com/500/500?image=10', likes: 12),
  PetPost(id: '11', petName: 'Duke', imageUrl: 'https://placedog.net/500/500?id=11', likes: 50),
  PetPost(id: '12', petName: 'Sadie', imageUrl: 'https://placekitten.com/500/500?image=12', likes: 8),
  PetPost(id: '13', petName: 'Toby', imageUrl: 'https://placedog.net/500/500?id=13', likes: 19),
  PetPost(id: '14', petName: 'Chloe', imageUrl: 'https://placekitten.com/500/500?image=14', likes: 27),
  PetPost(id: '15', petName: 'Jack', imageUrl: 'https://placedog.net/500/500?id=15', likes: 33),
  PetPost(id: '16', petName: 'Lola', imageUrl: 'https://placekitten.com/500/500?image=16', likes: 11),
  PetPost(id: '17', petName: 'Buster', imageUrl: 'https://placedog.net/500/500?id=17', likes: 45),
  PetPost(id: '18', petName: 'Ruby', imageUrl: 'https://placekitten.com/500/500?image=18', likes: 14),
];

// Lista de notificações de exemplo.
const List<NotificationItem> dummyNotifications = [
  NotificationItem(
    id: '1',
    userName: 'Bella',
    userAvatarUrl: 'https://placekitten.com/150/150?image=6',
    message: 'curtiu sua foto.',
    timeAgo: '5m',
    type: NotificationType.like,
    postImageUrl: 'https://placedog.net/500/500?id=1',
  ),
  NotificationItem(
    id: '2',
    userName: 'Charlie',
    userAvatarUrl: 'https://placedog.net/150/150?id=7',
    message: 'começou a seguir você.',
    timeAgo: '1h',
    type: NotificationType.follow,
  ),
  NotificationItem(
    id: '3',
    userName: 'Lucy',
    userAvatarUrl: 'https://placekitten.com/150/150?image=4',
    message: 'comentou: "Que fofura! 💖"',
    timeAgo: '3h',
    type: NotificationType.comment,
    postImageUrl: 'https://placedog.net/500/500?id=5',
  ),
  NotificationItem(
    id: '4',
    userName: 'Max',
    userAvatarUrl: 'https://placedog.net/150/150?id=5',
    message: 'curtiu sua foto.',
    timeAgo: '1d',
    type: NotificationType.like,
    postImageUrl: 'https://placekitten.com/500/500?image=2',
  ),
];

// Dados de exemplo para um perfil de usuário (pet).
final Profile dummyProfile = Profile(
  id: 'user_rex',
  userName: 'rex_the_dog',
  displayName: 'Rex',
  avatarUrl: 'https://placedog.net/150/150?id=1',
  bio: 'Just a good boy looking for snacks 🦴\nLoves parks and naps.',
  stats: ProfileStats(
    // Conta dinamicamente os posts que pertencem a este perfil
    postCount: dummyPetPosts.where((p) => p.petName == 'Rex').length,
    followersCount: 1256,
    followingCount: 210,
  ),
  // Filtra a lista de posts para pegar apenas os que pertencem a este perfil
  posts: dummyPetPosts.where((p) => p.petName == 'Rex').toList(),
);