import 'package:flutter/material.dart';
import 'package:groscross/models/vehicle_type.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/taxi.vm.dart';
import 'package:groscross/widgets/custom_list_view.dart';
import 'package:groscross/widgets/list_items/horizontal_vehicle_type.list_item.dart';

class TaxiVehicleTypeListView extends StatelessWidget {
  const TaxiVehicleTypeListView({
    Key? key,
    this.min = true,
    required this.vm,
  }) : super(key: key);

  final TaxiViewModel vm;
  final bool min;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<VehicleType> mVehicleTypes = [];
        if (min) {
          if (vm.vehicleTypes.length > 3) {
            mVehicleTypes = vm.vehicleTypes.sublist(0, 3);
          } else {
            mVehicleTypes = vm.vehicleTypes;
          }
        } else {
          mVehicleTypes = vm.vehicleTypes;
        }
        return CustomListView(
          padding: EdgeInsets.zero,
          noScrollPhysics: true,
          dataSet: mVehicleTypes,
          isLoading: vm.busy(vm.vehicleTypes),
          itemBuilder: (context, index) {
            final vehicleType = mVehicleTypes[index];
            return HorizontalVehicleTypeListItem(vm, vehicleType);
          },
          separatorBuilder: (ctx, index) => UiSpacer.emptySpace(),
        );
      },
    );
  }
}
