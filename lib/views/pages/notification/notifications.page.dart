import 'package:flutter/material.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/notifications.vm.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:groscross/widgets/custom_list_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groscross/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationsViewModel>.reactive(
      viewModelBuilder: () => NotificationsViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Notifications".tr(),
          body: SafeArea(
            child: CustomListView(
              dataSet: model.notifications,
              emptyWidget: EmptyState(
                title: "No Notifications".tr(),
                description:
                    "You dont' have notifications yet. When you get notifications, they will appear here"
                        .tr(),
              ),
              itemBuilder: (context, index) {
                //
                final notification = model.notifications[index];
                return VStack(
                  [
                    //title
                    "${notification.title}"
                        .text
                        .bold
                        .fontFamily(GoogleFonts.nunito().fontFamily!)
                        .make(),
                    //time
                    notification.formattedTimeStamp.text.medium
                        .color(Colors.grey)
                        .fontFamily(GoogleFonts.nunito().fontFamily!)
                        .make()
                        .pOnly(bottom: 5),
                    //body
                    "${notification.body}"
                        .text
                        .maxLines(1)
                        .overflow(TextOverflow.ellipsis)
                        .fontFamily(GoogleFonts.nunito().fontFamily!)
                        .make(),
                  ],
                )
                    .px20()
                    .py12()
                    .box
                    .color((notification.read ?? false)
                        ? context.cardColor
                        : context.canvasColor)
                    .make()
                    .onInkTap(() {
                  model.showNotificationDetails(notification);
                });
              },
              separatorBuilder: (context, index) => UiSpacer.divider(),
            ),
          ),
        );
      },
    );
  }
}
