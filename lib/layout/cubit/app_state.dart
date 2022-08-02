abstract class AppState {}

class AppInitialState extends AppState {}

//get user
class AppGetUserLoadingState extends AppState {}

class AppGetUserSuccessState extends AppState {}

class AppGetUserErrorState extends AppState {
  final String error;

  AppGetUserErrorState(this.error);
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
