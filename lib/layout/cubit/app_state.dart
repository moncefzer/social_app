abstract class AppState {}

class AppInitialState extends AppState {}

//get user
class AppGetUserLoadingState extends AppState {}

class AppGetUserSuccessState extends AppState {}

class AppGetUserErrorState extends AppState {
  final String error;

  AppGetUserErrorState(this.error);
}

//get all users
class AppGetAllUsersLoadingState extends AppState {}

class AppGetAllUsersSuccessState extends AppState {}

class AppGetAllUsersErrorState extends AppState {
  final String error;

  AppGetAllUsersErrorState(this.error);
}

//get posts
class AppGetPostsLoadingState extends AppState {}

class AppGetPostsSuccessState extends AppState {}

class AppGetPostsErrorState extends AppState {
  final String error;

  AppGetPostsErrorState(this.error);
}

//like post

class AppLikePostSuccessState extends AppState {}

class AppLikePostErrorState extends AppState {
  final String error;

  AppLikePostErrorState(this.error);
}

//change navbar item
class AppChangeBottomNavItemState extends AppState {}

//open new post page
class AppNewPostState extends AppState {}

//pick image to update cover and profile images
class AppProfileImagePickedSuccessState extends AppState {}

class AppProfileImagePickedErrorState extends AppState {}

class AppCoverImagePickedSuccessState extends AppState {}

class AppCoverImagePickedErrorState extends AppState {}

//update the cover and profile images
class AppUpdateProfileImageErrorState extends AppState {}

class AppUpdateCoverImageErrorState extends AppState {}

class AppUpdateUserProfileLoadingState extends AppState {}

class AppUpdateUserProfileErrorState extends AppState {}

class AppStartUploadingImageState extends AppState {}

//create post
class AppCreatePostLoadingState extends AppState {}

class AppCreatePostSuccessState extends AppState {}

class AppCreatePostErrorState extends AppState {}

class AppPostImagePickedSuccessState extends AppState {}

class AppPostImagePickedErrorState extends AppState {}

class AppRemovePostImageState extends AppState {}

//send and get messages

class AppSendMessageSuccessState extends AppState {}

class AppSendMessageErrorState extends AppState {
  final String error;

  AppSendMessageErrorState(this.error);
}

class AppGetAllMessagesSuccessState extends AppState {}

class AppGetAllMessagesErrorState extends AppState {
  final String error;

  AppGetAllMessagesErrorState(this.error);
}
