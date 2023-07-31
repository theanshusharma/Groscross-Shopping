import 'package:flutter/cupertino.dart';
import 'package:groscross/constants/app_routes.dart';
import 'package:groscross/models/notification.dart';
import 'package:groscross/services/notification.service.dart';
import 'package:groscross/view_models/base.view_model.dart';

class NotificationsViewModel extends MyBaseViewModel {
  //
  List<NotificationModel> notifications = [];

  NotificationsViewModel(BuildContext context) {
    this.viewContext = context;
  }

  @override
  void initialise() async {
    super.initialise();

    //getting notifications
    getNotifications();
  }

  //
  void getNotifications() async {
    notifications = await NotificationService.getNotifications();
    notifyListeners();
  }

  //
  void showNotificationDetails(NotificationModel notificationModel) async {
    //
    notificationModel.read = true;
    NotificationService.updateNotification(notificationModel);

    //
    await Navigator.pushNamed(
      viewContext,
      AppRoutes.notificationDetailsRoute,
      arguments: notificationModel,
    );

    //
    getNotifications();
  }
}
