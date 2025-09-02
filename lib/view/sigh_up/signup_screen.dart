import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_network/async_value_ui.dart';
import 'package:pet_network/view/sigh_up/signup_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      ref.read(signUpControllerProvider.notifier).signUp(
            _emailController.text,
            _passwordController.text,
          );
      // A navegação será tratada automaticamente pelo GoRouter após o sucesso!
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      signUpControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(signUpControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/logo.png", scale: 2),
                Form(
                  key: _formKey,
                  child: Card(
                    color: Colors.grey[50],
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Criar Conta',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
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
                          _SignUpButton(isLoading: isLoading, onPressed: _signUp),
                          const SizedBox(height: 16.0),
                          const _SignInLink(),
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

class _EmailInputField extends StatelessWidget {
  const _EmailInputField({required this.controller, required this.isLoading});
  final TextEditingController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        labelText: 'Email',
        fillColor: Colors.white,
        filled: true,
        hintText: 'seuemail@exemplo.com',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      enabled: !isLoading,
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  const _PasswordInputField({required this.controller, required this.isLoading});
  final TextEditingController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira sua senha.';
        }
        if (value.length < 6) {
          return 'A senha deve ter no mínimo 6 caracteres.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Senha',
        fillColor: Colors.white,
        filled: true,
        hintText: 'Sua senha',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      enabled: !isLoading,
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({required this.isLoading, required this.onPressed});
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0),
            )
          : const Text('Cadastrar', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
    );
  }
}

class _SignInLink extends StatelessWidget {
  const _SignInLink();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: Text('Já tem uma conta? Entre aqui',
          style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
    );
  }
}