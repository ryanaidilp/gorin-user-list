import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:user_list_task/base/base_state.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/messenger/messenger.dart';
import 'package:user_list_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:user_list_task/router/app_router.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  void _loginStateListener(AuthProvider provider, BuildContext context) {
    final loginState = provider.loginState;

    if (loginState.status == DataStatus.error) {
      getIt<MessengerService>().showPersistentSnackbar(
        context: context,
        message: loginState.message ?? '',
        state: SnackbarState.error,
      );
    } else if (loginState.status == DataStatus.success) {
      getIt<MessengerService>().showPersistentSnackbar(
        context: context,
        message: 'Logged in, welcome ${provider.loginState.data?.name}!',
        state: SnackbarState.success,
      );
      provider.reset();
      context.router.replaceAll([const HomeRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactiveFormBuilder(
        form: () => FormGroup(
          {
            'email': FormControl<String>(
              validators: [
                Validators.required,
                Validators.email,
              ],
            ),
            'password': FormControl<String>(
              validators: [
                Validators.required,
                Validators.minLength(8),
              ],
            ),
          },
        ),
        builder: (_, form, __) => Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              const Gap(16),
              const Text(
                'Login with Email',
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Email Address',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => form.control('password').focus(),
                validationMessages: {
                  ValidationMessage.required: (err) => 'Email is required!',
                  ValidationMessage.email: (err) => 'Email is not valid!',
                },
              ),
              const Gap(16),
              ReactiveTextField<String>(
                formControlName: 'password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Password',
                ),
                validationMessages: {
                  ValidationMessage.required: (err) => 'Password is required!',
                  ValidationMessage.minLength: (err) => 'Password must be at '
                      'least ${(err as Map)['requiredLength']} characters!',
                },
              ),
              const Gap(16),
              ReactiveFormConsumer(
                builder: (_, formGroup, __) {
                  return Consumer<AuthProvider>(
                    builder: (_, provider, __) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _loginStateListener(
                          provider,
                          context,
                        ),
                      );
                      return ElevatedButton(
                        onPressed: provider.loginState.status !=
                                    DataStatus.loading &&
                                formGroup.valid
                            ? () => provider.login(
                                  email: form.control('email').value.toString(),
                                  password:
                                      form.control('password').value.toString(),
                                )
                            : null,
                        child: provider.loginState.status != DataStatus.loading
                            ? const Text('Login')
                            : const SpinKitFadingCircle(
                                size: 20,
                                color: Colors.blueAccent,
                              ),
                      );
                    },
                  );
                },
              ),
              const Gap(24),
              const Text(
                'Doesn`t have an account?',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => context.router.push(const SignUpRoute()),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
