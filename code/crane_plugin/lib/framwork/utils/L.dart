class L {
  static const bool online = const bool.fromEnvironment("dart.vm.product");

  static void log(Object message) {
    if (!online) {
      print(message);
    }
  }
}
