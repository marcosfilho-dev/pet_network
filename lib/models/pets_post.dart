/// Define o modelo de dados para um post de pet.
/// Este arquivo deve conter apenas a estrutura de dados (a classe PetPost)
/// e não widgets de UI.
class PetPost {
  final String id;
  final String petName;
  final String imageUrl;
  final int likes;

  const PetPost({
    required this.id,
    required this.petName,
    required this.imageUrl,
    required this.likes,
  });
}