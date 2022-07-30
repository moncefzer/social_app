abstract class AppState {}

class AppInitialState extends AppState {}

class AppGetUserLoadingState extends AppState {}

class AppGetUserSuccessState extends AppState {}

class AppGetUserErrorState extends AppState {
  final String error;

  AppGetUserErrorState(this.error);
}

class AppChangeBottomNavItemState extends AppState {}
