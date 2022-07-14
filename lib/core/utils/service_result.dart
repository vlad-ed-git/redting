class OperationResult {
  bool errorOccurred;
  String? errorMessage;
  dynamic data;
  OperationResult({this.errorOccurred = false, this.data, this.errorMessage});
}
