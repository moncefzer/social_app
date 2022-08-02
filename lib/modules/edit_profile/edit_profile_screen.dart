import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_state.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? userModel = AppCubit.get(context).userModel;
        File? profileImage = AppCubit.get(context).profileImage;
        File? coverImage = AppCubit.get(context).coverImage;
        var cubit = AppCubit.get(context);
        if (userModel != null) {
          bioController.text = userModel.bio;
          nameController.text = userModel.name;
          phoneController.text = userModel.phone;
        }
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit profile',
            actions: [
              defaultTextButton(
                  text: 'update',
                  onPressed: () {
                    if (fromKey.currentState!.validate()) {
                      AppCubit.get(context).updateUserData(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text,
                      );
                    }
                  }),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: userModel != null,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: fromKey,
                  child: Column(
                    children: [
                      if (state is AppUpdateUserProfileLoadingState ||
                          state is AppStartUploadingImageState)
                        LinearProgressIndicator(),
                      if (state is AppUpdateUserProfileLoadingState ||
                          state is AppStartUploadingImageState)
                        SizedBox(height: 10),
                      Container(
                        height: 200,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft:
                                              Radius.circular(defaultRadius),
                                          topRight:
                                              Radius.circular(defaultRadius),
                                        ),
                                        image: DecorationImage(
                                          image: (coverImage == null)
                                              ? NetworkImage(
                                                  userModel!.coverImage)
                                              : FileImage(coverImage)
                                                  as ImageProvider,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      AppCubit.get(context).getCoverImage();
                                    },
                                    icon: const CircleAvatar(
                                      radius: 20,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 64,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey[400],
                                    backgroundImage: (profileImage == null)
                                        ? NetworkImage(userModel!.profileImage)
                                        : FileImage(profileImage)
                                            as ImageProvider,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    AppCubit.get(context).getProfileImage();
                                  },
                                  icon: const CircleAvatar(
                                    radius: 20,
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (profileImage != null || coverImage != null)
                        Row(
                          children: [
                            if (profileImage != null)
                              Expanded(
                                  child: defaultButton(
                                      function: () {
                                        cubit.updateProfileImage();
                                      },
                                      text: 'Update profile')),
                            SizedBox(
                              width: 5,
                            ),
                            if (coverImage != null)
                              Expanded(
                                  child: defaultButton(
                                      function: () {
                                        cubit.updateCoverImage();
                                      },
                                      text: 'Update cover')),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'name must not be empy';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: IconBroken.User,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: bioController,
                        type: TextInputType.name,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'bio must not be empy';
                          }
                          return null;
                        },
                        label: 'Bio',
                        prefix: IconBroken.Info_Circle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'phone must not be empy';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: IconBroken.Call,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => const LoadingIndicator(),
          ),
        );
      },
    );
  }
}
