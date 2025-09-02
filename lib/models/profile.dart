import 'package:pet_network/models/pets_post.dart';

/// Representa as estatísticas de um perfil (posts, seguidores, etc.).
class ProfileStats {
  final int postCount;
  final int followersCount;
  final int followingCount;

  const ProfileStats({
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
  });
}

/// Representa um perfil completo de um usuário (pet).
class Profile {
  final String id;
  final String userName;
  final String displayName;
  final String avatarUrl;
  final String bio;
  final ProfileStats stats;
  final List<PetPost> posts;

  const Profile(
      {required this.id,
      required this.userName,
      required this.displayName,
      required this.avatarUrl,
      required this.bio,
      required this.stats,
      required this.posts});
}