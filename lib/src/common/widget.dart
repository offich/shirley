import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void afterBuild(FrameCallback frameCallback) =>
    WidgetsBinding.instance.addPostFrameCallback(frameCallback);
