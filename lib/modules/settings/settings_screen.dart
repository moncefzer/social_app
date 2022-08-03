import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_state.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(defaultRadius),
                              topRight: Radius.circular(defaultRadius),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(userModel!.coverImage),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          userModel.profileImage,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                userModel.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                userModel.bio,
                style: Theme.of(context).textTheme.caption,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              '100',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Posts',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              '256',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Photos',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              '64',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Followers',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              '150',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Following',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Add Photos'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      navigatoTo(context: context, widget: EditProfileScreen());
                    },
                    child: const Icon(
                      IconBroken.Edit,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          FirebaseMessaging.instance
                              .subscribeToTopic('announcement');
                        },
                        child: const Text('subscribe')),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          FirebaseMessaging.instance
                              .unsubscribeFromTopic('announcement');
                        },
                        child: const Text('unsubscribe')),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        signOut(context);
                      },
                      child: const Text('sign out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
