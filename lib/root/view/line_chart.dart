import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:ui' as ui;

import 'package:ricoms_app/repository/device_repository.dart';

const double SLIDING_BTN_WIDTH = 30.0;
const Color kSlidingBtnColor =
    Color(0x2268838B); // Colors.black54.withAlpha(100)
const Color kSlidingBtnScrimColor = Color(0x2268838B); // Colors.black12
const Color kAltitudePathColor = Color(0xFF003c60);
const List<Color> kAltitudeGradientColors = [
  Color(0x821E88E5),
  Color(0x0C1E88E5)
];
const Color kAxisTextColor = Colors.black;
const Color kVerticalAxisDottedLineColor = Colors.amber;
const Color kLabelTextColor = Colors.white;
const Color kAltitudeThumbnailPathColor = Colors.grey;
const Color kAltitudeThumbnailGradualColor = Color(0xFFE0EFFB);

// class AltitudePoint {
//   //String name;

//   //int level;

//   Offset point;

//   Color color;

//   late TextPainter textPainter;

//   // AltitudePoint(this.name, this.level, this.point, this.color) {
//   //   if (name == null || name.isEmpty) return;

//   AltitudePoint(
//     this.point,
//     this.color,
//   ) {
//     // 向String插入换行符使文字竖向绘制
//     // TODO 这种写法应该是不正确的, 暂时不知道更好的方式
//     // var splitMapJoin = name.splitMapJoin('', onNonMatch: (m) {
//     //   return m.isNotEmpty ? "$m\n" : "";
//     // });
//     // splitMapJoin = splitMapJoin.substring(0, splitMapJoin.length - 1);

//     this.textPainter = TextPainter(
//       textAlign: TextAlign.left,
//       textDirection: TextDirection.ltr,
//       text: TextSpan(
//         text: '',
//         style: TextStyle(
//           color: kLabelTextColor,
//           fontSize: 8.0,
//         ),
//       ),
//     )..layout();
//   }
// }

class AltitudeGraphView extends StatefulWidget {
  final List<ChartDateValuePair> chartDateValuePairList;
  final double maxScale;
  final Color axisLineColor;
  final Color axisTextColor;
  final Color pathColor;
  final List<Color> gradientColors;
  final bool slidingBarVisible;
  final Animation<double> animation;

  AltitudeGraphView(
    this.chartDateValuePairList, {
    this.maxScale = 1.0,
    this.axisLineColor = kVerticalAxisDottedLineColor,
    this.axisTextColor = kAxisTextColor,
    this.pathColor = kAltitudePathColor,
    this.gradientColors = kAltitudeGradientColors,
    this.slidingBarVisible = true,
    required this.animation,
  });

  @override
  AltitudeGraphViewState createState() => AltitudeGraphViewState();
}

