class OperationResult {
  bool errorOccurred;
  String? errorMessage;
  dynamic data;
  OperationResult({this.errorOccurred = false, this.data, this.errorMessage});
}

class OperationRealTimeResult {
  dynamic data;
  RealTimeEventType realTimeEventType;

  OperationRealTimeResult(
      {required this.data, required this.realTimeEventType});
}

enum RealTimeEventType { added, modified, deleted }
