
import 'package:flutter/foundation.dart';

class Logger {
 static void log(dynamic msg){
      if(kDebugMode){
        print(msg);
      }
  }
}