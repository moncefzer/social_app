import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_state.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel userModel;
  TextEditingController textController = TextEditingController();

  ChatDetailsScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(listener: (context, state) {
      if (state is AppSendMessageErrorState) {
        showToast(text: state.error, state: ToastStates.ERROR);
      }
    }, builder: (context, state) {
      var cubit = AppCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userModel.profileImage),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(userModel.name)
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
              defaultPadding, defaultPadding, defaultPadding, 10),
          child: Column(
            children: [
              Expanded(
                child: ConditionalBuilder(
                  condition: cubit.messages.isNotEmpty,
                  builder: (context) => ListView.separated(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (cubit.userModel!.uId ==
                          cubit.messages[index].senderId) {
                        return buildMyMessage(cubit.messages[index]);
                      } else {
                        return buildOtherMessage(cubit.messages[index]);
                      }
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemCount: cubit.messages.length,
                  ),
                  fallback: (context) => const LoadingIndicator(),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'type your message here',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: socialAppPrimaryColor,
                      height: 50,
                      child: MaterialButton(
                        minWidth: 1,
                        onPressed: () {
                          if (textController.text.isNotEmpty) {
                            cubit.sendMessage(
                              receiverId: userModel.uId,
                              dateTime: DateTime.now().toString(),
                              text: textController.text,
                            );
                            textController.clear();
                          }
                        },
                        child: const Icon(
                          IconBroken.Send,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget buildMyMessage(MessageModel messageModel) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: socialAppPrimaryColor.withOpacity(.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Text(
            messageModel.text,
          ),
        ),
      );
  Widget buildOtherMessage(MessageModel messageModel) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: const Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Text(
            messageModel.text,
          ),
        ),
      );
}
