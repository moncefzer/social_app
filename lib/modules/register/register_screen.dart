import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/register/cubit/register_cubit.dart';
import 'package:social_app/modules/register/cubit/register_state.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/styles.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              UID = state.uId;
              navigatoAndFinish(context: context, widget: HomeLayout());
            }).catchError((error) {
              print(error.toString());
            });
            showToast(text: 'Logged successfully', state: ToastStates.SUCCESS);
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
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
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Register now to  communicate with friends',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                            return null;
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 10,
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
                          height: 10,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'phone must not be empty';
                            } else if (value.length < 4) {
                              return 'phone num is not valide';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.numbers,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          isPassword: cubit.isPassword,
                          suffix: cubit.passSuffixIcon,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              cubit.userRegister(
                                name: nameController.text,
                                phone: phoneController.text,
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
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                            text: 'REGISTER',
                          ),
                          fallback: (context) => buildLoadingIndicator(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
