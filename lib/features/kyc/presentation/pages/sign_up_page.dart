import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:user_list_task/base/base_state.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/messenger/messenger.dart';
import 'package:user_list_task/features/kyc/presentation/providers/kyc_provider.dart';
import 'package:user_list_task/router/app_router.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final ValueNotifier<File?> _avatar;
  late final KYCProvider _provider;
  @override
  void initState() {
    super.initState();
    _provider = context.read<KYCProvider>();
    _provider.addListener(
      _registerStateListener,
    );
    _avatar = ValueNotifier(null);
  }

  void _registerStateListener() {
    final signUpState = Provider.of<KYCProvider>(
      context,
      listen: false,
    ).state;

    if (signUpState.status == DataStatus.error) {
      getIt<MessengerService>().showPersistentSnackbar(
        context: context,
        message: signUpState.message ?? '',
        state: SnackbarState.error,
      );
    } else if (signUpState.status == DataStatus.success) {
      getIt<MessengerService>().showPersistentSnackbar(
        context: context,
        message: 'Account registered, welcome ${signUpState.data?.name}!',
        state: SnackbarState.success,
      );
      _provider.reset();
      context.router.replaceAll([const HomeRoute()]);
    }
  }

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) {
      return;
    }

    final file = File(result.files.last.path ?? '');

    _avatar.value = file;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _provider.removeListener(
      _registerStateListener,
    );
    _avatar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactiveFormBuilder(
        form: () => FormGroup(
          {
            'name': FormControl<String>(
              validators: [
                Validators.required,
              ],
            ),
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
              GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey.shade100,
                  child: ValueListenableBuilder(
                    valueListenable: _avatar,
                    builder: (_, value, __) {
                      if (value != null) {
                        return ClipOval(
                          child: Image.file(
                            value,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                      return const Icon(
                        Icons.person_rounded,
                        size: 50,
                      );
                    },
                  ),
                ),
              ),
              const Gap(16),
              const Text(
                'Sign up with Email',
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              ReactiveTextField<String>(
                formControlName: 'name',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Name',
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => form.control('email').focus(),
                validationMessages: {
                  ValidationMessage.required: (err) => 'Name is required!',
                },
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
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
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
                  return Consumer<KYCProvider>(
                    builder: (_, provider, __) {
                      return ElevatedButton(
                        onPressed: provider.state.status !=
                                    DataStatus.loading &&
                                formGroup.valid &&
                                _avatar.value != null
                            ? () => provider.register(
                                  avatar: _avatar.value!,
                                  name: form.control('name').value.toString(),
                                  email: form.control('email').value.toString(),
                                  password:
                                      form.control('password').value.toString(),
                                )
                            : null,
                        child: provider.state.status != DataStatus.loading
                            ? const Text('Sign Up')
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
                'Already have an account?',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => context.router.pop(),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
