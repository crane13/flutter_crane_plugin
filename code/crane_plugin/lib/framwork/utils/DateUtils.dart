// import 'package:intl/intl.dart';
//
// class DatesUtils {
//   static const FORMAT_YY_MM_DD_HH_MM = 'yyyy-MM-dd HH:mm';
//   static const FORMAT_YY_MM_DD = 'yyyy-MM-dd';
//   static const FORMAT_YY_MM = 'yyyy-MM';
//   static const FORMAT_YY = 'yyyy';
//
//   static String formatDate(DateTime dateTime) {
//     if (dateTime != null) {
//       return DateFormat(FORMAT_YY_MM_DD_HH_MM).format(dateTime);
//     }
//     return '';
//   }
//
//   static String formatDateMIllTIme(int millSecond,
//       {String format = FORMAT_YY_MM_DD_HH_MM}) {
//     try {
//       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millSecond);
//       if (dateTime != null) {
//         return DateFormat(format).format(dateTime);
//       }
//     } catch (e) {}
//
//     return '';
//   }
// }
