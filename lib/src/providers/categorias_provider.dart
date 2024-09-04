import 'package:delivery/src/models/response_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../enviroment/enviroment.dart';
import '../models/categories.dart';
import '../models/user.dart';

class CategoriasProvider extends GetConnect {

  String url = Environment.API_URL + 'api/categories';

  User userSession = User.fromJson(GetStorage().read('user')??{});

  Future<List<Categorias>> getAll()async{
    Response response = await get(
        '$url/getAll',
        headers: {
          'content-type':'application/json',
          'Authorization': userSession.sessionToken??''
        }
    );

  if(response.status==401){
    Get.snackbar('Petición denegada', 'No tienes permitido leer esta información');
    return [];
  }

  List<Categorias> categorias = Categorias.fromJsonList(response.body);

  return categorias;
  }


  Future<ResponseApi> create(Categorias categoria)async{
    Response response = await post(
        '$url/create',
        categoria.toJson(),
        headers: {
          'content-type':'application/json',
          'Authorization': userSession.sessionToken??''
        }
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }
}