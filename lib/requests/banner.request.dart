import 'package:groscross/constants/api.dart';
import 'package:groscross/models/api_response.dart';
import 'package:groscross/models/banner.dart';
import 'package:groscross/services/http.service.dart';

class BannerRequest extends HttpService {
  //
  Future<List<Banner>> banners({
    int? vendorTypeId,
    Map? params,
  }) async {
    final apiResult = await get(
      Api.banners,
      queryParameters: {
        "vendor_type_id": vendorTypeId,
        ...(params != null ? params : {}),
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Banner.fromJSON(jsonObject))
          .toList();
    } else {
      throw apiResponse.message!;
    }
  }
}
