// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flare_flutter/flare_actor.dart';

enum _Element {
  background,
}

final _lightTheme = {
  _Element.background: Colors.blue[100],
};

final _darkTheme = {
  _Element.background: Colors.blueGrey,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  String background = '';

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      switch (widget.model.weatherCondition) {
        case WeatherCondition.cloudy:
          background = 'third_party/cloudy.png';
          break;
        case WeatherCondition.foggy:
          background = 'third_party/foggy.png';
          break;
        case WeatherCondition.rainy:
          background = 'third_party/rainy.png';
          break;
        case WeatherCondition.snowy:
          background = 'third_party/snowy.png';
          break;
        case WeatherCondition.sunny:
          background = 'third_party/blank';
          break;
        case WeatherCondition.thunderstorm:
          background = 'third_party/thunderstorm.png';
          break;
        case WeatherCondition.windy:
          background = 'third_party/windy.png';
          break;
      }
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final day = Theme.of(context).brightness == Brightness.light
        ? 'third_party/sunny.png'
        : 'third_party/moon.png';
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    List<String> h = hour.split('');
    List<String> m = minute.split('');

    return Container(
      color: colors[_Element.background],
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
              alignment: Alignment.topCenter,
              child: Image.asset(
                day,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
              alignment: Alignment.topCenter,
              child: Image.asset(
                background,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 10, left: 10, top: 50, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlareActor(
                      "third_party/yoga_girl.flr",
                      animation: h[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: FlareActor(
                      "third_party/yoga_girl.flr",
                      animation: h[1],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: FlareActor(
                      "third_party/yoga_girl.flr",
                      animation: m[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: FlareActor(
                      "third_party/yoga_girl.flr",
                      fit: BoxFit.cover,
                      animation: m[1],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
