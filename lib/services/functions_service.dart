import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<dynamic> callHello(Map<String, dynamic> data) async {
    final HttpsCallable callable = _functions.httpsCallable('hello');
    final result = await callable.call(data);
    return result.data;
  }
}


