import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/features/profile/presentation/components/camera_dialog.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class VerificationVideo extends StatefulWidget {
  final String? verificationCode;
  final bool loadingVerificationCode;
  final bool isUploadingVideo;
  final String? profileVerificationVideo;
  final Function(File? createdLocalVideoFile) onChanged;
  final File? localVideoFile;
  final Function(String err) onCameraError;
  const VerificationVideo(
      {Key? key,
      required this.verificationCode,
      required this.loadingVerificationCode,
      required this.isUploadingVideo,
      this.profileVerificationVideo,
      required this.onChanged,
      required this.localVideoFile,
      required this.onCameraError})
      : super(key: key);

  @override
  State<VerificationVideo> createState() => _VerificationVideoState();
}

class _VerificationVideoState extends State<VerificationVideo>
    with WidgetsBindingObserver {
  final Widget _progressIndicator = const Center(
    child: CircularProgress(),
  );

  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;

  @override
  void initState() {
    _reInitSelfieCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_cameraController == null || widget.verificationCode == null) {
          return;
        }
        _showRecorderPopUp();
      },
      child: CircleAvatar(
        backgroundColor: appTheme.colorScheme.primary,
        radius: 40,
        child: _isCameraInitialized
            ? Icon(
                Icons.video_camera_front_outlined,
                size: 32,
                color: appTheme.colorScheme.primaryContainer,
              )
            : _progressIndicator,
      ),
    );
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

  /// lifecycle
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
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      _reInitSelfieCamera();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// video recording
  bool _isShowingPopUp = false;
  void _showRecorderPopUp() async {
    if (_isShowingPopUp ||
        widget.verificationCode == null ||
        _cameraController == null) return;
    if (mounted) {
      setState(() {
        _isShowingPopUp = true;
      });
    }

    CameraDialogData? data = await showCameraDialog(
        context, widget.verificationCode!, _cameraController!);
    if (mounted) {
      setState(() {
        _isShowingPopUp = false;
      });
      if (data?.errorOccurred == true) {
        widget.onCameraError(failedToRecord);
      }
      if (data?.file != null) {
        widget.onChanged(File(data!.file!.path));
      }
    }
  }
}
