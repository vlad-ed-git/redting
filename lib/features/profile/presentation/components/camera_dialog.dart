import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

Future<CameraDialogData?> showCameraDialog(BuildContext context,
    String verificationCode, CameraController cameraController) async {
  final navigator = Navigator.of(context);
  CameraDialogData? data = await showDialog<CameraDialogData?>(
    context: context,
    builder: (BuildContext context) {
      final scale = 1 / (cameraController.value.aspectRatio);
      final screenSize = MediaQuery.of(context).size;
      final screenWidth = screenSize.width;
      final screenHeight = screenSize.height;

      //state holders
      bool recordingInProgress = false;
      Duration timerCount = const Duration(seconds: 6);
      Timer? countdownTimer;

      onVideoRecorded(XFile? file) {
        navigator.pop(CameraDialogData(file: file));
      }

      popOnError(CameraException e) {
        navigator.pop(CameraDialogData(errorOccurred: true, errorMsg: "$e"));
      }

      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        backgroundColor: appTheme.colorScheme.primary.withOpacity(0.1),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          bool _isRecordingVideo() => cameraController.value.isRecordingVideo;

          startVideoRecording() async {
            if (_isRecordingVideo()) {
              return;
            }
            try {
              await cameraController.startVideoRecording();
              setState(() {
                recordingInProgress = true;
              });
            } on CameraException catch (e) {
              popOnError(e);
            }
          }

          stopVideoRecordingAndPop() async {
            if (!_isRecordingVideo()) {
              // Recording is already is stopped state
              return;
            }
            try {
              XFile? file = await cameraController.stopVideoRecording();
              setState(() {
                recordingInProgress = false;
              });

              onVideoRecorded(file);
            } on CameraException catch (e) {
              popOnError(e);
            }
          }

          stopTimerAndReset() {
            setState(() {
              countdownTimer!.cancel();
              timerCount = const Duration(seconds: 6);
            });
          }

          setTimerAndAutoStop() {
            countdownTimer =
                Timer.periodic(const Duration(seconds: 1), (_) async {
              final seconds = timerCount.inSeconds - 1;
              setState(() {
                timerCount = Duration(seconds: seconds);
              });
              if (seconds <= 0) {
                stopTimerAndReset();
                await stopVideoRecordingAndPop();
              }
            });
          }

          onClickRecord() async {
            if (_isRecordingVideo()) {
              //stop recording
              stopTimerAndReset();
              await stopVideoRecordingAndPop();
            } else {
              //start recording
              await startVideoRecording();
              setTimerAndAutoStop();
            }
          }

          return Column(
            children: [
              Container(
                constraints: BoxConstraints(
                    minWidth: screenWidth, maxHeight: screenHeight * 0.7),
                child: AspectRatio(
                  aspectRatio: scale,
                  child: CameraPreview(cameraController),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: pleaseSay,
                  style: appTextTheme.headline5?.copyWith(color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                        text: verificationCode,
                        style: appTextTheme.headline2?.copyWith(
                            color: appTheme.colorScheme.inversePrimary)),
                  ],
                ),
              ),
              Center(
                child: IconButton(
                  icon: Icon(
                    Icons.video_camera_front_rounded,
                    size: 40,
                    color: recordingInProgress ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    onClickRecord();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingStd),
                child: recordingInProgress
                    ? Text(
                        "00:0${timerCount.inSeconds}",
                        style: appTextTheme.headline4
                            ?.copyWith(color: appTheme.colorScheme.primary),
                        textAlign: TextAlign.center,
                      )
                    : null,
              )
            ],
          );
        }),
      );
    },
  );
  return data;
}

class CameraDialogData {
  bool errorOccurred;
  String? errorMsg;
  XFile? file;

  CameraDialogData({this.errorOccurred = false, this.errorMsg, this.file});
}
