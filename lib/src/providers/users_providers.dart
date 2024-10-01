import 'package:delivery/src/enviroment/enviroment.dart';
import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class UsersProviders extends GetConnect{

  String url = Environment.API_URL + 'api/users';

  User userSession = User.fromJson(GetStorage().read('user')??{});

  Future<Response> create(User user)async{
    Response response = await post(
      '$url/create',
      user.toJson(),
      headers: {
        'content-type':'application/json'
      }
    );
    return response;
  }


  Future<ResponseApi> update(User user)async{
    Response response = await put(
        '$url/updateWithOutImage',
        user.toJson(),
        headers: {
          'content-type':'application/json',
          'Authorization': userSession.sessionToken??''
        }
    );

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo actualizar la información');
      return ResponseApi();
    }

    if(response.status==401){
      Get.snackbar('Error', 'No dispones de autorización');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> login(String email, String password)async{
    Response response = await post(
        '$url/login',
        {
          'email':email,
          'password':password
        },
        headers: {
          'content-type':'application/json'
        }
    );

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo ejecutar la petición');
      return ResponseApi();
    }

    ResponseApi responseApi=ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<Stream> createWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<Stream> updateWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/update');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? '';
    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<List<User>> getDeliveryMen()async{
    Response response = await get(
        '$url/findDeliveryMen',
        headers: {
          'content-type':'application/json',
          'Authorization': userSession.sessionToken??''
        }
    );

    if(response.status==401){
      Get.snackbar('Petición denegada', 'No tienes permitido leer esta información');
      return [];
    }

    List<User> users = User.fromJsonList(response.body);

    return users;
  }

  Future<ResponseApi> updateNotificationToken(String id, String token) async {
    Response response = await put(
        '$url/updateNotificationToken',
        {
          'id': id,
          'token': token
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar la informacion');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      Get.snackbar('Error', 'No estas autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  /*
  * GET X

  Future<ResponseApi> createUserWithImageGetX(User user, File image) async {
    FormData form = FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'user': json.encode(user)
    });
    Response response = await post('$url/createWithImage', form);

    if (response.body == null) {
      Get.snackbar('Error en la peticion', 'No se pudo crear el usuario');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }*/
}