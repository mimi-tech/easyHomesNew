class MyFlutterWaveError implements Exception {
  String message;

  MyFlutterWaveError(this.message);

  String toString() {
    return "Flutterwave Error: ${this.message}";
  }
}
