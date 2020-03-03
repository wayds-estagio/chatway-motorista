import 'package:chatway/app/models/chat.model.dart';
import 'package:chatway/app/utils/api_response.dart';
import 'package:chatway/app/utils/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatApi {
  static Future<ApiResponse<Chat>> createChat({
    @required String motorista,
    @required String motoristaId,
    @required String unidade,
  }) async {
    try {
      Dio dio = Dio();

      dio.options.baseUrl = "${Consts.baseURL}";
      dio.options.connectTimeout = 3000;
      dio.options.receiveTimeout = 3000;
      dio.options.headers['content-Type'] = 'application/json';

      Map params = {
        "motorista": motorista,
        "motoristaId": motoristaId,
        "unidade": unidade,
      };

      var response = await dio.post("/api/v1/chat", data: params);

      print('> Chat Api getHelp: Response status: ${response.statusCode}');
      //print('> Chat Api getHelp: Response body: ${response.data}');

      if (response.statusCode == 200) {
        Chat chat = Chat.fromJson(response.data);

        return ApiResponse.ok(chat, "ChatApi: Home need help sucess");
      }

      return ApiResponse.error("error");
    } catch (error, exception) {
      print("ChatApi: Error in home need help > $error > $exception");

      return ApiResponse.error("ChatApi: Home need help error");
    }
  }

  static Future<ApiResponse<List<Chat>>> getChatPendente(String unidade) async {
    try {
      Dio dio = Dio();

      dio.options.baseUrl = "${Consts.baseURL}";
      dio.options.connectTimeout = 3000;
      dio.options.receiveTimeout = 3000;
      dio.options.headers['content-Type'] = 'application/json';

      var response =
          await dio.get("/api/v1/chat/pendentes/5e5e52eba1a94923c47e710c");

      print(
          '> ChatApi getChatPendente: Response status: ${response.statusCode}');
      //print('> ChatApi getChetPendente: Response body: ${response.data}');

      if (response.statusCode == 200) {
        var chats = List<Chat>();
        response.data.forEach((v) {
          chats.add(Chat.fromJson(v));
        });

        return ApiResponse.ok(chats, "ChatApi: Home need help sucess");
      }

      return ApiResponse.error("error");
    } catch (error, exception) {
      print("ChatApi: Error in home need help > $error > $exception");

      return ApiResponse.error("ChatApi: Home need help error");
    }
  }

  static Future<ApiResponse<List<Chat>>> getChatAtendidos(
      String unidade) async {
    try {
      Dio dio = Dio();

      dio.options.baseUrl = "${Consts.baseURL}";
      dio.options.connectTimeout = 3000;
      dio.options.receiveTimeout = 3000;
      dio.options.headers['content-Type'] = 'application/json';

      var response =
          await dio.get("/api/v1/chat/pendentes/5e5e52eba1a94923c47e710c");

      print(
          '> ChatApi getChatPendente: Response status: ${response.statusCode}');
      //print('> ChatApi getChetPendente: Response body: ${response.data}');

      if (response.statusCode == 200) {
        var chats = List<Chat>();
        response.data.forEach((v) {
          chats.add(Chat.fromJson(v));
        });

        return ApiResponse.ok(chats, "ChatApi: Home need help sucess");
      }

      return ApiResponse.error("error");
    } catch (error, exception) {
      print("ChatApi: Error in home need help > $error > $exception");

      return ApiResponse.error("ChatApi: Home need help error");
    }
  }
}
