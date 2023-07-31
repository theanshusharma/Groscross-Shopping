import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/models/checkout.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/checkout.vm.dart';
import 'package:groscross/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:groscross/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:groscross/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:groscross/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:groscross/widgets/buttons/custom_button.dart';
import 'package:groscross/widgets/cards/order_summary.dart';
import 'package:groscross/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter/services.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({
    required this.checkout,
    Key? key,
  }) : super(key: key);

  final CheckOut checkout;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      viewModelBuilder: () => CheckoutViewModel(context, checkout),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Checkout".tr(),
          body: VStack(
            [
              //
              UiSpacer.verticalSpace(),
              Visibility(
                visible: !vm.isPickup,
                child: CustomTextFormField(
                  labelText:
                      "Driver Tip".tr() + " (${AppStrings.currencySymbol})",
                  textEditingController: vm.driverTipTEC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => vm.updateCheckoutTotalAmount(),
                ).pOnly(bottom: Vx.dp20),
              ),
              //
              CustomTextFormField(
                labelText: "Note".tr(),
                textEditingController: vm.noteTEC,
              ),

              //note
              Divider(thickness: 3).py12(),

              //pickup time slot
              ScheduleOrderView(vm),

              //its pickup
              OrderDeliveryAddressPickerView(vm),

              //payment options
              Visibility(
                visible: vm.canSelectPaymentOption,
                child: PaymentMethodsView(vm),
              ),

              //order final price preview
              OrderSummary(
                subTotal: vm.checkout!.subTotal,
                discount: vm.checkout!.discount,
                deliveryFee: vm.checkout!.deliveryFee,
                tax: vm.checkout!.tax,
                vendorTax: vm.vendor!.tax,
                driverTip: vm.driverTipTEC.text.toDouble() ?? 0.00,
                total: vm.checkout!.totalWithTip,
                fees: vm.vendor!.fees,
              ),

              //show notice it driver should be paid in cash
              if (vm.checkout!.deliveryAddress != null)
                CheckoutDriverCashDeliveryNoticeView(
                  vm.checkout!.deliveryAddress!,
                ),
              //
              CustomButton(
                title: "PLACE ORDER".tr().padRight(14),
                icon: FlutterIcons.credit_card_fea,
                onPressed: vm.placeOrder,
                loading: vm.isBusy,
              ).centered().py16(),
            ],
          ).p20().scrollVertical().pOnly(bottom: context.mq.viewInsets.bottom),
        );
      },
    );
  }
}
