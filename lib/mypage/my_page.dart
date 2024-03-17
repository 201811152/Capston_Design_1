import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../landingpage/landing_page.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String _nickname = '';
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      setState(() {
        _nickname = user.kakaoAccount?.profile?.nickname ?? '';
        _profileImageUrl = user.kakaoAccount?.profile?.profileImageUrl ?? '';
      });
    } catch (e) {
      print('Failed to get user info: $e');
    }
  }


  Future<void> _logout() async {
    try {
      await UserApi.instance.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    } catch (e) {
      print('Failed to logout: $e');
    }
  }

  Future<void> _unlinkKakaoAccount() async {
    try {
      await UserApi.instance.unlink();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    } catch (e) {
      print('Failed to unlink Kakao account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          if (_profileImageUrl.isNotEmpty)
            CircleAvatar(
              backgroundImage: NetworkImage(_profileImageUrl),
              radius: 60,
            ),
          SizedBox(height: 20),
          Text(
            _nickname,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(height: 20),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _logout,
                    child: Text('로그아웃'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade50,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _unlinkKakaoAccount,
                    child: Text('회원 탈퇴'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade50,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}