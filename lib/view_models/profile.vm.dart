import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:custom_faqs/custom_faqs.dart';
import 'package:flutter/material.dart';
import 'package:groscross/extensions/dynamic.dart';
import 'package:groscross/view_models/payment.view_model.dart';
import 'package:groscross/views/pages/loyalty/loyalty_point.page.dart';
import 'package:groscross/views/pages/profile/account_delete.page.dart';
import 'package:groscross/views/pages/splash.page.dart';
import 'package:groscross/constants/api.dart';
import 'package:groscross/constants/app_routes.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/models/user.dart';
import 'package:groscross/requests/auth.request.dart';
import 'package:groscross/services/auth.service.dart';
import 'package:groscross/widgets/bottomsheets/referral.bottomsheet.dart';
import 'package:groscross/widgets/cards/language_selector.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:share/share.dart';

class ProfileViewModel extends PaymentViewModel {
  //
  String appVersionInfo = "";
  bool authenticated = false;
  User? currentUser;

  //
  AuthRequest _authRequest = AuthRequest();
  StreamSubscription? authStateListenerStream;

  ProfileViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    appVersionInfo = "$versionName($versionCode)";
    authenticated = await AuthServices.authenticated();
    if (authenticated) {
      currentUser = await AuthServices.getCurrentUser(force: true);
    } else {
      listenToAuthChange();
    }
    notifyListeners();
  }

  dispose() {
    super.dispose();
    authStateListenerStream?.cancel();
  }

  listenToAuthChange() {
    authStateListenerStream?.cancel();
    authStateListenerStream =
        AuthServices.listenToAuthState().listen((event) async {
      if (event != null && event) {
        authenticated = event;
        currentUser = await AuthServices.getCurrentUser(force: true);
        notifyListeners();
        authStateListenerStream?.cancel();
      }
    });
  }

  /**
   * Edit Profile
   */

  openEditProfile() async {
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.editProfileRoute,
    );

    if (result != null && result is bool && result) {
      initialise();
    }
  }

  /**
   * Change Password
   */

  openChangePassword() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.changePasswordRoute,
    );
  }

//
  openRefer() async {
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReferralBottomsheet(this),
    );
  }

  //
  openLoyaltyPoint() {
    viewContext.nextPage(LoyaltyPointPage());
  }

  openWallet() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.walletRoute,
    );
  }

  /**
   * Delivery addresses
   */
  openDeliveryAddresses() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.deliveryAddressesRoute,
    );
  }

  //
  openFavourites() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.favouritesRoute,
    );
  }

  /**
   * Logout
   */
  logoutPressed() async {
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Logout".tr(),
      text: "Are you sure you want to logout?".tr(),
      onConfirmBtnTap: () {
        viewContext.pop();
        processLogout();
      },
    );
  }

  void processLogout() async {
    //
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.loading,
      title: "Logout".tr(),
      text: "Logging out Please wait...".tr(),
      barrierDismissible: false,
    );

    //
    final apiResponse = await _authRequest.logoutRequest();

    //
    viewContext.pop();

    if (!apiResponse.allGood) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Logout".tr(),
        text: apiResponse.message,
      );
    } else {
      //
      await AuthServices.logout();
      Navigator.of(viewContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false,
      );
    }
  }

  openNotification() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.notificationsRoute,
    );
  }

  /**
   * App Rating & Review
   */
  openReviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (Platform.isAndroid) {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    } else if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    }
  }

  //
  openPrivacyPolicy() async {
    final url = Api.privacyPolicy;
    openWebpageLink(url);
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  openFaqs() {
    viewContext.nextPage(
      CustomFaqPage(
        title: 'Faqs'.tr(),
        link: Api.baseUrl + Api.faqs,
      ),
    );
  }

  //
  openContactUs() async {
    final url = Api.contactUs;
    openWebpageLink(url);
  }

  openLivesupport() async {
    final url = Api.inappSupport;
    openWebpageLink(url);
  }

  //
  changeLanguage() async {
    final result = await showModalBottomSheet(
      context: viewContext,
      builder: (context) {
        return AppLanguageSelector();
      },
    );

    //
    if (result != null) {
      //pop all screen and open splash screen
      Navigator.of(viewContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false,
      );
    }
  }

  openLogin() async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.loginRoute,
    );
    //
    initialise();
  }

  void shareReferralCode() {
    Share.share(
      "%s is inviting you to join %s via this referral code: %s".tr().fill(
            [
              currentUser!.name,
              AppStrings.appName,
              currentUser!.code,
            ],
          ) +
          "\n" +
          AppStrings.androidDownloadLink +
          "\n" +
          AppStrings.iOSDownloadLink +
          "\n",
    );
  }

  //
  deleteAccount() {
    viewContext.nextPage(AccountDeletePage());
  }
}
