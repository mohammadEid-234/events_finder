
import 'package:flutter/foundation.dart';

class Logger {
 static void log(Object msg){
      if(kDebugMode){
        print(msg);
      }
  }
}