import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Função para realizar o login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null; // Limpa qualquer mensagem de erro anterior
      });

      // Simula uma chamada assíncrona para autenticação (substitua com sua lógica real)
      try {
        // Simula um atraso de 2 segundos
        await Future.delayed(Duration(seconds: 2));

        // Simula sucesso ou falha na autenticação
        if (_emailController.text == 'teste@email.com' &&
            _passwordController.text == 'senha123') {
          if (!mounted) return;
          // Navega para a tela principal em caso de sucesso
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          throw 'Credenciais inválidas. Tente novamente.';
        }
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
    return Scaffold(
    
      // Cor de fundo semelhante ao exemplo do React
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 8.0, // Sombreamento semelhante ao shadow-md do Tailwind
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Valor arredondado semelhante ao rounded-lg
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
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
                    SizedBox(height: 16.0),
                    if (_errorMessage != null)
                      _buildErrorAlert(), // Exibe o alerta de erro
                    SizedBox(height: 16.0),
                    _EmailInputField(
                      controller: _emailController,
                      isLoading: _isLoading,
                      errorMessage: _errorMessage,
                    ),
                    SizedBox(height: 12.0),
                    _PasswordInputField(
                      controller: _passwordController,
                      isLoading: _isLoading,
                      errorMessage: _errorMessage,
                    ),
                    SizedBox(height: 24.0),
                    _LoginButton(isLoading: _isLoading, onPressed: _login),
                    SizedBox(height: 16.0),
                    const _ForgotPasswordLink(),
                    SizedBox(height: 12.0),
                    const _SignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir o alerta de erro
  Widget _buildErrorAlert() {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.red[100], // Cor de fundo do alerta
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.red[400]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600]),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Erro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

// Widget extraído para o campo de Email
class _EmailInputField extends StatelessWidget {
  const _EmailInputField({
    required this.controller,
    required this.isLoading,
    this.errorMessage,
  });

  final TextEditingController controller;
  final bool isLoading;
  final String? errorMessage;

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
        SizedBox(height: 4.0),
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
            fillColor: Colors.grey[300],
            filled: true,
            hintText: 'seuemail@exemplo.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            errorBorder: errorMessage != null
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[500]!),
                    borderRadius: BorderRadius.circular(5.0),
                  )
                : null,
            focusedErrorBorder: errorMessage != null
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[500]!),
                    borderRadius: BorderRadius.circular(5.0),
                  )
                : null,
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
            // Adicione a lógica para navegação para a tela de cadastro
            debugPrint('Cadastre-se');
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
  const _PasswordInputField({
    required this.controller,
    required this.isLoading,
    this.errorMessage,
  });

  final TextEditingController controller;
  final bool isLoading;
  final String? errorMessage;

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
        SizedBox(height: 4.0),
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
            fillColor: Colors.grey[300],
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
