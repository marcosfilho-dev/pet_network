import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_network/view/login/login_controller.dart';
import 'package:pet_network/async_value_ui.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Função para realizar o login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Chama o método de login no nosso novo controller
      ref.read(loginControllerProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
      // A navegação será tratada automaticamente pelo GoRouter!
    }
  }

  @override
  void dispose() {
    // Libera os controladores de texto
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ouve o estado do controller para exibir erros com nosso helper
    ref.listen<AsyncValue>(
      loginControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // 2. Observa o estado para saber se está carregando
    final state = ref.watch(loginControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: Colors.grey[200],
    
      // Cor de fundo semelhante ao exemplo do React
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500, // Define uma largura máxima para o conteúdo
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               Image.asset("assets/images/logo.png", scale: 2),
               // const SizedBox(height: 16.0),
                Form(
                  key: _formKey,
                  child: Card(
                    color: Colors.grey[50],
                    elevation: 8.0, // Sombreamento semelhante ao shadow-md do Tailwind
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Valor arredondado semelhante ao rounded-lg
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Entrar no PetSocial',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900], // Cor do texto semelhante ao text-gray-900
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _EmailInputField(
                            controller: _emailController,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 12.0),
                          _PasswordInputField(
                            controller: _passwordController,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 24.0),
                          _LoginButton(isLoading: isLoading, onPressed: _login),
                          const SizedBox(height: 16.0),
                          const _ForgotPasswordLink(),
                          const SizedBox(height: 12.0),
                          const _SignUpLink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget extraído para o campo de Email
class _EmailInputField extends StatelessWidget {
  const _EmailInputField({required this.controller, required this.isLoading});

  final TextEditingController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4.0),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira seu email.';
            }
            if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
              return 'Por favor, insira um email válido.';
            }
            return null;
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'seuemail@exemplo.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          enabled: !isLoading,
        ),
      ],
    );
  }
}

// Widget extraído para o botão de Login
class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // Faz o botão ocupar toda a largura e define uma altura mínima para uma boa área de toque.
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3.0,
              ),
            )
          : const Text(
              'Entrar',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}

// Widget extraído para o link "Esqueceu sua senha?"
class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Adicione a lógica para navegação para a tela de recuperação de senha
        debugPrint('Esqueceu sua senha?');
      },
      child: const Text(
        'Esqueceu sua senha?',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Widget extraído para o link de cadastro
class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navega para a tela de cadastro usando GoRouter
            context.go('/signup');
          },
          child: const Text(
            'Cadastre-se',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget extraído para o campo de Senha
class _PasswordInputField extends StatelessWidget {
  const _PasswordInputField({required this.controller, required this.isLoading});

  final TextEditingController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Senha',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4.0),
        TextFormField(
          controller: controller,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira sua senha.';
            }
            return null;
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Sua senha',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          enabled: !isLoading,
        ),
      ],
    );
  }
}
