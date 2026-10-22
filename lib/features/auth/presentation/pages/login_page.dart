import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../domain/value_objects/password.dart';
import '../../domain/value_objects/username.dart';
import '../../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  // final _email = TextEditingController();
  final _password = TextEditingController();

  // Guard against re-pushing TaskListPage on rebuilds. pushReplacement
  // removes this page from the navigator, so the listener is also
  // disposed and this flag is reset the next time the page is built
  // (e.g. after a logout).
  bool _navigated = false;

  // Re-validate as the user types so the UI updates live.
  void _onUsernameChanged() => setState(() {});
  // void _onEmailChanged() => setState(() {});
  void _onPasswordChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _username.addListener(_onUsernameChanged);
    // _email.addListener(_onEmailChanged);
    _password.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _username.removeListener(_onUsernameChanged);
    // _email.removeListener(_onEmailChanged);
    _password.removeListener(_onPasswordChanged);
    _username.dispose();
    // _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Build a fresh Email/Password from the current text to drive both the
  // form validators and the submit-button enabled state.
  Username get _usernameVO => Username(_username.text);
  // Email get _emailVO => Email(_email.text);
  Password get _passwordVO => Password(_password.text);
  bool get _isFormValid => _usernameVO.isValid && _passwordVO.isValid;
  // bool get _isFormValid => _emailVO.isValid && _passwordVO.isValid;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final usernameVO = _usernameVO;
    // final emailVO = _emailVO;
    final passwordVO = _passwordVO;
    if (!usernameVO.isValid || !passwordVO.isValid) return;
    // if (!emailVO.isValid || !passwordVO.isValid) return;

    await ref
        .read(authControllerProvider.notifier)
        .login(username: usernameVO.value, password: passwordVO.value);
    // .login(email: emailVO.value, password: passwordVO.value);
  }

  /// When the controller's state flips to a logged-in [User], push the
  /// TaskListPage as a replacement so the login screen is removed from
  /// the stack and Back doesn't return to it.
  void _handleAuthStateChange(AsyncValue<dynamic> next) {
    if (_navigated) return;
    final data = next.asData?.value;
    final user = data?.user;
    if (user == null) return;

    _navigated = true;
    context.goNamed(Routes.todo);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for login completion and route on success.
    ref.listen<AsyncValue<dynamic>>(
      authControllerProvider,
      (_, next) => _handleAuthStateChange(next),
    );
    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _username,
                keyboardType: TextInputType.name,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (_) => _usernameVO.error,
                // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              //   controller: _email,
              //   keyboardType: TextInputType.emailAddress,
              //   autocorrect: false,
              //   textInputAction: TextInputAction.next,
              //   decoration: const InputDecoration(
              //     labelText: 'Email',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (_) => _emailVO.error,
              //   onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              // ),
              // const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (_) => _passwordVO.error,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (isLoading || !_isFormValid) ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
              const SizedBox(height: 16),
              _StatusMessage(state: state),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.state});

  final AsyncValue<dynamic> state;

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const SizedBox.shrink(),
      error: (err, _) => Text(
        err.toString(),
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      data: (s) {
        final user = s.user;
        if (user != null) {
          return Text('Welcome: ${user.email}');
        }
        final failure = s.failure;
        if (failure != null) {
          return Text(
            failure.message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
