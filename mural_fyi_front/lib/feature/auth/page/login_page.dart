import 'package:flutter/material.dart';

import '../view/auth_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.viewModel, super.key});

  final AuthViewModel viewModel;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final loggedIn = await widget.viewModel.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;

    if (loggedIn) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login administrativo')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, child) => Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 40),
                        const SizedBox(height: 12),
                        Text('Acesso de administrador',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Usuário',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Informe seu usuário'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              tooltip: 'Mostrar ou ocultar senha',
                              onPressed: () => setState(() {
                                _showPassword = !_showPassword;
                              }),
                              icon: Icon(_showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Informe sua senha'
                              : null,
                        ),
                        if (widget.viewModel.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            widget.viewModel.errorMessage!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: widget.viewModel.isLoading ? null : _submit,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(widget.viewModel.isLoading
                                ? 'Autenticando...'
                                : 'Entrar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}