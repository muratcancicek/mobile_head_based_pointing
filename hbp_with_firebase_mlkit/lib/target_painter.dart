import 'package:flutter/material.dart';
import 'pointer.dart';

class TargetPaint extends CustomPaint {
  final CustomPainter painter;

  TargetPaint({this.painter}) : super(painter: painter);
}

enum TargetShape {
  RectTarget,
  CircleTarget,
}

class Target {
  Paint _style;
  TargetShape _targetShape;
  var _shape;

  Target.fromRect(Rect rect, {Paint givenStyle}) {
    _targetShape = TargetShape.RectTarget;
    _shape = rect;
    if (givenStyle == null) {
      _style = Paint()
      ..color = Colors.purple;
    } else {
      _style = givenStyle;
    }
  }
  Target.fromCircle(Offset position, double radius, {Paint givenStyle}) {
    _targetShape = TargetShape.CircleTarget;
    _shape = [position, radius];
    if (givenStyle == null) {
      _style = Paint()
        ..color = Colors.lightGreen;
    } else {
      _style = givenStyle;
    }
  }

  bool contains(pointer) {
    if (_targetShape == TargetShape.RectTarget)
      return _shape.contains(pointer);
    else if (_targetShape == TargetShape.CircleTarget) {
      return (pointer - _shape[0]).distance < _shape[1];
    }
    else
      return false;
  }
  void draw(Canvas canvas, pointer) {
    if(contains(pointer))
      _style.color = Colors.white;
    if (_targetShape == TargetShape.RectTarget)
      canvas.drawRect(_shape, _style);
    else if (_targetShape == TargetShape.CircleTarget)
      canvas.drawCircle(_shape[0], _shape[1], _style);
  }
}

class TargetPainter extends CustomPainter {
  final Size imageSize;
  final Pointer _pointer;

 TargetPainter(this.imageSize, this._pointer);

  void _addCircle(Canvas canvas, Offset offset, Size size,
      {double radius: 0, Paint paint}) {
    if (paint == null) paint = Paint()..color = Colors.yellow;
    if (radius == 0) radius = size.width / 100;
    canvas.drawCircle(offset, radius, paint);
  }

  void _addPointer(Canvas canvas, Offset position, Size size) {
    final paintStyle = Paint()
      ..color = Colors.red
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    double radius = size.width / 20;
    _addCircle(canvas, position, size, radius: radius, paint: paintStyle);
  }

  void _addTargetGrid(Canvas canvas, Size size) {

    Offset pos1 = Offset(100, 100);
    Offset pos2 = Offset(100, 600);
    Offset pos3 = Offset(200, 580);
    Offset pos4 = Offset(300, 530);


    Target.fromCircle(pos1,  60).draw(canvas, _pointer.getPosition());
    Target.fromCircle(pos2,  60).draw(canvas, _pointer.getPosition());
    Target.fromCircle(pos3,  60).draw(canvas, _pointer.getPosition());
    Target.fromCircle(pos4,  60).draw(canvas, _pointer.getPosition());

  }

  @override
  void paint(Canvas canvas, Size size) {
//    Rect rect = Rect.fromLTRB(50, 100, 100, 150);
//    Target target = Target.fromRect(rect);
//    target.draw(canvas, _pointer.getPosition());
    _addTargetGrid(canvas, size);

    _addPointer(canvas, _pointer.getPosition(), size);
  }

  @override
  bool shouldRepaint(TargetPainter oldDelegate) {
    return imageSize != oldDelegate.imageSize || _pointer != oldDelegate._pointer;
  }
}
