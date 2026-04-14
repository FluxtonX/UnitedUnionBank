import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/image_picker_helper.dart';

class KycSelfieController extends GetxController {
  CameraController? cameraController;
  var isCameraInitialized = false.obs;
  var isTakingPicture = false.obs;
  var capturedImage = Rxn<File>();

  // Error handling states
  var hasError = false.obs;
  var errorMessage = "".obs;

  // Real-time status states
  var isFaceAligned = false.obs;
  var statusMessage = "Position your face in the circle".obs;

  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 1; // Default to front camera

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> retryInitialization() async {
    hasError.value = false;
    errorMessage.value = "";
    isCameraInitialized.value = false;
    
    // Ensure clean disposal before retry
    await cameraController?.dispose();
    cameraController = null;
    
    // Small delay to allow platform channels to settle
    await Future.delayed(const Duration(milliseconds: 300));
    
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      var status = await Permission.camera.request();

      if (status.isPermanentlyDenied) {
        hasError.value = true;
        errorMessage.value =
            "Camera permission is permanently denied. Please enable it in settings.";
        return;
      } else if (status.isDenied) {
        hasError.value = true;
        errorMessage.value =
            "Camera permission is required for face verification.";
        return;
      } else if (!status.isGranted) {
        hasError.value = true;
        errorMessage.value = "Camera permission state: ${status.name}";
        return;
      }

      cameras = await availableCameras();
      if (cameras.isEmpty) {
        hasError.value = true;
        errorMessage.value = "No cameras found on this device.";
        return;
      }

      // Try to find front camera
      int frontCameraIndex = cameras.indexWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
      );

      // Fallback to the first available camera if front camera is not found
      selectedCameraIndex = frontCameraIndex != -1 ? frontCameraIndex : 0;

      await _setupController(cameras[selectedCameraIndex]);

      // Simulate "Alignment" detection after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (!hasError.value) {
          isFaceAligned.value = true;
          statusMessage.value = "Face is perfectly aligned";
        }
      });
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to initialize camera: $e";
    }
  }

  Future<void> _setupController(CameraDescription description) async {
    cameraController = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Camera setup failed: $e";
    }
  }

  Future<void> takePicture() async {
    if (!isCameraInitialized.value || cameraController!.value.isTakingPicture)
      return;

    try {
      isTakingPicture.value = true;
      final XFile image = await cameraController!.takePicture();
      capturedImage.value = File(image.path);
    } catch (e) {
      Get.snackbar("Capture Error", "Failed to take selfie: $e");
    } finally {
      isTakingPicture.value = false;
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length < 2) return;

    isCameraInitialized.value = false;
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;

    await cameraController?.dispose();
    await _setupController(cameras[selectedCameraIndex]);
  }

  Future<void> pickFromGallery() async {
    final file = await ImagePickerHelper.pickFromGallery();
    if (file != null) {
      capturedImage.value = file;
    }
  }

  void resetCapture() {
    capturedImage.value = null;
    isFaceAligned.value = false;
    statusMessage.value = "Position your face in the circle";

    // Restart simulated alignment
    Future.delayed(const Duration(seconds: 2), () {
      if (capturedImage.value == null && !hasError.value) {
        isFaceAligned.value = true;
        statusMessage.value = "Face is perfectly aligned";
      }
    });
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
