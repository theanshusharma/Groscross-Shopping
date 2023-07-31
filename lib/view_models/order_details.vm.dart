import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';
import 'package:groscross/constants/app_routes.dart';
import 'package:groscross/extensions/dynamic.dart';
import 'package:groscross/models/api_response.dart';
import 'package:groscross/models/order.dart';
import 'package:groscross/models/payment_method.dart';
import 'package:groscross/requests/order.request.dart';
import 'package:groscross/services/app.service.dart';
import 'package:groscross/services/chat.service.dart';
import 'package:groscross/view_models/checkout_base.vm.dart';
import 'package:groscross/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:groscross/widgets/bottomsheets/driver_rating.bottomsheet.dart';
import 'package:groscross/widgets/bottomsheets/order_cancellation.bottomsheet.dart';
import 'package:groscross/widgets/bottomsheets/vendor_rating.bottomsheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetailsViewModel extends CheckoutBaseViewModel {
  //
  Order order;
  OrderRequest orderRequest = OrderRequest();

  //
  OrderDetailsViewModel(BuildContext context, this.order) {
    this.viewContext = context;
  }

  initialise() {
    fetchOrderDetails();
    fetchPaymentOptions();
  }

  void callVendor() {
    launchUrlString("tel:${order.vendor?.phone}");
  }

  void callDriver() {
    launchUrlString("tel:${order.driver?.phone}");
  }

  void callRecipient() {
    launchUrlString("tel:${order.recipientPhone}");
  }

  chatVendor() {
    //
    Map<String, PeerUser> peers = {
      '${order.userId}': PeerUser(
        id: '${order.userId}',
        name: order.user.name,
        image: order.user.photo,
      ),
      'vendor_${order.vendor?.id}': PeerUser(
        id: "vendor_${order.vendor?.id}",
        name: order.vendor?.name ?? "",
        image: order.vendor?.logo,
      ),
    };
    //
    final chatEntity = ChatEntity(
      onMessageSent: ChatService.sendChatMessage,
      mainUser: peers['${order.userId}']!,
      peers: peers,
      //don't translate this
      path: 'orders/' + order.code + "/customerVendor/chats",
      title: "Chat with vendor".tr(),
      supportMedia: true,
    );
    //
    Navigator.of(viewContext).pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }

  chatDriver() {
    //
    Map<String, PeerUser> peers = {
      '${order.userId}': PeerUser(
        id: '${order.userId}',
        name: order.user.name,
        image: order.user.photo,
      ),
      '${order.driver?.id}': PeerUser(
          id: "${order.driver?.id}",
          name: order.driver?.name ?? "Driver".tr(),
          image: order.driver?.photo),
    };
    //
    final chatEntity = ChatEntity(
      mainUser: peers['${order.userId}']!,
      peers: peers,
      //don't translate this
      path: 'orders/' + order.code + "/customerDriver/chats",
      title: "Chat with driver".tr(),
      onMessageSent: ChatService.sendChatMessage,
      supportMedia: true,
    );
    //
    Navigator.of(viewContext).pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }

  void fetchOrderDetails() async {
    refreshController.refreshCompleted();
    notifyListeners();
    setBusy(true);
    try {
      order = await orderRequest.getOrderDetails(id: order.id);
      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
      );
    }
    setBusy(false);
  }

  refreshDataSet() {
    fetchOrderDetails();
  }

  //
  rateVendor() async {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return VendorRatingBottomSheet(
          order: order,
          onSubmitted: () {
            //
            viewContext.pop();
            fetchOrderDetails();
          },
        );
      },
    );
  }

  //
  rateDriver() async {
    await viewContext.push(
      (context) => DriverRatingBottomSheet(
        order: order,
        onSubmitted: () {
          //
          viewContext.pop();
          fetchOrderDetails();
        },
      ),
    );
  }

  //
  trackOrder() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.orderTrackingRoute,
      arguments: order,
    );
  }

  cancelOrder() async {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return OrderCancellationBottomSheet(
          onSubmit: (String reason) {
            viewContext.pop();
            processOrderCancellation(reason);
          },
        );
      },
    );
  }

  //
  processOrderCancellation(String reason) async {
    setBusyForObject(order, true);
    try {
      final responseMessage = await orderRequest.updateOrder(
        id: order.id,
        status: "cancelled",
        reason: reason,
      );
      //
      order.status = "cancelled";
      //message
      viewContext.showToast(
        msg: responseMessage,
        bgColor: Colors.green,
        textColor: Colors.white,
      );

      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
    setBusyForObject(order, false);
  }

  void showVerificationQRCode() async {
    showDialog(
      context: viewContext,
      builder: (context) {
        return Dialog(
          child: VStack(
            [
              QrImage(
                data: order.verificationCode,
                version: QrVersions.auto,
                size: viewContext.percentWidth * 40,
              ).box.makeCentered(),
              "${order.verificationCode}".text.medium.xl2.makeCentered().py4(),
              "Verification Code".tr().text.light.sm.makeCentered().py8(),
            ],
          ).p20(),
        );
      },
    );
  }

  void shareOrderDetails() async {
    Share.share(
        "%s is sharing an order code with you. Track order with this code: %s"
            .tr()
            .fill(
      [
        order.user.name,
        order.code,
      ],
    ));
  }

  openPaymentMethodSelection() async {
    //
    setBusyForObject(order.paymentStatus, true);
    await fetchPaymentOptions(vendorId: order.vendorId);
    setBusyForObject(order.paymentStatus, false);
    await
        //
        showModalBottomSheet(
      context: viewContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (contex) {
        return PaymentMethodsView(this)
            .p20()
            .scrollVertical()
            .box
            .color(contex.theme.colorScheme.background)
            .topRounded()
            .make();
      },
    );
  }

  changeSelectedPaymentMethod(
    PaymentMethod? paymentMethod, {
    bool callTotal = true,
  }) async {
    //
    viewContext.pop();
    setBusyForObject(order.paymentStatus, true);
    try {
      //
      ApiResponse apiResponse = await orderRequest.updateOrderPaymentMethod(
        id: order.id,
        paymentMethodId: paymentMethod?.id,
        status: "pending",
      );

      //
      order = Order.fromJson(apiResponse.body["order"]);
      if (!["wallet", "cash"].contains(paymentMethod?.slug)) {
        if (paymentMethod?.slug == "offline") {
          openExternalWebpageLink(order.paymentLink);
        } else {
          openWebpageLink(order.paymentLink);
        }
      } else {
        toastSuccessful("${apiResponse.body['message']}");
      }

      //notify wallet view to update, just incase wallet was use for payment
      AppService().refreshWalletBalance.add(true);
    } catch (error) {
      toastError("$error");
    }
    setBusyForObject(order.paymentStatus, false);
  }
}
