import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/requests/vendor_type.request.dart';
import 'package:groscross/services/auth.service.dart';
import 'package:groscross/view_models/base.view_model.dart';

class WelcomeViewModel extends MyBaseViewModel {
  //
  WelcomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  Widget? selectedPage;
  List<VendorType> vendorTypes = [];
  VendorTypeRequest vendorTypeRequest = VendorTypeRequest();
  bool showGrid = true;
  StreamSubscription? authStateSub;

  //
  //
  initialise({bool initial = true}) async {
    //
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }

    if (!initial) {
      pageKey = GlobalKey();
      notifyListeners();
    }

    await getVendorTypes();
    listenToAuth();
  }

  listenToAuth() {
    authStateSub = AuthServices.listenToAuthState().listen((event) {
      genKey = GlobalKey();
      notifyListeners();
    });
  }

  getVendorTypes() async {
    setBusy(true);
    try {
      vendorTypes = await vendorTypeRequest.index();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }
}
