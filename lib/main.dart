import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
// import 'landingpage/landing_page.dart';
import 'main_page.dart';

Future<void> main() async {
  /* 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();
  */

  // runApp() 호출 전 Naver SDK 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'z9jmv2brtn');

  /* runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '45a9d085db24cf2b545703b637282378',
    javaScriptAppKey: 'b92b34d105527ca42e31d3ca4d692579',
  );
  */
  LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  /*
  print(position);
  print(position);
  print(position);
  print(position);
  print(position);
  print(position);
  print(position);
  */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MainPage(),  //원래는 랜딩페이지
    );
  }
}