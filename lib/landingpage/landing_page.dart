import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main_page.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _checkAccessTokenAndNavigate();
  }

  Future<void> _checkAccessTokenAndNavigate() async {
    try {
      AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
      if (tokenInfo.expiresIn != null && !tokenInfo.expiresIn!.isNegative) {
        // Access token is valid, navigate to MainPage
        _navigateToMainPage();
      }
    } catch (e) {
      // No valid access token found, stay on LandingPage
    }
  }

  Future<void> _loginWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      // 액세스 토큰 정보 확인
      AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
      print('토큰 정보: ${tokenInfo.id} ${tokenInfo.expiresIn}');

      // 로그인 성공 후 메인 페이지로 이동
      _navigateToMainPage();
    } catch (error) {
      print('카카오 로그인 실패 $error');

      // 로그인 실패 시 사용자에게 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패하였습니다. 다시 시도해주세요.'),
        ),
      );
    }
  }

  // 메인 페이지로 이동하는 메서드
  void _navigateToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[400]!, Colors.grey[700]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/map.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '맛집일지도',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loginWithKakao,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: SizedBox(
                  width: 200, // Set the width to match the image width
                  height: 50, // Set the height to match the image height
                  child: Image.asset('assets/images/kakao_login.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}