import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/app_state.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/remote/firestore_helper.dart';
import 'package:uuid/uuid.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(UID).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    const SizedBox.shrink(), // this is just made to occupy the 2nd index
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = ['Home', 'Chats', 'Post', 'Users', 'Settings'];
  int currentIndex = 0;
  void changeNavItem(int index) {
    if (index == 0 && posts.isEmpty) getPosts();
    if (index == 1) getAllUser();
    if (index == 2) {
      emit(AppNewPostState());
    } else {
      currentIndex = index;
      emit(AppChangeBottomNavItemState());
    }
  }

  ///we user FileImage() to display this image
  File? profileImage;
  File? coverImage;

  Future getProfileImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      print('no image picked');
      emit(AppProfileImagePickedErrorState());
    }
  }

  Future getCoverImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      coverImage = File(pickedImage.path);
      emit(AppCoverImagePickedSuccessState());
    } else {
      print('no image picked');
      emit(AppCoverImagePickedErrorState());
    }
  }

  void updateProfileImage() {
    if (profileImage != null) {
      emit(AppStartUploadingImageState());
      FirestoreHelper.uploadImage('users', profileImage!).then((value) {
        updateUserData(
          name: userModel!.name,
          phone: userModel!.phone,
          bio: userModel!.bio,
          profile: value, // url returned from the uploaded image on firestore
        );
        profileImage = null;
      }).catchError((error) {
        print(error.toString());
        emit(AppUpdateProfileImageErrorState());
      });
    }
  }

  void updateCoverImage() {
    if (coverImage != null) {
      emit(AppStartUploadingImageState());
      FirestoreHelper.uploadImage('users', coverImage!).then((value) {
        updateUserData(
          name: userModel!.name,
          phone: userModel!.phone,
          bio: userModel!.bio,
          cover: value, // url returned from the uploaded image on firestore
        );
        coverImage = null;
      }).catchError((error) {
        print(error.toString());
        emit(AppUpdateCoverImageErrorState());
      });
    }
  }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? profile,
  }) {
    emit(AppUpdateUserProfileLoadingState());
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      profileImage: profile ?? userModel!.profileImage,
      coverImage: cover ?? userModel!.coverImage,
      isEmailVerified: userModel!.isEmailVerified,
      email: userModel!.email,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      print(error.toString());
      emit(AppUpdateUserProfileErrorState());
    });
  }

  File? postImage;

  Future getPostImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      postImage = File(pickedImage.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      print('no image picked');
      emit(AppPostImagePickedErrorState());
    }
  }

  void createNewPost({
    required String name,
    required String uId,
    required String image,
    required String dateTime,
    required String text,
  }) {
    emit(AppCreatePostLoadingState());
    FirestoreHelper.uploadImage('posts', postImage).then((value) async {
      await addPostToFireStore(
        name: name,
        uId: uId,
        image: image,
        dateTime: dateTime,
        text: text,
        postImage: value,
      );
      postImage = null;
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(AppRemovePostImageState());
  }

  Future addPostToFireStore({
    required String name,
    required String uId,
    required String image,
    required String dateTime,
    required String text,
    String? postImage,
  }) async {
    var uui = const Uuid();
    String postId = uui.v1();
    PostModel model = PostModel(
      postId: postId,
      name: name,
      uId: uId,
      image: image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
      nbComments: 0,
      nbLikes: 0,
    );
    return await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .set(model.toMap());
  }

  List<PostModel> posts = [];

  void getPosts() {
    ///realtime posts
    emit(AppGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      print('get posts');
      posts = [];
      for (int i = 0; i < event.docs.length; i++) {
        posts.add(PostModel.fromJson(event.docs[i].data()));
      }
      emit(AppGetPostsSuccessState());
    });

    /// get in the launching of the app
    // emit(AppGetPostsLoadingState());
    // FirebaseFirestore.instance
    //     .collection('posts')
    //     .orderBy('dateTime', descending: true)
    //     .get()
    //     .then((value) {
    //   for (int i = 0; i < value.docs.length; i++) {
    //     posts.add(PostModel.fromJson(value.docs[i].data()));
    //   }
    //   emit(AppGetPostsSuccessState());
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(AppGetPostsErrorState(error.toString()));
    // });
  }

  void likePost({
    required String postId,
    required String uId,
    required PostModel post,
  }) {
    var likeDocument = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId) // .set({'like': true})
        .collection('likes')
        .doc(uId);
    var postDocument =
        FirebaseFirestore.instance.collection('posts').doc(postId);
    WriteBatch batch = FirebaseFirestore.instance.batch();

    FirebaseFirestore.instance.runTransaction((transaction) async {
      // read if this like already exist
      DocumentSnapshot docsnap = await transaction.get(likeDocument);

      if (docsnap.exists) {
        ///remove the like
        transaction.delete(likeDocument); // add this like to likes collection
        transaction.update(postDocument,
            {'nbLikes': --post.nbLikes}); //inc nbLikes for the post
      } else {
        /// increment the likes
        transaction.set(
            likeDocument, {'likes': true}); // add this like to likes collection
        transaction.update(postDocument,
            {'nbLikes': ++post.nbLikes}); //inc nbLikes for the post
      }
    }).then((value) {
      emit(AppLikePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppLikePostErrorState(error.toString()));
    });

    ///old way with batches
    // batch.set(
    //     likeDocument, {'likes': true}); // add this like to likes collection
    // batch.update(
    //     postDocument, {'nbLikes': nbLikes + 1}); //inc nbLikes for the post
    //
    // batch.commit().then((value) {
    //   emit(AppLikePostSuccessState());
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(AppLikePostErrorState(error.toString()));
    // });
  }

  List<UserModel> allUsers = [];

  void getAllUser() {
    emit(AppGetAllUsersLoadingState());
    allUsers = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].data()['uId'] != userModel!.uId) {
          allUsers.add(UserModel.fromJson(value.docs[i].data()));
        }
      }
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    var uuid = const Uuid();
    String randomId = uuid.v1();
    DocumentReference myChat = FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(randomId);
    DocumentReference otherChat = FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .doc(randomId);

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.set(myChat, messageModel.toMap());
    batch.set(otherChat, messageModel.toMap());
    batch.commit().then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppSendMessageErrorState(error.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getMessage({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      for (int i = 0; i < event.docs.length; i++) {
        messages.add(MessageModel.fromJson(event.docs[i].data()));
      }

      emit(AppGetAllMessagesSuccessState());
    });
  }
}
