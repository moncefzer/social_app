import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_state.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class NewPostScreen extends StatelessWidget {
  TextEditingController postController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppCreatePostSuccessState) {
          showToast(
              text: 'post added successfully', state: ToastStates.SUCCESS);
          postController.clear();
        }
        if (state is AppCreatePostErrorState) {
          showToast(text: 'an error happened', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        UserModel? userModel = cubit.userModel;
        var postImage = cubit.postImage;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var now = DateTime.now();
                      cubit.createNewPost(
                        name: userModel!.name,
                        uId: userModel.uId,
                        image: userModel.profileImage,
                        dateTime: now.toString(),
                        text: postController.text,
                      );
                    }
                  },
                  text: 'Post'),
              const SizedBox(
                width: 5,
              )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(defaultPadding,
                      defaultPadding, defaultPadding, defaultPadding + 5),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state is AppCreatePostLoadingState)
                          const LinearProgressIndicator(),
                        if (state is AppCreatePostLoadingState)
                          const SizedBox(
                            height: 10,
                          ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(userModel!.profileImage),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                userModel.name,
                                style: TextStyle(
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: postController,
                            decoration: const InputDecoration(
                              hintText: 'what is on your mind',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty && cubit.postImage == null) {
                                return "please insert a text or add a photo";
                              }
                              return null;
                            },
                          ),
                        ),
                        if (postImage != null)
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: FileImage(postImage),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.removePostImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Close_Square,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  cubit.getPostImage();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(IconBroken.Camera),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text('add photo'),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('#tags',
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
