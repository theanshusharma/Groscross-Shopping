import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:groscross/constants/app_colors.dart';
import 'package:groscross/constants/app_ui_settings.dart';
import 'package:groscross/constants/app_upgrade_settings.dart';
import 'package:groscross/services/location.service.dart';
import 'package:groscross/views/pages/profile/profile.page.dart';
import 'package:groscross/view_models/home.vm.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';

import 'order/orders.page.dart';
import 'search/main_search.page.dart';
import 'welcome/widgets/cart.fab.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        LocationService.prepareLocationListener();
        vm.initialise();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => vm,
        builder: (context, model, child) {
          return BasePage(
            body: UpgradeAlert(
              upgrader: Upgrader(
                showIgnore: !AppUpgradeSettings.forceUpgrade(),
                shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: PageView(
                controller: model.pageViewController,
                onPageChanged: model.onPageChanged,
                children: [
                  model.homeView,
                  OrdersPage(),
                  MainSearchPage(),
                  ProfilePage(),
                ],
              ),
            ),
            fab: AppUISettings.showCart ? CartHomeFab(model) : null,
            fabLocation: AppUISettings.showCart
                ? FloatingActionButtonLocation.centerDocked
                : null,
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
              itemCount: 4,
              backgroundColor: Theme.of(context).colorScheme.background,
              blurEffect: true,
              shadow: BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
              ),
              activeIndex: model.currentIndex,
              onTap: model.onTabChange,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 14,
              rightCornerRadius: 14,
              tabBuilder: (int index, bool isActive) {
                final color = isActive
                    ? AppColor.primaryColor
                    : Theme.of(context).textTheme.bodyLarge?.color;
                List<String> titles = [
                  "Home".tr(),
                  "Orders".tr(),
                  "Search".tr(),
                  "More".tr(),
                ];
                List<IconData> icons = [
                  FlutterIcons.home_ant,
                  FlutterIcons.inbox_ant,
                  FlutterIcons.search_fea,
                  FlutterIcons.menu_fea,
                ];

                Widget tab = Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      size: 20,
                      color: color,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: titles[index]
                          .text
                          .fontWeight(
                            isActive ? FontWeight.bold : FontWeight.normal,
                          )
                          .color(color)
                          .make(),
                    ),
                  ],
                );

                //
                return tab;
              },
            ),
            // child: SafeArea(
            //   child: GNav(
            //     gap: 8,
            //     activeColor: Colors.white,
            //     color: Theme.of(context).textTheme.bodyLarge?.color,
            //     iconSize: 20,
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //     duration: Duration(milliseconds: 250),
            //     tabBackgroundColor: Theme.of(context).colorScheme.secondary,
            //     tabs: [
            //       GButton(
            //         icon: FlutterIcons.home_ant,
            //         text: 'Home'.tr(),
            //       ),
            //       GButton(
            //         icon: FlutterIcons.inbox_ant,
            //         text: 'Orders'.tr(),
            //       ),
            //       GButton(
            //         icon: FlutterIcons.search_fea,
            //         text: 'Search'.tr(),
            //       ),
            //       GButton(
            //         icon: FlutterIcons.menu_fea,
            //         text: 'More'.tr(),
            //       ),
            //     ],
            //     selectedIndex: model.currentIndex,
            //     onTabChange: model.onTabChange,
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
