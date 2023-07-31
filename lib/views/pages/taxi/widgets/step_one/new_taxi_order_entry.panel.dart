import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/taxi.vm.dart';
import 'package:groscross/view_models/taxi_new_order_location_entry.vm.dart';
import 'package:groscross/views/pages/taxi/widgets/step_one/new_taxi_order_schedule.view.dart';
import 'package:groscross/views/pages/taxi/widgets/step_one/new_taxi_pick_on_map.view.dart';
import 'package:groscross/widgets/busy_indicator.dart';
import 'package:groscross/widgets/buttons/custom_button.dart';
import 'package:groscross/widgets/custom_list_view.dart';
import 'package:groscross/widgets/custom_timeline_connector.dart';
import 'package:groscross/widgets/list_items/address.list_item.dart';
import 'package:groscross/widgets/taxi_custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTaxiOrderEntryPanel extends StatelessWidget {
  const NewTaxiOrderEntryPanel(this.taxiNewOrderViewModel, {Key? key})
      : super(key: key);

  final NewTaxiOrderLocationEntryViewModel taxiNewOrderViewModel;

  @override
  Widget build(BuildContext context) {
    final TaxiViewModel vm = taxiNewOrderViewModel.taxiViewModel;
    return VxBox(
      child: vm.isBusy
          ? BusyIndicator().centered().p20()
          : VStack(
              [
                VStack(
                  [
                    //
                    HStack(
                      [
                        Icon(
                          FlutterIcons.close_ant,
                        ).onTap(taxiNewOrderViewModel.closePanel),
                        "Your route".tr().text.bold.xl.make().px12().expand(),
                      ],
                    ),

                    UiSpacer.verticalSpace(),
                    //schedule order
                    NewTaxiOrderScheduleView(taxiNewOrderViewModel),
                    //entry
                    HStack(
                      [
                        //
                        CustomTimelineConnector(height: 50),
                        UiSpacer.hSpace(10),
                        //
                        VStack(
                          [
                            TaxiCustomTextFormField(
                              hintText: "Pickup Location".tr(),
                              controller: vm.pickupLocationTEC,
                              focusNode: vm.pickupLocationFocusNode,
                              onChanged: taxiNewOrderViewModel.searchPlace,
                              clear: true,
                            ),
                            UiSpacer.vSpace(5),
                            TaxiCustomTextFormField(
                              hintText: "Drop-off Location".tr(),
                              controller: vm.dropoffLocationTEC,
                              focusNode: vm.dropoffLocationFocusNode,
                              onChanged: taxiNewOrderViewModel.searchPlace,
                              clear: true,
                            ),
                          ],
                        ).expand(),
                      ],
                    ),
                  ],
                )
                    .p20()
                    .safeArea()
                    .box
                    .shadowSm
                    .color(context.theme.colorScheme.background)
                    .make(),
                //list of search result,
                CustomListView(
                  padding: EdgeInsets.zero,
                  isLoading:
                      taxiNewOrderViewModel.busy(taxiNewOrderViewModel.places),
                  dataSet: taxiNewOrderViewModel.places != null
                      ? taxiNewOrderViewModel.places!
                      : [],
                  itemBuilder: (contex, index) {
                    final place = taxiNewOrderViewModel.places![index];
                    return AddressListItem(
                      place,
                      onAddressSelected:
                          taxiNewOrderViewModel.onAddressSelected,
                    );
                  },
                  separatorBuilder: (ctx, index) => UiSpacer.divider(),
                ).expand(),
                //select on map
                NewTaxiPickOnMapButton(
                  taxiNewOrderViewModel: taxiNewOrderViewModel,
                ),
                Visibility(
                  visible: !vm.pickupLocationFocusNode.hasFocus &&
                      !vm.dropoffLocationFocusNode.hasFocus,
                  child: CustomButton(
                    title: "Next".tr(),
                    onPressed: taxiNewOrderViewModel.moveToNextStep,
                  ).p8().safeArea(top: false),
                ),
              ],
            ),
    )
        .color(vm.isBusy
            ? context.theme.colorScheme.background.withOpacity(0.5)
            : context.theme.colorScheme.background)
        .make()
        .pOnly(bottom: context.mq.viewInsets.bottom);
  }
}
