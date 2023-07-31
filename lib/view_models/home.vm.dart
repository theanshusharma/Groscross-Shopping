import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:groscross/constants/api.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/models/product.dart';
import 'package:groscross/models/service.dart';
import 'package:groscross/models/vendor.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/requests/product.request.dart';
import 'package:groscross/requests/service.request.dart';
import 'package:groscross/requests/vendor.request.dart';
import 'package:groscross/services/alert.service.dart';
import 'package:groscross/services/app.service.dart';
import 'package:groscross/services/auth.service.dart';
import 'package:groscross/services/cart.service.dart';
import 'package:groscross/services/local_storage.service.dart';
import 'package:groscross/services/navigation.service.dart';
import 'package:groscross/view_models/base.view_model.dart';
import 'package:groscross/views/pages/auth/login.page.dart';
import 'package:groscross/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:groscross/views/pages/product/product_details.page.dart';
import 'package:groscross/views/pages/service/service_details.page.dart';
import 'package:groscross/views/pages/vendor_details/vendor_details.page.dart';
import 'package:groscross/views/pages/welcome/welcome.page.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeViewModel extends MyBaseViewModel {
  //
  HomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  int currentIndex = 0;
  PageController pageViewController = PageController(initialPage: 0);
  int totalCartItems = 0;
  StreamSubscription? homePageChangeStream;
  Widget homeView = WelcomePage();

  @override
  void initialise() async {
    //
    handleAppLink();

    //determine if homeview should be multiple vendor types or single vendor page
    if (AppStrings.isSingleVendorMode) {
      VendorType vendorType = VendorType.fromJson(AppStrings.enabledVendorType);
      homeView = NavigationService.vendorTypePage(
        vendorType,
        context: viewContext,
      );
      //require login
      if (vendorType.authRequired && !AuthServices.authenticated()) {
        await viewContext.push(
          (context) => LoginPage(
            required: true,
          ),
        );
      }
      notifyListeners();
    }

    //start listening to changes to items in cart
    LocalStorageService.rxPrefs?.getIntStream(CartServices.totalItemKey).listen(
      (total) {
        if (total != null) {
          totalCartItems = total;
          notifyListeners();
        }
      },
    );

    //
    homePageChangeStream = AppService().homePageIndex.stream.listen(
      (index) {
        //
        onTabChange(index);
      },
    );
  }

  //
  // dispose() {
  //   super.dispose();
  //   homePageChangeStream.cancel();
  // }

  //
  onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  //
  onTabChange(int index) {
    try {
      currentIndex = index;
      pageViewController.animateToPage(
        currentIndex,
        duration: Duration(microseconds: 5),
        curve: Curves.bounceInOut,
      );
    } catch (error) {
      print("error ==> $error");
    }
    notifyListeners();
  }

  //
  handleAppLink() async {
    // Get any initial links
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    //
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      openPageByLink(deepLink);
    }

    //
    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) {
        //
        openPageByLink(dynamicLinkData.link);
      },
    ).onError(
      (error) {
        // Handle errors
        print("error opening link ==> $error");
      },
    );
  }

  //
  openPageByLink(Uri deepLink) async {
    final cleanLink = Uri.decodeComponent(deepLink.toString());
    if (cleanLink.contains(Api.appShareLink)) {
      //
      try {
        final linkFragments = cleanLink.split(Api.appShareLink);
        final dataSection = linkFragments[1];
        final pathFragments = dataSection.split("/");
        final dataId = pathFragments[pathFragments.length - 1];

        if (dataSection.contains("product")) {
          Product product = Product.fromJson({"id": int.parse(dataId)});
          ProductRequest _productRequest = ProductRequest();
          AlertService.showLoading();
          product = await _productRequest.productDetails(product.id);
          AlertService.stopLoading();
          if (!product.vendor.vendorType.slug.contains("commerce")) {
            viewContext.push(
              (context) => ProductDetailsPage(
                product: product,
              ),
            );
          } else {
            viewContext.push(
              (context) => AmazonStyledCommerceProductDetailsPage(
                product: product,
              ),
            );
          }
        } else if (dataSection.contains("vendor")) {
          Vendor vendor = Vendor.fromJson({"id": int.parse(dataId)});
          VendorRequest _vendorRequest = VendorRequest();
          AlertService.showLoading();
          vendor = await _vendorRequest.vendorDetails(vendor.id);
          AlertService.stopLoading();
          viewContext.push(
            (context) => VendorDetailsPage(
              vendor: vendor,
            ),
          );
        } else if (dataSection.contains("service")) {
          Service service = Service.fromJson({"id": int.parse(dataId)});
          ServiceRequest _serviceRequest = ServiceRequest();
          AlertService.showLoading();
          service = await _serviceRequest.serviceDetails(service.id);
          AlertService.stopLoading();
          viewContext.push(
            (context) => ServiceDetailsPage(service),
          );
        }
      } catch (error) {
        AlertService.stopLoading();
        toastError("$error");
      }
    }
    print("Url Link ==> $cleanLink");
  }
}
