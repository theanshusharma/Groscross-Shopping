import 'package:groscross/constants/api.dart';
import 'package:groscross/models/api_response.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/services/http.service.dart';
import 'package:groscross/services/location.service.dart';

class VendorTypeRequest extends HttpService {
  //
  Future<List<VendorType>> index() async {
    final apiResult = await get(
      Api.vendorTypes,
      queryParameters: {
        "latitude": LocationService.currenctAddress?.coordinates?.latitude,
        "longitude": LocationService.currenctAddress?.coordinates?.longitude,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map((e) => VendorType.fromJson(e))
          .toList();
    }

    throw apiResponse.message!;
  }
}
