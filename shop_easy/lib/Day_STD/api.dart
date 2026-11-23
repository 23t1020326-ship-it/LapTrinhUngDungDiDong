import 'package:dio/dio.dart';

Future<void> main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  final response = await dio.get('/products', queryParameters: {'limit': 5});
  final List danhSach = response.data['products'];
  for (final sp in danhSach) {
    print('${sp['title']}: ${sp['price']} USD');
  }
}