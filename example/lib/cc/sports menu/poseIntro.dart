// import 'package:body_detection_example/cc/sports%20menu/undoneList.dart';
import 'package:flutter/material.dart';
import 'package:body_detection_example/cc/helpers/Constants.dart';
// import '../../Exercising/initial.dart';
// import '../poseList/Record.dart';
import 'package:body_detection_example/cc/poseList/poseRecord.dart';
// import '../poseList/poseRecord.dart';
import 'package:body_detection_example/poseRecognition/detection.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:body_detection_example/Exercising/initial2.dart';


class PoseIntro extends StatefulWidget {
  PoseIntro({Key? key, required this.SportName, required this.Context, required this.number, required this.whichCardyouChoose});

  final String SportName;
  final String number;
  final String Context;
  int whichCardyouChoose;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PoseIntroState();
  }
}
class PoseIntroState extends State<PoseIntro> {

  //輪播圖 PageView 使用的控制器
  late PageController _pageController;
  //定時器自動輪播
  late Timer _timer;
  //本地資源圖片
  List<String> imageList = [];
  List<String> squatImageList = [
    "assets/images/squat/squat1.jpg",
    "assets/images/squat/squat2.jpg",
  ];
  List<String> legpulloverImageList = [
    "assets/images/legpullover/legpullover1.png",
    "assets/images/legpullover/legpullover2.png",
  ];
  List<String> sidelegraiseImageList = [
    "assets/images/sidelegraise/sidelegraise1.png",
    "assets/images/sidelegraise/sidelegraise2.png",
  ];
  List<String> kneelinglegraiseImageList = [
    "assets/images/kneelinglegraise/kneelinglegraise1.png",
    "assets/images/kneelinglegraise/kneelinglegraise2.png",
    "assets/images/kneelinglegraise/kneelinglegraise3.png",
  ];
  List<String> pyramidStretchImageList = [
    "assets/images/pyramidStretch/pyramidStretch1.png",
    "assets/images/pyramidStretch/pyramidStretch2.png",
    "assets/images/pyramidStretch/pyramidStretch3.png",
    "assets/images/pyramidStretch/pyramidStretch4.png",
    "assets/images/pyramidStretch/pyramidStretch5.png",
    "assets/images/pyramidStretch/pyramidStretch6.png",
  ];
  List<String> lungeImageList = [
    "assets/images/lunge/lunge1.png",
    "assets/images/lunge/lunge2.png",
    "assets/images/lunge/lunge3.png",
  ];
  List<String> statedForwardBendStretchImageList = [
    "assets/images/statedForwardBendStretch/statedForwardBendStretch1.png",
    "assets/images/statedForwardBendStretch/statedForwardBendStretch2.png",
    "assets/images/statedForwardBendStretch/statedForwardBendStretch3.png",
    "assets/images/statedForwardBendStretch/statedForwardBendStretch4.png",
  ];

  //當前顯示的索引
  int currentIndex = 1000;

