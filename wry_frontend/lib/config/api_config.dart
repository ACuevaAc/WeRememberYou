import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _pcIp = '192.168.18.121'; 

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:8000/api';
    } else {
      return 'http://$_pcIp:8000/api';
    }
  }
}