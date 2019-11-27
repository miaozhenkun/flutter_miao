import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<Home> with AutomaticKeepAliveClientMixin {
  Dio dio = new Dio();
  List data;
  var today = {};
  _HomePageState() {
    // _getWeather();
    print('_HomePageState');
  }

  @override //initState 是 StatefulWidget 创建完后调用的第一个方法，而且只执行一次，类似于 Android 的 onCreate、iOS 的 viewDidLoad()，所以在这里 View 并没有渲染，但是这时 StatefulWidget 已经被加载到渲染树里了，这时 StatefulWidget 的 mount 的值会变为 true，直到 dispose 调用的时候才会变为 false。可以在 initState 里做一些初始化的操作。
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    Response response;
    response = await dio.get(
        'https://wis.qq.com/weather/common?source=xw&weather_type=forecast_1h|forecast_24h|index|alarm|limit|tips&province=%E6%B2%B3%E5%8D%97%E7%9C%81&city=%E9%83%91%E5%B7%9E%E5%B8%82');
    Map<String, dynamic> map = json.decode(response.toString());
    setState(() {
      today = map['data']['forecast_1h']['0'];
    });
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataStr = prefs.getString("userinfo");
    String dataStr1 = prefs.getString("token");
    String dataStr2 = prefs.getString("childrenList");
    String date ="20191127100000";
    print(DateTime(1989, 02, 21));

    if(dataStr!=null&&dataStr.isNotEmpty){
      Map<String, dynamic> dataMap = json.decode(dataStr);
      print(dataMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image.asset(
            "images/weather_bg.jpg",
            fit: BoxFit.fitHeight,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 40.0),
                child: new Text(
                  "郑州市",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil.getInstance().setSp(48)),
                ),
              ),
              new Container(
                // width: double.infinity,
                margin: EdgeInsets.only(top: 100.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                        today['weather_short'] == null
                            ? ''
                            : today['weather_short'],
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.getInstance().setSp(100))),
                    new Text(
                        today['wind_direction'] == null
                            ? ''
                            : today['wind_direction'],
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.getInstance().setSp(40))),
                    new Text(
                      (today['weather'] == null ? '' : today['weather']) +
                          '~' +
                          (today['weather'] == null ? '' : today['weather']),
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.getInstance().setSp(40)),
                    ),
                    new Text(
                      today['update_time'] == null ? '' : formatDate(DateTime(2019, 02, 21), [yyyy, '-', mm, '-', dd]) ,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.getInstance().setSp(40)),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
