import 'package:flutter/material.dart';
import 'package:flutter_quickstart/pages/home/home.dart';
import 'package:flutter_quickstart/pages/profile/profile.dart';
import 'package:flutter_quickstart/pages/setting/setting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,  //不显示右上角debug文字
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: indexPage(),
    );
  }
}

class indexPage extends StatefulWidget {
  @override
  indexPageState createState() =>
      indexPageState();
}

class indexPageState extends State<indexPage> {
  PageController pageController;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    this.pageController = PageController(initialPage: this.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context); //用于屏幕适配
    print('Device width px:${ScreenUtil.screenWidth}'); //Device width
    print('Device height px:${ScreenUtil.screenHeight}'); //Device height
    // print('Device pixel density:${ScreenUtil.pixelRatio}'); //Device pixel density
    // print('Bottom safe zone distance dp:${ScreenUtil.bottomBarHeight}'); //Bottom safe zone distance，suitable for buttons with full screen
    // print('Status bar height px:${ScreenUtil.statusBarHeight}dp'); //Status bar height , Notch will be higher Unit px
    // print('Ratio of actual width dp to design draft px:${ScreenUtil.getInstance().scaleWidth}');
    // print('Ratio of actual height dp to design draft px:${ScreenUtil.getInstance().scaleHeight}');
    // print('The ratio of font and width to the size of the design:${ScreenUtil.getInstance().scaleWidth * ScreenUtil.pixelRatio}');
    // print('The ratio of  height width to the size of the design:${ScreenUtil.getInstance().scaleHeight * ScreenUtil.pixelRatio}');
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          bottomNavigationBar:new BottomNavigationBar( 
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text("首页"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text("发现"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text("设置"),
              )
            ],
            fixedColor: Colors.green,
            type: BottomNavigationBarType.fixed,
            onTap: (page) {
              pageController.jumpToPage(page);
            },
            currentIndex: this.currentIndex,
          ),
          body: PageView(
            children: <Widget>[
              new Home(),
              new Profilepage(),
              new Setting(),
            ],
            controller: this.pageController,
            onPageChanged: (index) {
              setState(() {
                this.currentIndex = index;
              });
            },
          ),
        ));
  }

    //监听APP退出方法
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('确定吗?'),
                content: new Text('退出APP'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('否'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('是'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}

