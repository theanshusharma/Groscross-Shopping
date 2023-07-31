import 'package:flutter/material.dart';
import 'package:groscross/models/service.dart';
import 'package:groscross/models/vendor.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:groscross/requests/service.request.dart';
import 'package:groscross/view_models/base.view_model.dart';

class ServiceVendorDetailsViewModel extends MyBaseViewModel {
  //
  ServiceVendorDetailsViewModel(BuildContext context, this.vendor) {
    this.viewContext = context;
  }

  //
  ServiceRequest _serviceRequest = ServiceRequest();
  Vendor? vendor;

  List<Service> services = [];

  //
  void getVendorServices() async {
    //
    setBusy(true);

    try {
      services = await _serviceRequest.getServices(
        queryParams: {
          "vendor_id": vendor?.id,
        },
        page: 0,
      );
      //
    } catch (error) {
      print("Services error ==> $error");
    }

    //
    setBusy(false);
  }
}
