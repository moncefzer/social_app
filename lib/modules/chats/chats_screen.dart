import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_state.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/styles.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var allUsers = AppCubit.get(context).allUsers;
        print(allUsers);
        return ConditionalBuilder(
          condition: allUsers.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(context, allUsers[index]),
            separatorBuilder: (context, index) => buildDivider(),
            itemCount: allUsers.length,
          ),
          fallback: (context) => const LoadingIndicator(),
        );
      },
    );
  }

  Widget buildChatItem(context, UserModel model) => InkWell(
        onTap: () {
          AppCubit.get(context).getMessage(receiverId: model.uId);
          navigatoTo(
              context: context, widget: ChatDetailsScreen(userModel: model));
        },
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(model.profileImage),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                model.name,
                style: const TextStyle(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}
