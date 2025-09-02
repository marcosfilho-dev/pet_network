import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/home_app.dart';
import 'package:pet_network/provider/auth_provider.dart';
import 'package:pet_network/view/sigh_up/signup_screen.dart';
import 'package:pet_network/view/login/login_screen.dart';
import 'package:pet_network/view/splash_screen/splash_screen.dart';

// Chave para o navegador principal
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  // Observa o estado de autenticação
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true, // Útil para depuração

    // A mágica acontece aqui!
    redirect: (context, state) {
      // Se o estado de autenticação ainda está carregando, não fazemos nada.
      // A tela de splash será exibida.
      if (authState.isLoading || authState.hasError) {
        return null;
      }

      // Verifica se o usuário está logado
      final isLoggedIn = authState.valueOrNull != null;

      // Pega a localização atual
      final location = state.matchedLocation;
      final isAtSplash = location == '/splash';
      final isAtLogin = location == '/login';
      final isAtSignUp = location == '/signup';

      // Se o usuário está na tela de splash e a autenticação foi resolvida, redireciona.
      if (isAtSplash) {
        return isLoggedIn ? '/homeapp' : '/login';
      }

      // Se o usuário NÃO está logado e tentando acessar uma rota protegida, redireciona para o login.
      if (!isLoggedIn && !isAtLogin && !isAtSignUp) {
        return '/login';
      }

      // Se o usuário ESTÁ logado e tentando acessar as telas de login/cadastro, redireciona para a home.
      if (isLoggedIn && (isAtLogin || isAtSignUp)) {
        return '/homeapp';
      }

      // Nenhum redirecionamento necessário.
      return null;
    },

    routes: [
      GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/homeapp', builder: (context, state) => const HomeApp()),
      // TODO: Adicione outras rotas aqui (explorar, camera, etc.)
    ],
  );
});