  @override
  void initState() {
    super.initState();
    //初始化控制器
    // initialPage 为初始化显示的子Item
    switch(widget.SportName){
      case "深蹲":
        imageList = squatImageList;
        break;
      case "自體腿部屈伸":
        imageList = legpulloverImageList;
        break;
      case "側臥抬腿":
        imageList = sidelegraiseImageList;
        break;
      case "跪姿抬腿":
        imageList = kneelinglegraiseImageList;
        break;
      case "金字塔式":
        imageList = pyramidStretchImageList;
        break;
      case "弓箭步":
        imageList = lungeImageList;
        break;
      case "坐姿前彎伸展":
        imageList = statedForwardBendStretchImageList;
        break;
    }
    _pageController = new PageController(initialPage: currentIndex);
    ///当前页面绘制完第一帧后回调
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
    });

  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    print("dispose");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _timer.cancel();
    print("deactivate");
  }

  void startTimer() {
    //间隔两秒时间
    _timer = new Timer.periodic(Duration(milliseconds: 3000), (value) {
      print("定時器1122");
      currentIndex++;
      //触发轮播切换
      _pageController.animateToPage(currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
      //刷新
      // setState(() {
      // });
    });
  }
  void cleanTimer(){
    if(_timer.isActive){
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.SportName),
        centerTitle: true,
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
          onPressed: () {
            print('Cancel');
            Navigator.of(context)..pop()..pop();
          },

        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: _pictureList(context),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Color(0xFF000000),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.Context,
                style: TextStyle(fontSize: 20,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            verticalDirection: VerticalDirection.up,
            children: [
                _buildbutton(context),
            ],
          ),
        ],
      ),
    );
  }
  Widget _pictureList(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          //輪播圖片
          pictureChangeWidget(),
          //指示器
          pictureTipsWidget(),
        ],
      ),
    );
  }
  pictureChangeWidget() {
    //懶載入方式構建
    return PageView.builder(
      //構建每一個子Item的佈局
      itemBuilder: (BuildContext context, int index) {
        return buildPageViewItemWidget(index);
      },
      //控制器
      controller: _pageController,
      //輪播個數 無限輪播 ??
      itemCount: imageList.length * 10000,
      //PageView滑動時回撥
      onPageChanged: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }
  buildPageViewItemWidget(int index) {
    return Image.asset(
      imageList[index % imageList.length],
      fit: BoxFit.fill,
    );
  }
  pictureTipsWidget() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        //内边距
        padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        //圆角边框
        decoration: BoxDecoration(
          //背景
            color: Colors.white,
            //边框圆角
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child:
        Text("${currentIndex % imageList.length + 1}/${imageList.length}"),
      ),
    );
  }
  // Widget _pictureList(BuildContext context) {
  //   return Container(
  //     height: 500,
  //     color: Colors.brown,
  //     // child: Image.network(
  //     //   record.photo,
  //     // ),
  //     //child: Text(record.name),
  //   );
  // }

  Widget _buildbutton(BuildContext context) {
    print("whichCardyouChoose " + widget.whichCardyouChoose.toString());
        return GestureDetector(
          onTap: () {
            switch (widget.whichCardyouChoose) {
              case 2:
                widget.whichCardyouChoose = 0;
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetectionInitial(SportName: widget.SportName,
                                Content: widget.Context,
                                number: widget.number,
                                image: squatImageList[0]),
                      ));
                });
                _timer.cancel();
                break;
              default:
                switch (widget.SportName) {
                  case "深蹲":
                    // Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detection(SportName: widget.SportName,
                            Content: widget.Context,
                            number: widget.number,
                            image: squatImageList[0],)));
                      _timer.cancel();
                    // });
                    break;
                  case "自體腿部屈伸":
                    // Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detection(SportName: widget.SportName,
                            Content: widget.Context,
                            number: widget.number,
                            image: squatImageList[0],)));
                      _timer.cancel();
                    // });
                    break;
                  case "側臥抬腿":
                    // Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detection(SportName: widget.SportName,
                            Content: widget.Context,
                            number: widget.number,
                            image: squatImageList[0],)));
                      _timer.cancel();
                    // });
                    break;
                  case "跪姿抬腿":
                    // Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detection(SportName: widget.SportName,
                            Content: widget.Context,
                            number: widget.number,
                            image: squatImageList[0],)));
                      _timer.cancel();
                    // });
                    break;
                  case "金字塔式":
                    // Future.delayed(Duration.zero, () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>
                        Detection(SportName: widget.SportName,
                            Content: widget.Context,
                            number: widget.number,
                            image: pyramidStretchImageList[0])));
                    _timer.cancel();
                    // });
                    break;
                  case "弓箭步":
                    // Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detection(SportName: widget.SportName,
                            Content: widget.Context,
                            number: widget.number,
                            image: squatImageList[0],)));
                      _timer.cancel();
                    // });
                    break;
                  case "坐姿前彎伸展":
                    // Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detection(SportName: widget.SportName,
                            Content: widget.Context,
                            number: widget.number,
                            image: squatImageList[0],)));
                      _timer.cancel();
                    // });
                    break;
                };
            };
          },
          child: Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 70,
              width: 150,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 5),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: const Text(
                '開始',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        );

      // default:
      //   widget.whichCardyouChoose = 0;
      //   return GestureDetector(
      //       onTap: () {
      //         switch (widget.SportName) {
      //           case "深蹲":
      //             Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //                 Detection(SportName: widget.SportName, Content: widget.Context, number: widget.number, image: squatImageList[0],)));
      //             _timer.cancel();
      //             break;
      //           case "自體腿部屈伸":
      //             Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //                 Detection(SportName: widget.SportName, Content: widget.Context, number: widget.number, image: legpulloverImageList[0],)));
      //             _timer.cancel();
      //             break;
      //           case "側臥抬腿":
      //             Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //                 Detection(SportName: widget.SportName, Content: widget.Context, number: widget.number, image: sidelegraiseImageList[0])));
      //             _timer.cancel();
      //             break;
      //           case "跪姿抬腿":
      //             Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //                 Detection(SportName: widget.SportName, Content: widget.Context, number: widget.number, image: kneelinglegraiseImageList[0])));
      //             _timer.cancel();
      //             break;
      //           case "金字塔式":
      //             Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //                 Detection(SportName: widget.SportName, Content: widget.Context, number: widget.number, image: pyramidStretchImageList[0])));
      //             _timer.cancel();
      //             break;
      //           case "弓箭步":
      //             Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //                 Detection(SportName: widget.SportName, Content: widget.Context, number: widget.number, image: lungeImageList[0])));
      //             _timer.cancel();
      //             break;
      //           case "坐姿前彎伸展":
      //             Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //                 Detection(SportName: widget.SportName, Content: widget.Context, number: widget.number, image: statedForwardBendStretchImageList[0])));
      //             _timer.cancel();
      //             break;
      //         }
      //       },
      //       child: Center(
      //         child: Container(
      //           margin: EdgeInsets.only(bottom: 20),
      //           height: 70,
      //           width: 150,
      //           alignment: Alignment.center,
      //           decoration: const BoxDecoration(
      //             color: kPrimaryColor,
      //             borderRadius: BorderRadius.all(Radius.circular(35)),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.grey,
      //                 offset: Offset(0, 5),
      //                 blurRadius: 7,
      //               ),
      //             ],
      //           ),
      //           child: const Text(
      //             '開始',
      //             style: TextStyle(fontSize: 30, color: Colors.white),
      //           ),
      //         ),
      //       )
      //   );
  }
}
