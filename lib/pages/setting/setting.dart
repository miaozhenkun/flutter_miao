import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quickstart/pages/user/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new settingState();
  }
}

class settingState extends State<Setting> {
  var userinfo = {};
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;
  var titles = ["我的消息", "阅读记录", "我的博客", "我的问答", "我的活动", "我的团队", "退出登录"];
  var imagePaths = [
    "images/ic_my_message.png",
    "images/ic_my_blog.png",
    "images/ic_my_blog.png",
    "images/ic_my_question.png",
    "images/ic_discover_pos.png",
    "images/ic_my_team.png",
    "images/ic_my_recommend.png"
  ];
  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    'images/u76.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  goLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LoginPage()));
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    geyUserInfo();
  }

  geyUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataStr = prefs.getString("userinfo").toString();
    if (dataStr!=null) {
      Map<String, dynamic> dataMap = json.decode(dataStr);
      userinfo = dataMap;
      setState(() {
        userinfo = userinfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('设置'),
        //   centerTitle: true,
        // ),
        body: CustomScrollView(reverse: false, shrinkWrap: false, slivers: <
            Widget>[
      new SliverAppBar(
        pinned: false,
        backgroundColor: Colors.green,
        expandedHeight: 200.0,
        iconTheme: new IconThemeData(color: Colors.transparent),
        flexibleSpace: new InkWell(
            onTap: () {
              print(userinfo);
              userinfo!=null&&userinfo.isNotEmpty ? debugPrint('用户信息') : goLogin();
            },
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                userinfo==null||userinfo.isEmpty
                    ? new Image.asset(
                        "images/other.png",
                        width: 100.0,
                        height: 100.0,
                      )
                    : new Container(
                        width: 100.0,
                        height: 100.0,
                        margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: new DecorationImage(
                                image: new NetworkImage(
                                    'https://goss.veer.com/creative/vcg/veer/800water/veer-149457926.jpg'),
                                fit: BoxFit.cover),
                            border: new Border.all(
                                color: Colors.white, width: 1.0)),
                      ),
                new Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: new Text(
                    userinfo != null&&userinfo.isNotEmpty
                        ? userinfo['USER_NAME']
                        : '点击登录',
                    style: new TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                )
              ],
            )),
      ),
      SliverList(
          delegate: SliverChildListDelegate(
        //返回组件集合
        List.generate(titles.length, (int index) {
          //返回 组件
          return GestureDetector(
            onTap: () {
              print(titles[index]);
              // userinfo.updateAll((key,value){
              //   return "";
              // });
              userinfo.clear();
              if (titles[index] == "退出登录") {
                setState(() {
                  userinfo = userinfo;
                });
              }
            },
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 12.0, 15.0, 15.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(
                        titles[index],
                        style: titleTextStyle,
                      )),
                      rightArrowIcon
                    ],
                  ),
                ),
                new Divider(
                  height: 1.0,
                )
              ],
            ),
          );
        }),
      ))
    ]));
  }
}
