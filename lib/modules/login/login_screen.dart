import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/login/cubit/login_state.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/styles.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigatoAndFinish(context: context, widget: HomeLayout());
            });
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'email must not be empty';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          isPassword: cubit.isPassword,
                          suffix: cubit.suffixIcon,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'password must not be empty';
                            } else if (value.length < 4) {
                              return 'password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                            text: 'LOGIN',
                          ),
                          fallback: (context) => buildLoadingIndicator(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Dont\'t have an account'),
                            defaultTextButton(
                              onPressed: () {
                                navigatoTo(
                                  context: context,
                                  widget: RegisterScreen(),
                                );
                              },
                              text: 'register',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
