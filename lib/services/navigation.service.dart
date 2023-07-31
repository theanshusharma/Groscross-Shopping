import 'package:flutter/material.dart';
import 'package:groscross/models/product.dart';
import 'package:groscross/models/search.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/services/auth.service.dart';
import 'package:groscross/views/pages/auth/login.page.dart';
import 'package:groscross/views/pages/booking/booking.page.dart';
import 'package:groscross/views/pages/commerce/commerce.page.dart';
import 'package:groscross/views/pages/food/food.page.dart';
import 'package:groscross/views/pages/grocery/grocery.page.dart';
import 'package:groscross/views/pages/parcel/parcel.page.dart';
import 'package:groscross/views/pages/pharmacy/pharmacy.page.dart';
import 'package:groscross/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:groscross/views/pages/product/product_details.page.dart';
import 'package:groscross/views/pages/search/product_search.page.dart';
import 'package:groscross/views/pages/search/search.page.dart';
import 'package:groscross/views/pages/search/service_search.page.dart';
import 'package:groscross/views/pages/service/service.page.dart';
import 'package:groscross/views/pages/taxi/taxi.page.dart';
import 'package:groscross/views/pages/vendor/vendor.page.dart';
import 'package:velocity_x/velocity_x.dart';

class NavigationService {
  static pageSelected(
    VendorType vendorType, {
    required BuildContext context,
    bool loadNext = true,
  }) async {
    Widget nextpage = vendorTypePage(
      vendorType,
      context: context,
    );

    //
    if (vendorType.authRequired && !AuthServices.authenticated()) {
      final result = await context.push(
        (context) => LoginPage(
          required: true,
        ),
      );
      //
      if (result == null || !result) {
        return;
      }
    }
    //
    if (loadNext) {
      context.nextPage(nextpage);
    }
  }

  static Widget vendorTypePage(
    VendorType vendorType, {
    required BuildContext context,
  }) {
    Widget homeView = VendorPage(vendorType);
    switch (vendorType.slug) {
      case "parcel":
        homeView = ParcelPage(vendorType);
        break;
      case "grocery":
        homeView = GroceryPage(vendorType);
        break;
      case "food":
        homeView = FoodPage(vendorType);
        break;
      case "pharmacy":
        homeView = PharmacyPage(vendorType);
        break;
      case "service":
        homeView = ServicePage(vendorType);
        break;
      case "booking":
        homeView = BookingPage(vendorType);
        break;
      case "taxi":
        homeView = TaxiPage(vendorType);
        break;
      case "commerce":
        homeView = CommercePage(vendorType);
        break;
      default:
        homeView = VendorPage(vendorType);
        break;
    }
    return homeView;
  }

  ///special for product page
  Widget productDetailsPageWidget(Product product) {
    if (!product.vendor.vendorType.isCommerce) {
      return ProductDetailsPage(
        product: product,
      );
    } else {
      return AmazonStyledCommerceProductDetailsPage(
        product: product,
      );
    }
  }

  //
  Widget searchPageWidget(Search search) {
    if (search.vendorType == null) {
      return SearchPage(search: search);
    }
    //
    if (search.vendorType!.isProduct) {
      return ProductSearchPage(search: search);
    } else if (search.vendorType!.isService) {
      return ServiceSearchPage(search: search);
    } else {
      return SearchPage(search: search);
    }
  }
}
