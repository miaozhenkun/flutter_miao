import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'GlobalConfig.dart';

class DioHttpService {
  //写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static DioHttpService _instance;

  static DioHttpService getInstance() {
    if (_instance == null) {
      _instance = DioHttpService();
    }
    return _instance;
  }

  Dio dio = new Dio();
  DioHttpService() {
    dio.options.headers = {
      "version": '2.0.9',
      "Authorization": '_token',
    };
    dio.options.baseUrl = "http://113.208.113.12:8777/VaccinationServer/api/v1";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
  }
  //get请求
  get(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, 'get', params, errorCallBack);
  }

  //post请求
  post(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, "post", params, errorCallBack);
  }

  _requstHttp(String url, Function successCallBack,
      [String method, params, Function errorCallBack]) async {
    Response response;
    // String errorMsg = '';
    // int code;
    try {
      if (method == 'get') {
        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }
      //code = response.statusCode;
      //print(code);
    } on DioError catch (error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      print(error);
      // debug模式才打印
      if (GlobalConfig.isDebug) {
        print(error);
        print('请求异常url: ' + url);
        print('请求头: ' + dio.options.headers.toString());
        print('method: ' + dio.options.method);
      }
      _error(errorCallBack, error.message);
      return '';
    }

    // debug模式打印相关数据
    if (GlobalConfig.isDebug) {
      print('请求url: ' + url);
      print('请求头: ' + dio.options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
    String dataStr = json.encode(response.data);
    Map<String, dynamic> dataMap = json.decode(dataStr);
    print(dataMap);
    print(dataMap['statecode']);
    if (dataMap == null || dataMap['statecode'] == "201") {
      Fluttertoast.showToast(
        msg: dataMap['msg'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0
      );
    } else if (successCallBack != null && dataMap['statecode'] == "200") {
      successCallBack(dataMap['response']);
    }
  }

  _error(Function errorCallBack, String error) {
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }
}
