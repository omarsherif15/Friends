import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    print('dioHelper Initialized');
    dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,
        ));
  }

  static Future<Response> postData({
    Map<String, dynamic> ?data
  }) async
  {
    dio.options.headers =
    {
      'Content-Type': 'application/json',
      'Authorization': 'key = AAAAmSi89Xw:APA91bEVmsWwdhu467l_Oq5SyXGNqHbXFljGQJysWhm7RHNjaJdBNuwvzL1vhE88X7OAdlicrhZnwWyWcxsFlNhp9j11k2N7rzFu6AdLLKNcWeUnRvvqD9M_epjBy6ybiqE9FmQBvjVR '
    };
    return await dio.post(
        'https://fcm.googleapis.com/fcm/send',
      data: data,
    );
  }
}

