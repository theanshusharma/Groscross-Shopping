import 'package:groscross/constants/api.dart';
import 'package:groscross/models/api_response.dart';
import 'package:groscross/models/category.dart';
import 'package:groscross/services/http.service.dart';

class CategoryRequest extends HttpService {
  //
  Future<List<Category>> categories({
    int? vendorTypeId,
    int page = 0,
    int full = 0,
  }) async {
    final apiResult = await get(
      //
      Api.categories,
      queryParameters: {
        "vendor_type_id": vendorTypeId,
        "page": page,
        "full": full,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Category.fromJson(jsonObject))
          .toList();
    } else {
      throw apiResponse.message!;
    }
  }

  Future<List<Category>> subcategories({int? categoryId, int? page}) async {
    final apiResult = await get(
      //
      Api.categories,
      queryParameters: {
        "category_id": categoryId,
        "page": page,
        "type": "sub",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Category.fromJson(jsonObject))
          .toList();
    } else {
      throw apiResponse.message!;
    }
  }
}
