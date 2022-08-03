import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_state.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var posts = AppCubit.get(context).posts;
        return ConditionalBuilder(
          condition:
              posts.isNotEmpty && AppCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  elevation: defaultElevation,
                  margin: const EdgeInsets.all(defaultMarging),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image.network(
                        'https://img.freepik.com/free-photo/joyous-small-female-child-raises-clenched-fists-rejoices-successful-swimming-wears-goggles-bright-clothes-has-toothy-smile-enjoys-her-favourite-hobby-during-summer-holiday-happy-childhood_273609-27857.jpg?w=1060&t=st=1659201650~exp=1659202250~hmac=30c529349e2886af8e69c739214233c0c8b97a9d88eb29e3288652ac12c9e713',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(defaultMarging),
                        child: Text(
                          'communicate with friends',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ), //
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildPostItem(context, posts[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: posts.length,
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          fallback: (context) => const LoadingIndicator(),
        );
      },
    );
  }

  Widget buildPostItem(context, PostModel model) => Card(
        elevation: defaultElevation,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(horizontal: defaultMarging),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(model.image),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              model.name,
                              style: const TextStyle(
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: const Icon(
                                Icons.check_circle,
                                color: socialAppPrimaryColor,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                        Text(
                          '${model.dateTime}',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 17,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                model.text,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(
                          end: 5,
                        ),
                        height: 25,
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 1,
                          height: 25,
                          padding: EdgeInsets.zero,
                          child: Text(
                            '#software',
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      color: socialAppPrimaryColor,
                                    ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.only(
                          end: 5,
                        ),
                        height: 25,
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 1,
                          height: 25,
                          padding: EdgeInsets.zero,
                          child: Text(
                            '#flutter',
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      color: socialAppPrimaryColor,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (model.postImage.isNotEmpty)
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(defaultRadius),
                      image: DecorationImage(
                        image: NetworkImage(
                          model.postImage,
                        ),
                        fit: BoxFit.cover,
                      )),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                IconBroken.Heart,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${model.nbLikes}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                IconBroken.Chat,
                                size: 16,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${model.nbComments} comment',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              Row(
                children: [
                  //todo : impliment the comments feature
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              AppCubit.get(context).userModel!.profileImage,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'write a comment ...',
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context).likePost(
                        postId: model.postId,
                        uId: AppCubit.get(context).userModel!.uId,
                        post: model,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