class AltitudeGraphViewState extends State<AltitudeGraphView>
    with SingleTickerProviderStateMixin {
  // ==== 海拔图数据
  int _maxLevel = 0;
  int _minLevel = 0;
  double _maxAltitude = 0.0;
  double _minAltitude = 0.0;
  double _maxVerticalAxisValue = 0.0;
  double _minVerticalAxisValue = 0.0;
  double _verticalAxisInterval = 0.0;

  // ==== 放大/和放大的基点的值. 在动画/手势中会实时变化
  double _scale = 1.0;
  double _offsetX = 0.0;

  // ==== 辅助动画/手势的计算
  Offset? _focusPoint;

  // ==== 上次放大的比例, 用于帮助下次放大操作时放大的速度保持一致.
  double _lastScaleValue = 1.0;
  Offset _lastUpdateFocalPoint = Offset.zero;

  // ==== 缩放滑钮
  double _leftSlidingBtnLeft = 0.0;
  double _lastLeftSlidingBtnLeft = 0.0;
  double _rightSlidingBtnRight = 0.0;
  double _lastRightSlidingBtnRight = 0.0;
  double _lastSlidingBarPosition = 0.0;

  double _lastScale4ReverseAnimation = 1.0;
  AnimationStatus? status;

  // ==== 负责惯性滑动动画
  AnimationController? controller;
  Animation<double>? animation;
  VoidCallback? listener;

  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();

    _initData();

    widget.animation.addListener(_onAnimationUpdated);
    widget.animation.addStatusListener(_onAnimationStatusChanged);

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    _destroyPictures();
    controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AltitudeGraphView oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initData();

    _resetFlingAnim();

    oldWidget.animation.removeListener(_onAnimationUpdated);
    widget.animation.addListener(_onAnimationUpdated);
    oldWidget.animation.removeStatusListener(_onAnimationStatusChanged);
    widget.animation.addStatusListener(_onAnimationStatusChanged);

    // 如果当前缩放大于新的最大缩放, 则调整缩放
    if (_scale != 1.0) {
      setState(() {
        _scale = 1.0;
        _offsetX = 0.0;
        _leftSlidingBtnLeft = 0.0;
        _rightSlidingBtnRight = 0.0;
      });
    }
  }

  _onAnimationStatusChanged(AnimationStatus s) {
    status = s;
    if (s == AnimationStatus.reverse) {
      _lastScale4ReverseAnimation = _scale;
    }
  }

  _onAnimationUpdated() {
    if (status != AnimationStatus.reverse) {
      setState(() {});
      return;
    }

    var value = widget.animation.value.clamp(0.0, 1.0);
    var newScale = (_lastScale4ReverseAnimation - 1.0) * value + 1.0;

    _updateScaleAndScrolling(newScale, context.size!.width / 2);
  }

  /// 遍历数据, 取得 最高海拔值, 最低海拔值, 最高Level, 最低Level.
  /// 根据最高海拔值和最低海拔值计算出纵轴最大值和最小值.
  _initData() {
    if (widget.chartDateValuePairList.isEmpty) return;

    var firstPoint = widget.chartDateValuePairList.first.point;
    _maxAltitude = firstPoint.dy;
    _minAltitude = firstPoint.dy;
    for (ChartDateValuePair p in widget.chartDateValuePairList) {
      if (p.point.dy > _maxAltitude) {
        _maxAltitude = p.point.dy;
      } else if (p.point.dy < _minAltitude) {
        _minAltitude = p.point.dy;
      }
      // if (p.level > _maxLevel) {
      //   _maxLevel = p.level;
      // } else if (p.level < _minLevel) {
      //   _minLevel = p.level;
      // }
    }

    var maxDivide = (_maxAltitude - _minAltitude) == 0
        ? _maxAltitude
        : _maxAltitude - _minAltitude;
    if (maxDivide > 1000) {
      _maxVerticalAxisValue = (_maxAltitude / 1000.0).ceil() * 1000.0;
      _minVerticalAxisValue = (_minAltitude / 1000.0).floor() * 1000.0;
    } else if (maxDivide > 100) {
      _maxVerticalAxisValue = (_maxAltitude / 100.0).ceil() * 100.0;
      _minVerticalAxisValue = (_minAltitude / 100.0).floor() * 100.0;
    } else if (maxDivide > 10) {
      _maxVerticalAxisValue = (_maxAltitude / 10.0).ceil() * 10.0;
      _minVerticalAxisValue = (_minAltitude / 10.0).floor() * 10.0;
    } else if (maxDivide > 1) {
      _maxVerticalAxisValue = (_maxAltitude / 1.0).ceil() * 1.0;
      _minVerticalAxisValue = (_minAltitude / 1.0).floor() * 1.0;
    } else if (maxDivide > 0.1) {
      _maxVerticalAxisValue = (_maxAltitude / 0.1).ceil() * 0.1;
      _minVerticalAxisValue = (_minAltitude / 0.1).floor() * 0.1;
    } else if (maxDivide > 0.01) {
      _maxVerticalAxisValue = (_maxAltitude / 0.01).ceil() * 0.01;
      _minVerticalAxisValue = (_minAltitude / 0.01).floor() * 0.01;
    } else if (maxDivide > 0.001) {
      _maxVerticalAxisValue = (_maxAltitude / 0.001).ceil() * 0.001;
      _minVerticalAxisValue = (_minAltitude / 0.001).floor() * 0.001;
    } else {
      _maxVerticalAxisValue = (_maxAltitude / 0.0001).ceil() * 0.0001;
      _minVerticalAxisValue = (_minAltitude / 0.0001).floor() * 0.0001;
    }

    _verticalAxisInterval =
        (_maxVerticalAxisValue - _minVerticalAxisValue) / 5.0;
    var absVerticalAxisInterval = _verticalAxisInterval.abs();
    if (absVerticalAxisInterval > 1000) {
      _verticalAxisInterval = (_verticalAxisInterval / 1000.0).floor() * 1000.0;
    } else if (absVerticalAxisInterval > 100) {
      _verticalAxisInterval = (_verticalAxisInterval / 100.0).floor() * 100.0;
    } else if (absVerticalAxisInterval > 10) {
      _verticalAxisInterval = (_verticalAxisInterval / 10.0).floor() * 10.0;
    } else if (absVerticalAxisInterval > 1) {
      _verticalAxisInterval = (_verticalAxisInterval / 1.0).floor() * 1.0;
    } else if (absVerticalAxisInterval > 0.1) {
      _verticalAxisInterval = (_verticalAxisInterval / 0.1).floor() * 0.1;
    } else if (absVerticalAxisInterval > 0.01) {
      _verticalAxisInterval = (_verticalAxisInterval / 0.01).floor() * 0.01;
    } else if (absVerticalAxisInterval > 0.001) {
      _verticalAxisInterval = (_verticalAxisInterval / 0.001).floor() * 0.001;
    } else {
      _verticalAxisInterval = (_verticalAxisInterval / 0.0001).floor() * 0.0001;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          bool forceRepaint = _adjustResize(constraints.biggest);

          Widget thumbnailController;
          if (widget.slidingBarVisible) {
            thumbnailController = _buildThumbController();
          } else {
            thumbnailController = Wrap();
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: SizedBox.expand(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: _onScaleUpdate,
                    onScaleEnd: _onScaleEnd,
                    child: CustomPaint(
                      painter: AltitudePainter(
                        widget.chartDateValuePairList,
                        _maxAltitude,
                        _minAltitude,
                        _maxVerticalAxisValue,
                        _minVerticalAxisValue,
                        _verticalAxisInterval,
                        _scale,
                        widget.maxScale,
                        _offsetX,
                        animatedValue: widget.animation.value,
                        maxLevel: _maxLevel,
                        minLevel: _minLevel,
                        axisLineColor: widget.axisLineColor,
                        axisTextColor: widget.axisTextColor,
                        gradientColors: widget.gradientColors,
                        pathColor: widget.pathColor,
                        forceRepaint: forceRepaint,
                      ),
                    ),
                  ),
                ),
              ),
              thumbnailController,
            ],
          );
        });
      },
    );
  }

  Widget _buildThumbController() {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: Stack(
        children: <Widget>[
          // the divider on the top
          const Divider(
            height: 1.0,
            color: kSlidingBtnScrimColor,
          ),
          // the thumbnail graph of altitude graph
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(
              left: SLIDING_BTN_WIDTH,
              right: SLIDING_BTN_WIDTH,
            ),
            child: CustomPaint(
              painter: AltitudeThumbnailPainter(
                widget.chartDateValuePairList,
                _maxVerticalAxisValue,
                _minVerticalAxisValue,
                animatedValue: widget.animation.value,
              ),
            ),
          ),
          // blank space and drag to scrolling the graph
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(
              left: SLIDING_BTN_WIDTH + _leftSlidingBtnLeft,
              right: SLIDING_BTN_WIDTH + _rightSlidingBtnRight,
            ),
            child: GestureDetector(
              onHorizontalDragStart: _onSlidingBarHorizontalDragStart,
              onHorizontalDragUpdate: _onSlidingBarHorizontalDragUpdate,
              onHorizontalDragEnd: _onSlidingBarHorizontalDragEnd,
            ),
          ),
          // left sliding button
          Container(
            width: SLIDING_BTN_WIDTH + _leftSlidingBtnLeft,
            height: double.infinity,
            padding: EdgeInsets.only(left: _leftSlidingBtnLeft),
            color: kSlidingBtnScrimColor,
            child: GestureDetector(
              onHorizontalDragStart: _onLBHorizontalDragDown,
              onHorizontalDragUpdate: _onLBHorizontalDragUpdate,
              onHorizontalDragEnd: _onLBHorizontalDragEnd,
              child: Container(
                height: double.infinity,
                width: SLIDING_BTN_WIDTH,
                color: kSlidingBtnColor,
                child: Icon(Icons.chevron_left),
              ),
            ),
          ),
          // right sliding button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: SLIDING_BTN_WIDTH + _rightSlidingBtnRight,
              padding: EdgeInsets.only(right: _rightSlidingBtnRight),
              height: double.infinity,
              color: kSlidingBtnScrimColor,
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onHorizontalDragStart: _onRBHorizontalDragDown,
                onHorizontalDragUpdate: _onRBHorizontalDragUpdate,
                onHorizontalDragEnd: _onRBHorizontalDragEnd,
                child: Container(
                  height: double.infinity,
                  width: SLIDING_BTN_WIDTH,
                  color: kSlidingBtnColor,
                  child: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 计算偏移量, 默认放大时都是向右偏移的, 因此想在放大时保持比例, 就需要将缩放点移至0点
  /// 算法: 左偏移量L = 当前焦点f在之前图宽上的位置p带入到新图宽中再减去焦点f在屏幕上的位置
  double _calculateOffsetX(double newScale, double focusOnScreen) {
    // ratioInGraph 就是当前的焦点实际对应在之前的图宽上的比例
    var widgetWidth = context.size!.width;
    double ratioInGraph =
        (_offsetX.abs() + focusOnScreen) / (_scale * widgetWidth);
    // 现在新计算出的图宽
    double newTotalWidth = newScale * widgetWidth;
    // 将之前的比例带入当前的图宽即为焦点在新图上的位置
    double newLocationInGraph = ratioInGraph * newTotalWidth;
    // 最后用焦点在屏幕上的位置 - 在图上的位置就是图应该向左偏移的位置
    return focusOnScreen - newLocationInGraph;
  }

  _updateScaleAndScrolling(double newScale, double focusX,
      {double extraX = 0.0}) {
    var widgetWidth = context.size!.width;

    newScale = newScale.clamp(1.0, widget.maxScale);

    // 根据缩放焦点计算出left
    double left = _calculateOffsetX(newScale, focusX);

    // 加上额外的水平偏移量
    left += extraX;

    // 将x范围限制图表宽度内
    double newOffsetX = left.clamp((newScale - 1) * -widgetWidth, 0.0);

    // 根据缩放,同步缩略滑钮的状态
    var maxViewportWidth = widgetWidth - SLIDING_BTN_WIDTH * 2;
    double lOffsetX = -newOffsetX / newScale;
    double rOffsetX = ((newScale - 1) * widgetWidth + newOffsetX) / newScale;

    double r = maxViewportWidth / widgetWidth;
    lOffsetX *= r;
    rOffsetX *= r;

    setState(() {
      _scale = newScale;
      _offsetX = newOffsetX;
      _leftSlidingBtnLeft = lOffsetX;
      _rightSlidingBtnRight = rOffsetX;
    });
  }

  bool _adjustResize(Size size) {
    bool forceRepaint = false;
    if (!_lastSize.isEmpty && !size.isEmpty && _lastSize != size) {
      var ratio = size.width / _lastSize.width;
      var validWidth = (width) => width - SLIDING_BTN_WIDTH * 2.0;
      var slidingRatio = validWidth(size.width) / validWidth(_lastSize.width);

      _offsetX *= ratio;
      _leftSlidingBtnLeft *= slidingRatio;
      _rightSlidingBtnRight *= slidingRatio;
      forceRepaint = true;

      _resetFlingAnim();
    }
    _lastSize = size;
    return forceRepaint;
  }

  // ===========

  _onScaleStart(ScaleStartDetails details) {
    _focusPoint = details.focalPoint;
    _lastScaleValue = _scale;
    _lastUpdateFocalPoint = details.focalPoint;

    _resetFlingAnim();
  }

  _onScaleUpdate(ScaleUpdateDetails details) {
    double newScale = (_lastScaleValue * details.scale);

    var deltaPosition = (details.focalPoint - _lastUpdateFocalPoint);
    _lastUpdateFocalPoint = details.focalPoint;

    _updateScaleAndScrolling(newScale, _focusPoint!.dx,
        extraX: deltaPosition.dx);
  }

  double getOffset(double lastOffset) {
    return lastOffset % (_scale * context.size!.width);
  }

  _onScaleEnd(ScaleEndDetails details) {
    _fling(details.velocity.pixelsPerSecond.dx);
  }

  _fling(double velocity) {
    double lastOffset = _offsetX;
    double widgetWidth = context.size!.width;
    double maxOffset = -(_scale - 1) * widgetWidth;
    bool directionLeft = velocity > 0;
    double maxScrollX;
    if (directionLeft) {
      maxScrollX = _offsetX.abs();
    } else {
      maxScrollX = _offsetX - maxOffset;
    }

    if (velocity.isNaN || velocity == 0.0 || maxScrollX == 0.0) return;

    var distance = velocity.abs() / 10;
    var frictionSimulation =
        FrictionSimulation.through(0.0, distance, 20.0, 0.0);

    var scrollOffset = frictionSimulation.timeAtX(distance - 0.1);
    scrollOffset = scrollOffset.clamp(0.0, maxScrollX);
    animation =
        Tween<double>(begin: 0.0, end: scrollOffset).animate(controller!);

    listener = () {
      if (animation?.value == 0.0) return;
      var value = frictionSimulation.x(animation!.value);

      // 计算出新的偏移量X, 如果新偏移超过了最大值, 就停止动画
      var newOffsetX;
      if (directionLeft) {
        newOffsetX = value + lastOffset;
        if (newOffsetX > 0.0) {
          newOffsetX = 0.0;
          _resetFlingAnim();
        }
      } else {
        newOffsetX = -value + lastOffset;
        if (newOffsetX < maxOffset) {
          newOffsetX = maxOffset;
          _resetFlingAnim();
        }
      }

      // 同步缩略滑钮的状态
      var maxViewportWidth = widgetWidth - SLIDING_BTN_WIDTH * 2;
      double r = maxViewportWidth / widgetWidth;
      double lOffsetX = -newOffsetX / _scale * r;
      double rOffsetX = ((_scale - 1) * widgetWidth + newOffsetX) / _scale * r;

      setState(() {
        _offsetX = newOffsetX;
        _leftSlidingBtnLeft = lOffsetX;
        _rightSlidingBtnRight = rOffsetX;
      });
    };

    animation!.addListener(listener!);

    controller!.forward(from: 0.0);
  }

  _resetFlingAnim() {
    animation?.removeListener(listener!);
    controller?.reset();
  }

  // =========== 左边按钮的滑动操作

  _onLBHorizontalDragDown(DragStartDetails details) {
    _lastLeftSlidingBtnLeft = details.globalPosition.dx - _leftSlidingBtnLeft;
    _resetFlingAnim();
  }

  _onLBHorizontalDragUpdate(DragUpdateDetails details) {
    var widgetWidth = context.size!.width;
    var maxViewportWidth = widgetWidth - SLIDING_BTN_WIDTH * 2;

    var newLOffsetX = details.globalPosition.dx - _lastLeftSlidingBtnLeft;

    // 根据最大缩放倍数, 限制滑动的最大距离.
    // Viewport: 窗口指的是两个滑块(不含滑块自身)中间的内容, 即左滑钮的右边到右滑钮的左边的距离.
    // 最大窗口宽 / 最大倍数 = 最小的窗口宽.
    double minViewportWidth = maxViewportWidth / widget.maxScale;
    // 最大窗口宽 - 最小窗口宽 - 当前右边的偏移量 = 当前左边的最大偏移量
    double maxLeft =
        maxViewportWidth - minViewportWidth - _rightSlidingBtnRight;
    newLOffsetX = newLOffsetX.clamp(0.0, maxLeft);

    // 得到当前的窗口大小
    double viewportWidth =
        maxViewportWidth - newLOffsetX - _rightSlidingBtnRight;
    // 最大窗口大小 / 当前窗口大小 = 应该缩放的倍数
    double newScale = maxViewportWidth / viewportWidth;
    // 计算缩放后的左偏移量
    double newOffsetX = _calculateOffsetX(newScale, widgetWidth);

    setState(() {
      _leftSlidingBtnLeft = newLOffsetX;
      _scale = newScale;
      _offsetX = newOffsetX;
    });
  }

  _onLBHorizontalDragEnd(DragEndDetails details) {}

  // =========== 右边按钮的滑动操作

  _onRBHorizontalDragDown(DragStartDetails details) {
    _lastRightSlidingBtnRight =
        details.globalPosition.dx + _rightSlidingBtnRight;
    _resetFlingAnim();
  }

  _onRBHorizontalDragUpdate(DragUpdateDetails details) {
    var widgetWidth = context.size!.width;
    var maxViewportWidth = widgetWidth - SLIDING_BTN_WIDTH * 2;

    var newROffsetX = _lastRightSlidingBtnRight - details.globalPosition.dx;

    // 根据最大缩放倍数, 限制滑动的最大距离.
    // Viewport: 窗口指的是两个滑块(不含滑块自身)中间的内容, 即左滑钮的右边到右滑钮的左边的距离.
    // 最大窗口宽 / 最大倍数 = 最小的窗口宽.
    double minViewportWidth = maxViewportWidth / widget.maxScale;
    // 最大窗口宽 - 最小窗口宽 - 当前右边的偏移量 = 当前左边的最大偏移量
    double maxLeft = maxViewportWidth - minViewportWidth - _leftSlidingBtnLeft;
    newROffsetX = newROffsetX.clamp(0.0, maxLeft);

    // 得到当前的窗口大小
    double viewportWidth = maxViewportWidth - _leftSlidingBtnLeft - newROffsetX;
    // 最大窗口大小 / 当前窗口大小 = 应该缩放的倍数
    double newScale = maxViewportWidth / viewportWidth;
    // 计算缩放后的左偏移量
    double newOffsetX = _calculateOffsetX(newScale, 0.0);

    setState(() {
      _rightSlidingBtnRight = newROffsetX;
      _scale = newScale;
      _offsetX = newOffsetX;
    });
  }

  _onRBHorizontalDragEnd(DragEndDetails details) {}

  // =========== 滑钮中间的空白区域的拖拽操作

  _onSlidingBarHorizontalDragStart(DragStartDetails details) {
    _lastSlidingBarPosition = details.globalPosition.dx;
    _resetFlingAnim();
  }

  _onSlidingBarHorizontalDragUpdate(DragUpdateDetails details) {
    var widgetWidth = context.size!.width;

    // 得到本次滑动的偏移量, 乘倍数后和之前的偏移量相减等于新的偏移量
    var deltaX = (details.globalPosition.dx - _lastSlidingBarPosition);
    _lastSlidingBarPosition = details.globalPosition.dx;
    double left = _offsetX - deltaX * _scale;

    // 将x范围限制图表宽度内
    double newOffsetX = left.clamp((_scale - 1) * -widgetWidth, 0.0);

    // 同步缩略滑钮的状态
    var maxViewportWidth = widgetWidth - SLIDING_BTN_WIDTH * 2;
    double lOffsetX = -newOffsetX / _scale;
    double rOffsetX = ((_scale - 1) * widgetWidth + newOffsetX) / _scale;

    double r = maxViewportWidth / widgetWidth;
    lOffsetX *= r;
    rOffsetX *= r;

    setState(() {
      _offsetX = newOffsetX;
      _leftSlidingBtnLeft = lOffsetX;
      _rightSlidingBtnRight = rOffsetX;
    });
  }

  _onSlidingBarHorizontalDragEnd(DragEndDetails details) {}
}

const int VERTICAL_TEXT_WIDTH = 25;
const double DOTTED_LINE_WIDTH = 2.0;
const double DOTTED_LINE_INTERVAL = 2.0;

// ===== 用于保存帧的信息, 在单纯平移的操作时可以避免额外的绘制开销
ui.Picture? vAxisPicture;
ui.Picture? hAxisPicture;
ui.Picture? pathPicture;

_destroyPictures() {
  vAxisPicture = null;
  pathPicture = null;
  hAxisPicture = null;
}

class AltitudePainter extends CustomPainter {
  // ===== Data
  List<ChartDateValuePair> _altitudePointList;

  int maxLevel;
  int minLevel;

  double _maxAltitude = 0.0;
  double _minAltitude = 0.0;
  double _maxVerticalAxisValue;
  double _minVerticalAxisValue;
  double _verticalAxisInterval;

  double _scale = 1.0;
  double _maxScale = 1.0;
  double _offsetX = 0.0;

  double animatedValue;

  // ===== Paint
  // 海拔线的画笔
  Paint _linePaint;

  // 海拔线填充的画笔
  Paint _gradualPaint;

  // 关键点的画笔
  Paint _signPointPaint;

  // 竖轴水平虚线的画笔
  Paint _levelLinePaint;

  // 文字颜色
  Color axisTextColor;

  // 海拔线填充的梯度颜色
  List<Color> gradientColors;

  bool forceRepaint;

  AltitudePainter(
    this._altitudePointList,
    this._maxAltitude,
    this._minAltitude,
    this._maxVerticalAxisValue,
    this._minVerticalAxisValue,
    this._verticalAxisInterval,
    this._scale,
    this._maxScale,
    this._offsetX, {
    this.animatedValue = 1.0,
    this.maxLevel = 0,
    this.minLevel = 0,
    this.axisTextColor = kAxisTextColor,
    this.gradientColors = kAltitudeGradientColors,
    Color pathColor = kAltitudePathColor,
    Color axisLineColor = kVerticalAxisDottedLineColor,
    this.forceRepaint = false,
  })  : _linePaint = Paint()
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke
          ..color = pathColor,
        _gradualPaint = Paint()
          ..isAntiAlias = false
          ..style = PaintingStyle.fill,
        _signPointPaint = Paint(),
        _levelLinePaint = Paint()
          ..strokeWidth = 1.0
          ..isAntiAlias = false
          ..color = axisLineColor
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    if (_altitudePointList.isEmpty) return;

    // 30 是给上下留出的距离, 这样竖轴的最顶端的字就不会被截断, 下方可以用来显示横轴的字
    Size availableSize = Size(size.width, size.height - 30.0);

    // 50 是给左右留出间距, 避免标签上的文字被截断, 同时避免线图覆盖竖轴的字
    Size pathSize =
        Size(availableSize.width * _scale - 50, availableSize.height);

    // 高度 +2 是为了将横轴文字置于底部并加一个 marginTop.
    double hAxisTransY = availableSize.height + 2;

    // 向下滚动15的距离给顶部留出空间
    canvas.translate(0.0, 15.0);

    // 绘制竖轴
    if (vAxisPicture == null) {
      var pictureRecorder = ui.PictureRecorder();
      _drawVerticalAxis(Canvas(pictureRecorder), availableSize);
      vAxisPicture = pictureRecorder.endRecording();
    }

    canvas.save();
    canvas.drawPicture(vAxisPicture!);
    canvas.restore();

    // 绘制线图
    if (pathPicture == null) {
      var pictureRecorder = ui.PictureRecorder();
      _drawLines(Canvas(pictureRecorder), pathSize);
      pathPicture = pictureRecorder.endRecording();
    }

    canvas.save();
    // 剪裁绘制的窗口, 节省绘制的开销. -24 是为了避免覆盖纵轴
    canvas.clipRect(
        Rect.fromPoints(Offset.zero, Offset(size.width - 24, size.height)));
    // _offset.dx通常都是向左偏移的量 +15 是为了避免关键点 Label 的文字被截断
    canvas.translate(_offsetX + 15, 0.0);
    canvas.drawPicture(pathPicture!);
    canvas.restore();

    // 绘制横轴
    if (hAxisPicture == null) {
      var pictureRecorder = ui.PictureRecorder();
      _drawHorizontalAxis(
          Canvas(pictureRecorder), availableSize.width, pathSize.width);
      hAxisPicture = pictureRecorder.endRecording();
    }

    canvas.save();
    // 剪裁绘制窗口, 减少绘制时的开销.
    canvas.clipRect(Rect.fromPoints(
        Offset(0.0, hAxisTransY), Offset(size.width, size.height)));
    // x偏移和线图对应上, y偏移将绘制点挪到底部
    canvas.translate(_offsetX + 15, hAxisTransY);
    canvas.drawPicture(hAxisPicture!);
    canvas.restore();
  }

  /// =========== 绘制纵轴部分
  /// 绘制背景数轴
  /// 根据最大高度和间隔值计算出需要把纵轴分成几段
  void _drawVerticalAxis(Canvas canvas, Size size) {
    // 节点的数量
    var nodeCount =
        (_maxVerticalAxisValue - _minVerticalAxisValue) / _verticalAxisInterval;

    var interval = size.height / nodeCount;

    canvas.save();
    for (int i = 0; i <= nodeCount; i++) {
      var label = (_maxVerticalAxisValue - (_verticalAxisInterval * i)).toInt();
      _drawVerticalAxisLine(canvas, size, label.toString(), i * interval);
    }
    canvas.restore();
  }

  /// 绘制数轴的一行
  void _drawVerticalAxisLine(
      Canvas canvas, Size size, String text, double height) {
    var tp = _newVerticalAxisTextPainter(text)..layout();

    // 绘制虚线
    // 虚线的宽度 = 可用宽度 - 文字宽度 - 文字宽度的左右边距
    var dottedLineWidth = size.width - VERTICAL_TEXT_WIDTH;
    _levelLinePaint.color =
        _levelLinePaint.color.withOpacity(animatedValue.clamp(0.0, 1.0));
    canvas.drawPath(
        _newDottedLine(
            dottedLineWidth, height, DOTTED_LINE_WIDTH, DOTTED_LINE_INTERVAL),
        _levelLinePaint);

    // 绘制虚线右边的Text
    // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
    var textLeft = size.width - tp.width - 3;
    tp.paint(canvas, Offset(textLeft, height - tp.height / 2));
  }

  /// 生成虚线的Path
  Path _newDottedLine(
      double width, double y, double cutWidth, double interval) {
    var path = Path();
    var d = width / (cutWidth + interval);
    path.moveTo(0.0, y);
    for (int i = 0; i < d; i++) {
      path.relativeLineTo(cutWidth, 0.0);
      path.relativeMoveTo(interval, 0.0);
    }
    return path;
  }

  TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  /// 生成纵轴文字的TextPainter
  TextPainter _newVerticalAxisTextPainter(String text) {
    return textPainter
      ..text = TextSpan(
        text: text,
        style: TextStyle(
          color: axisTextColor.withOpacity(animatedValue.clamp(0.0, 1.0)),
          fontSize: 8.0,
        ),
      );
  }

  void _drawHorizontalAxis(
      Canvas canvas, double viewportWidth, double totalWidth) {
    Offset? lastPoint = _altitudePointList.last.point;
    //if (lastPoint == null) return;

    double ratio = viewportWidth / totalWidth;
    double intervalAtDistance = lastPoint.dx * ratio / 6.0;
    int intervalAtHAxis;
    if (intervalAtDistance >= 100.0) {
      intervalAtHAxis = (intervalAtDistance / 100.0).ceil() * 100;
    } else if (intervalAtDistance >= 10) {
      intervalAtHAxis = (intervalAtDistance / 10.0).ceil() * 10;
    } else {
      intervalAtHAxis = (intervalAtDistance / 5.0).ceil() * 5;
    }
    double hAxisIntervalScale = intervalAtHAxis.toDouble() / intervalAtDistance;
    double intervalAtScreen = viewportWidth / 6.0 * hAxisIntervalScale;

    double count = totalWidth / intervalAtScreen;
    for (int i = 0; i <= count; i++) {
      _drawHorizontalAxisLine(
        canvas,
        "${i * intervalAtHAxis}",
        i * intervalAtScreen,
      );
    }
  }

  /// 绘制数轴的一行
  void _drawHorizontalAxisLine(Canvas canvas, String text, double width) {
    var tp = _newVerticalAxisTextPainter(text)..layout();
    var textLeft = width + tp.width / -2;
    tp.paint(canvas, Offset(textLeft, 0.0));
  }

  /// =========== 绘制海拔图连线部分
  double lastGradientTop = 0.0;

  /// 绘制海拔图连线部分
  void _drawLines(Canvas canvas, Size size) {
    var pointList = _altitudePointList;
    if (pointList == null || pointList.isEmpty) return;

    double ratioX = size.width / pointList.last.point.dx;
    double ratioY =
        size.height / (_maxVerticalAxisValue - _minVerticalAxisValue);

    var path = Path();

    var calculateDy = (double dy) {
      return size.height -
          (dy - _minVerticalAxisValue) * ratioY * animatedValue;
    };

    var firstPoint = pointList.first.point;
    path.moveTo(firstPoint.dx * ratioX, calculateDy(firstPoint.dy));
    for (var p in pointList) {
      path.lineTo(p.point.dx * ratioX, calculateDy(p.point.dy));
    }

    // 绘制线条下面的渐变部分
    double gradientTop = size.height -
        ratioY * (_maxAltitude - _minVerticalAxisValue) * animatedValue;
    if (lastGradientTop != gradientTop) {
      lastGradientTop = gradientTop;
      _gradualPaint.shader = ui.Gradient.linear(
          Offset(0.0, gradientTop), Offset(0.0, size.height), gradientColors);
    }
    _drawGradualShadow(path, size, canvas);

    // 先绘制渐变再绘制线,避免线被遮挡住
    canvas.drawPath(path, _linePaint);

    //_drawLabel(canvas, size.height, pointList, ratioX, ratioY);
  }

  void _drawGradualShadow(Path path, Size size, Canvas canvas) {
    var gradualPath = Path.from(path);
    gradualPath.lineTo(gradualPath.getBounds().width, size.height);
    gradualPath.relativeLineTo(-gradualPath.getBounds().width, 0.0);

    canvas.drawPath(gradualPath, _gradualPaint);
  }

  // void _drawLabel(Canvas canvas, double height, List<AltitudePoint> pointList,
  //     double ratioX, double ratioY) {
  //   // 绘制关键点及文字
  //   canvas.save();
  //   canvas.translate(0.0, height);
  //   double ratioInScaling = _scale / _maxScale * 10.0;
  //   for (var p in pointList) {
  //     //if (p.name == null || p.name.isEmpty) continue;

  //     // maxLevel
  //     double levelLimit =
  //         (maxLevel - minLevel) - ratioInScaling * (maxLevel - minLevel);
  //     if (p.level < levelLimit) continue;

  //     double labelScale = p.level - levelLimit;
  //     labelScale = (labelScale * 3.0).clamp(0.0, 1.0);
  //     // 让Label在跟随动画显示/隐藏, max() 避免为0导致1.0/0报错
  //     labelScale = max(labelScale * animatedValue, 0.01);

  //     // 由于我们不能直接缩放文字的字号, 所以我们采用缩放canvas的方式
  //     // canvas缩小后, 面积会增大, 绘制的位置就会变化.
  //     // 为了让绘制的点还是在原来的位置, 我们将 ratioX/Y 的值放大 n 倍(n取决于我们将canvas缩小了多少)
  //     // 举例: 默认canvas是300 * 500, labelScale=0.5时canvas=600*1000.
  //     // 因此我们将 ratioX/Y 放大2倍 (通过 1/0.5 得到), 这样计算偏移量时就能对应上海拔路径的点了.
  //     canvas.save();
  //     canvas.scale(labelScale);
  //     double scale4Offset = (1.0 / labelScale);
  //     double scaledRatioX = ratioX * scale4Offset;
  //     double scaledRatioY = ratioY * scale4Offset;

  //     // 将海拔的值换算成在屏幕上的值
  //     double yInScreen =
  //         (p.point.dy - _minVerticalAxisValue) * scaledRatioY * animatedValue;

  //     // ==== 绘制关键点
  //     _signPointPaint.color = p.color;
  //     canvas.drawCircle(
  //         Offset(p.point.dx * scaledRatioX, -yInScreen), 2.0, _signPointPaint);

  //     // ==== 绘制文字及背景

  //     var tp = p.textPainter;
  //     var left = p.point.dx * scaledRatioX - tp.width / 2;

  //     // 如果label接近顶端, 调换方向, 避免label看不见
  //     double bgTop = yInScreen + tp.height + 8;
  //     double bgBottom = yInScreen + 4;
  //     double textTop = yInScreen + tp.height + 6;
  //     if (height * scale4Offset - bgTop < 0) {
  //       bgTop = yInScreen - tp.height - 8;
  //       bgBottom = yInScreen - 4;
  //       textTop = yInScreen - 6;
  //     }
  //     // 绘制文字的背景框
  //     canvas.drawRRect(
  //         RRect.fromLTRBXY(
  //           left - 2,
  //           -bgTop,
  //           left + tp.width + 2,
  //           -bgBottom,
  //           tp.width / 2.0,
  //           tp.width / 2.0,
  //         ),
  //         _signPointPaint);

  //     // 绘制文字
  //     tp.paint(canvas, Offset(left, -textTop));
  //     canvas.restore();
  //   }

  //   canvas.restore();
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 如果是没有上一帧, 或者父控件要求强制重绘, 则
    if (oldDelegate == null || forceRepaint) {
      _destroyPictures();
      return true;
    }

    var ap = oldDelegate as AltitudePainter;
    if (_altitudePointList != ap._altitudePointList) {
      // 如果数据改变, 需要完全重新绘制
      _destroyPictures();
      return true;
    } else if (animatedValue != ap.animatedValue) {
      // 如果动画发生改变, 需要完全重新绘制
      _destroyPictures();
      return true;
    } else if (_scale != ap._scale) {
      // 如果缩放发生改变, 仅需要重绘Path和横轴, 纵轴不需要重绘
      pathPicture = null;
      hAxisPicture = null;
      return true;
    } else if (_offsetX != ap._offsetX) {
      // 如果只是简单的平移操作, 只需要按照之前帧保留下来的的picture对canvas进行平移即可
      return true;
    }

    return false;
  }
}

