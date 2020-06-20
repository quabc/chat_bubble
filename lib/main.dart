import 'package:flutter/material.dart';

///带箭头气泡
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat_bubble',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String align;
  final String content;

  _MyHomePageState({this.content, this.align = 'left'});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new ClipPath(
          clipper: TextPath(align),
          child: new Container(
            padding: align == 'left'
                ? EdgeInsets.only(left: 7.0)
                : EdgeInsets.only(right: 7.0)
                    .add(EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0)),
            color: Colors.green,
            child: new Text(content, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class TextPath extends CustomClipper<Path> {
  final String align;
  static const _ArrowWidth = 7.0; //箭头宽度
  static const _ArrowHeight = 10.0; //箭头高度
  static const _MinHeight = 32.0; //内容最小高度

  TextPath(this.align);
  @override
  Path getClip(Size size) {
    Path path1 = new Path();
    Path path2 = new Path();
    //三角形中心点
    final centerPoint =
        (size.height / 2).clamp(_MinHeight / 2, _MinHeight / 2); //clamp(下限，上限),
    if (align == 'left') {
      ///左边三角形
      //从中心点开始画图
      path1.moveTo(0, centerPoint);
      //画线的终点(x,y)
      path1.lineTo(_ArrowWidth, centerPoint - _ArrowHeight / 2);
      //同上
      path1.lineTo(_ArrowWidth, centerPoint + _ArrowHeight / 2);
      //画完
      path1.close();
    } else {
      ///右边三角形
      //x轴跑到右边
      path1.moveTo(size.width, centerPoint);
      //线的x轴终点为组件宽度减去三角形宽度(x,y)
      path1.lineTo(size.width - _ArrowWidth, centerPoint - _ArrowHeight / 2);
      path1.lineTo(size.width - _ArrowWidth, centerPoint + _ArrowHeight / 2);
      path1.close();
    }

    ///内容矩形
    Rect rect = Rect.fromLTWH(align == 'left' ? _ArrowWidth : 0, 0,
        (size.width - _ArrowWidth), size.height);
    path2.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(5.0)));

    //合并三角形和内容矩形
    path1.addPath(path2, Offset.zero);
    return path1;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
