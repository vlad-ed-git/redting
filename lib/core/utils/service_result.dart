class RemoteServiceResult {
  bool errorOccurred;
  String? errorMessage;
  dynamic data;
  RemoteServiceResult(
      {this.errorOccurred = false, this.data, this.errorMessage});
}
