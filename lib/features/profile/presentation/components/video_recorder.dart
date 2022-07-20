import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';
import 'package:video_player/video_player.dart';

class CameraRecorder extends StatefulWidget {
  final Function(String err) onCameraError;
  final String screenTitle;
  final String recordInstructions;
  final String? recordInstructionsExtra;
  final int maxVideoLen;
  const CameraRecorder(
      {Key? key,
      required this.onCameraError,
      required this.screenTitle,
      required this.recordInstructions,
      this.recordInstructionsExtra,
      this.maxVideoLen = 6})
      : super(key: key);

  @override
  State<CameraRecorder> createState() => _CameraRecorderState();
}

class _CameraRecorderState extends State<CameraRecorder>
    with WidgetsBindingObserver {
  //camera
  CameraController? _cameraController;
  VideoPlayerController? _videoController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  XFile? _recordedVideoXFile;
  bool _recordingInProgress = false;
  late Duration _timerCount;
  Timer? _countdownTimer;

  /// lifecycle
  @override
  void initState() {
    _reInitSelfieCamera();
    _timerCount = Duration(seconds: widget.maxVideoLen);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null ||
        _cameraController?.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      _cameraController?.dispose();
      _videoController?.pause();
      _videoController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      _reInitSelfieCamera();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _reInitSelfieCamera() async {
    if (_isCameraInitialized) return;

    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }

    if (_cameras.length < 2) {
      widget.onCameraError(failedToInitializeCamera);
      return;
    }

    // Dispose the previous controller if not null
    await _cameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _cameraController = CameraController(
          _cameras[1],
          ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
      });
      await _cameraController?.initialize();
      await _cameraController
          ?.lockCaptureOrientation(DeviceOrientation.portraitUp);
    }

    // Update UI if controller updated
    _cameraController?.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await _cameraController?.initialize();
    } on CameraException catch (_) {
      widget.onCameraError(failedToInitializeCamera);
      return;
    }

    if (mounted) {
      setState(() {
        bool isInit = _cameraController?.value.isInitialized == true;
        _isCameraInitialized = isInit;
      });
    }
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ScreenContainer(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: appTheme.colorScheme.onPrimary,
        backgroundColor: appTheme.colorScheme.primary,
        title: Text(
          widget.screenTitle,
        ),
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        decoration: BoxDecoration(color: appTheme.colorScheme.primary),
        constraints:
            BoxConstraints(minWidth: screenWidth, minHeight: screenHeight),
        child: Column(
            children: _videoController == null
                ? _videoRecorderWidgets(screenHeight)
                : _videoPlayerWidgets(screenHeight)),
      ),
    ));
  }

  List<Widget> _videoRecorderWidgets(double screenHeight) =>
      (_cameraController != null)
          ? [
              Expanded(child: _buildCameraPreview(screenHeight)),
              _buildRecorderInstructions(),
              _buildRecorderIcon(),
              _buildRecorderCounter()
            ]
          : [];

  List<Widget> _videoPlayerWidgets(double screenHeight) => [
        Expanded(child: _buildVideoPlayer(screenHeight)),
        _buildVideoPlayerActions()
      ];

  /// RECORDER UI ** note that the max height is set for each
  Widget _buildCameraPreview(double screenHeight) {
    if (_cameraController == null) return const SizedBox.shrink();
    return CameraPreview(_cameraController!);
  }

  Widget _buildRecorderInstructions() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 50),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: widget.recordInstructions,
            style: appTextTheme.headline5
                ?.copyWith(color: appTheme.colorScheme.onPrimary),
            children: <TextSpan>[
              TextSpan(
                  text: widget.recordInstructionsExtra ?? '',
                  style: appTextTheme.headline2
                      ?.copyWith(color: appTheme.colorScheme.inversePrimary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecorderIcon() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 50),
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.video_camera_front_rounded,
            size: 40,
            color: _recordingInProgress
                ? appTheme.colorScheme.inversePrimary
                : Colors.white,
          ),
          onPressed: () {
            _onClickRecord();
          },
        ),
      ),
    );
  }

  Widget _buildRecorderCounter() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 50),
      child: _recordingInProgress
          ? Center(
              child: Text(
                "00:0${_timerCount.inSeconds}",
                style: appTextTheme.headline4
                    ?.copyWith(color: appTheme.colorScheme.onPrimary),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }

  /// TIMER HANDLER
  _stopTimerAndReset() {
    setState(() {
      _countdownTimer!.cancel();
      _timerCount = Duration(seconds: widget.maxVideoLen);
    });
  }

  _setTimerAndAutoStop() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final seconds = _timerCount.inSeconds - 1;
      setState(() {
        _timerCount = Duration(seconds: seconds);
      });
      if (seconds <= 0) {
        _stopTimerAndReset();
        await _stopVideoRecordingAndPop();
      }
    });
  }

  /// RECORDER CONTROL
  bool _isRecordingVideo() => _cameraController?.value.isRecordingVideo == true;
  _startVideoRecording() async {
    if (_isRecordingVideo()) {
      return;
    }
    try {
      await _cameraController?.startVideoRecording();
      setState(() {
        _recordingInProgress = true;
      });
    } on CameraException catch (e) {
      _popOnError(e);
    }
  }

  _stopVideoRecordingAndPop() async {
    if (!_isRecordingVideo()) {
      // Recording is already is stopped state
      return;
    }
    try {
      XFile? file = await _cameraController?.stopVideoRecording();
      setState(() {
        _recordingInProgress = false;
      });

      _onVideoRecorded(file);
    } on CameraException catch (e) {
      _popOnError(e);
    }
  }

  _onClickRecord() async {
    if (_isRecordingVideo()) {
      //stop recording
      _stopTimerAndReset();
      await _stopVideoRecordingAndPop();
    } else {
      //start recording
      await _startVideoRecording();
      _setTimerAndAutoStop();
    }
  }

  ///VIDEO PLAY
  _onVideoRecorded(XFile? file) async {
    if (file != null) {
      File videoFile = File(file.path);
      /*TODO?
             final directory = await getApplicationDocumentsDirectory();
             String fileFormat = videoFile.path.split('.').last;
             VideoFile videoFile = await videoFile.copy(
             '${directory.path}/$currentUnix.$fileFormat',
             ); */
      if (mounted) {
        setState(() {
          _videoController = VideoPlayerController.file(videoFile);
        });
        _playVideo();
      }
    }
  }

  _playVideo() async {
    await _videoController?.initialize().then((_) {});
    await _videoController?.setLooping(true);
    await _videoController?.play();
  }

  _stopVideoAndReset() async {
    await _videoController?.pause();
    await _videoController?.dispose();
    if (mounted) {
      setState(() {
        _videoController = null;
      });
    }
  }

  Widget _buildVideoPlayer(double screenHeight) {
    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: VideoPlayer(_videoController!),
    );
  }

  _buildVideoPlayerActions() {
    //TODO
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                _stopVideoAndReset();
              },
              icon: Icon(
                Icons.cancel,
                color: appTheme.colorScheme.onPrimary,
                size: 32,
              )),
          const VerticalDivider(
            width: paddingMd,
          ),
          IconButton(
              onPressed: () {
                _popOnSuccess();
              },
              icon: Icon(
                Icons.check_circle,
                color: appTheme.colorScheme.onPrimary,
                size: 32,
              )),
        ],
      ),
    );
  }

  /// WHEN DONE
  _popOnError(CameraException e) {
    if (mounted) {
      Navigator.of(context)
          .pop(CameraDialogData(errorOccurred: true, errorMsg: "$e"));
    }
  }

  //TODO
  _popOnSuccess() {
    if (mounted) {
      Navigator.of(context).pop(CameraDialogData(file: _recordedVideoXFile));
    }
  }
}

class CameraDialogData {
  bool errorOccurred;
  String? errorMsg;
  XFile? file;

  CameraDialogData({this.errorOccurred = false, this.errorMsg, this.file});
}
