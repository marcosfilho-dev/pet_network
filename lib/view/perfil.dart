import 'package:flutter/material.dart';
import 'package:pet_network/models/data.dart';
import 'package:pet_network/models/profile.dart';
import 'package:pet_network/models/pets_post.dart';
import 'package:pet_network/view/widgets/pet_post_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Controlador para as abas (Grid de posts e posts marcados)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Em um app real, você usaria um provider para buscar os dados do perfil
    final profile = dummyProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          profile.userName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {
              // TODO: Implementar menu de opções (configurações, etc.)
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _ProfileHeader(profile: profile)),
              SliverPersistentHeader(
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on)),
                      Tab(icon: Icon(Icons.person_pin_outlined)),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPostsGrid(profile.posts),
              // Placeholder para a segunda aba
              const Center(child: Text('Posts em que você foi marcado')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsGrid(List<PetPost> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text('Nenhuma publicação ainda.'));
    }
    // Usamos um `CustomScrollView` com `SliverGrid` para melhor performance
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(2.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => PetPostWidget(post: posts[index]),
              childCount: posts.length,
            ),
          ),
        ),
      ],
    );
  }
}

/// O cabeçalho da página de perfil, contendo avatar, stats e bio.
class _ProfileHeader extends StatelessWidget {
  final Profile profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 40, backgroundImage: NetworkImage(profile.avatarUrl)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ProfileStatsWidget(count: profile.stats.postCount, label: 'Posts'),
                    _ProfileStatsWidget(count: profile.stats.followersCount, label: 'Seguidores'),
                    _ProfileStatsWidget(count: profile.stats.followingCount, label: 'Seguindo'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(profile.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(profile.bio),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: () {}, child: const Text('Editar Perfil'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(36))),
        ],
      ),
    );
  }
}

/// Widget para exibir uma única estatística (ex: "1256 Seguidores").
class _ProfileStatsWidget extends StatelessWidget {
  final int count;
  final String label;
  const _ProfileStatsWidget({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

/// Delegate customizado para fixar a TabBar no topo durante o scroll.
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}