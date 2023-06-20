import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyStatic{

  static String hourAndMinute(Timestamp? timestamp){
    if(timestamp != null) {
      
      if(timestamp.toDate().day == DateTime.now().day){
        return DateFormat.Hm().format(timestamp.toDate());
      }else if(timestamp.toDate().day == DateTime.now().subtract(const Duration(days: 1)).day){
        return "Dün";
      }else{
         return DateFormat.yMd().format(timestamp.toDate());
      }
    }else{
      return "??:??";
    }

  }


}