class AltitudeThumbnailPainter extends CustomPainter {
  // ===== Data
  final List<ChartDateValuePair> _chartDateValuePairList;

  final double _maxVerticalAxisValue;
  final double _minVerticalAxisValue;

  // ===== Paint
  final Paint _linePaint = Paint()
    ..color = kAltitudeThumbnailPathColor
    ..isAntiAlias = false
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

  final Paint _gradualPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = false
    ..color = kAltitudeThumbnailGradualColor;

  double animatedValue;

  AltitudeThumbnailPainter(
    this._chartDateValuePairList,
    this._maxVerticalAxisValue,
    this._minVerticalAxisValue, {
    this.animatedValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawLines(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate == null) return true;

    var atp = oldDelegate as AltitudeThumbnailPainter;
    if (atp.animatedValue != animatedValue ||
        atp._chartDateValuePairList != _chartDateValuePairList) return true;
    return false;
  }

  /// =========== 绘制海拔图连线部分
  /// 绘制海拔图连线部分
  void _drawLines(Canvas canvas, Size size) {
    var pointList = _chartDateValuePairList;
    if (pointList == null || pointList.isEmpty) return;

    // 将原点挪到以纵坐标的0点所在的位置, 向下为负, 向上为正. 这样可以绘制出负海拔的区域
    double ratioAtAll =
        _minVerticalAxisValue / (_maxVerticalAxisValue - _minVerticalAxisValue);
    double h = size.height + ratioAtAll * size.height;

    double ratioX = size.width * 1.0 / pointList.last.point.dx; //  * scale
    double ratioY = h / _maxVerticalAxisValue;

    var firstPoint = pointList.first.point;
    var path = Path();
    path.moveTo(firstPoint.dx * ratioX, h - firstPoint.dy * ratioY);
    for (var p in pointList) {
      path.lineTo(p.point.dx * ratioX, h - p.point.dy * ratioY);
    }

    // 绘制线条下面的渐变部分
    _drawGradualShadow(path, size, canvas);

    // 先绘制渐变再绘制线,避免线被遮挡住
    canvas.save();
    _linePaint.color =
        _linePaint.color.withOpacity(animatedValue.clamp(0.0, 1.0));
    canvas.drawPath(path, _linePaint);
    canvas.restore();
  }

  void _drawGradualShadow(Path path, Size size, Canvas canvas) {
    var gradualPath = Path();
    gradualPath.addPath(path, Offset.zero);
    gradualPath.lineTo(gradualPath.getBounds().width, size.height);
    gradualPath.relativeLineTo(-gradualPath.getBounds().width, 0.0);

    canvas.save();
    var opacity = animatedValue.clamp(0.0, 1.0);
    _gradualPaint.color = _gradualPaint.color.withOpacity(opacity);
    canvas.drawPath(gradualPath, _gradualPaint);
    canvas.restore();
  }
}
