import 'package:friendfit_ready/ViewModels/ArticleViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/MainPageViewModel.dart';
import 'package:friendfit_ready/ViewModels/ProfileViewModel.dart';
import 'package:friendfit_ready/ViewModels/RecipeViewModel.dart';
import 'package:friendfit_ready/ViewModels/NotificationViewModel.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:friendfit_ready/services/BlogRequest/BlogRequestService_Impl.dart';
import 'package:friendfit_ready/services/FriendRequest/FriendRequestService_Impl.dart';
import 'package:friendfit_ready/services/FriendRequest/FriendRequestService.dart';
import 'package:friendfit_ready/services/RecipeRequest/RecipeRequestService.dart';
import 'package:friendfit_ready/services/RecipeRequest/RecipeRequestService_Impl.dart';
import 'package:friendfit_ready/services/navigationService.dart';
import 'package:get_it/get_it.dart';
import 'BlogRequest/BlogRequestService.dart';
import 'TaskRequest/TaskRequestService.dart';
import 'TaskRequest/TaskRequestService_Impl.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator
      .registerLazySingleton<FriendRequestService>(() => FriendRequestImpl());
  serviceLocator.registerLazySingleton<BlogRequestService>(
      () => BlogRequestServiceImpl());
  serviceLocator.registerLazySingleton<RecipeRequestService>(
      () => RecipeRequestServiceImpl());
  serviceLocator.registerLazySingleton<TaskRequestService>(
      () => TaskRequestServiceImpl());

  serviceLocator.registerFactory<ProfileViewModel>(() => ProfileViewModel());
  serviceLocator.registerFactory<MainPageViewModel>(() => MainPageViewModel());
  serviceLocator.registerFactory<ArticleViewModel>(() => ArticleViewModel());
  serviceLocator.registerFactory<RecipeViewModel>(() => RecipeViewModel());
  serviceLocator.registerFactory<DietTaskViewModel>(() => DietTaskViewModel());
  serviceLocator.registerFactory<DietGameViewModel>(() => DietGameViewModel());
  serviceLocator.registerFactory<StepViewModel>(() => StepViewModel());
  serviceLocator
      .registerFactory<NotificationViewModel>(() => NotificationViewModel());

  serviceLocator.registerLazySingleton(() => NavigationService());
}
