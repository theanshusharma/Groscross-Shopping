import 'dart:async';

import 'package:flutter/material.dart';
import 'package:groscross/models/delivery_address.dart';
import 'package:groscross/models/user.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/services/auth.service.dart';
import 'package:groscross/services/location.service.dart';
import 'package:groscross/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class VendorViewModel extends MyBaseViewModel {
  //
  VendorViewModel(BuildContext context, VendorType vendorType) {
    this.viewContext = context;
    this.vendorType = vendorType;
  }
  //
  User? currentUser;
  StreamSubscription? currentLocationChangeStream;

  //
  int queryPage = 1;

  RefreshController refreshController = RefreshController();

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    //listen to user location change
    currentLocationChangeStream =
        LocationService.currenctAddressSubject.stream.listen(
      (location) {
        //
        deliveryaddress ??= DeliveryAddress();
        deliveryaddress!.address = location.addressLine;
        deliveryaddress!.latitude = location.coordinates?.latitude;
        deliveryaddress!.longitude = location.coordinates?.longitude;
        notifyListeners();
      },
    );
  }

  //switch to use current location instead of selected delivery address
  void useUserLocation() {
    LocationService.geocodeCurrentLocation();
  }

  //
  dispose() {
    super.dispose();
    currentLocationChangeStream?.cancel();
  }
}
