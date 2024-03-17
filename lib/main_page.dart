import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:foodmap2/searchpage/search_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mypage/my_page.dart';
//import 'package:foodmap/mypage/my_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    RandomScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('맛집일지도', style: TextStyle(color: Colors.white))),
        backgroundColor: Color(0xFFa1887F),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: '랜덤 게임',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFa1887F),
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Matrix4> transforms = List.generate(5, (_) => Matrix4.identity());
  late NaverMapController _mapController;
  NLocationOverlay? _locationOverlay;
  int _selectedCategoryIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        SizedBox(
          height: 100, // Adjust the height as needed
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryItem(0, 'assets/images/korea.png', '한식'),
              _buildCategoryItem(1, 'assets/images/western.png', '양식'),
              _buildCategoryItem(2, 'assets/images/japen.png', '일식'),
              _buildCategoryItem(3, 'assets/images/china.png', '중식'),
              _buildCategoryItem(4, 'assets/images/snack.png', '분식'),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 450,
          child: NaverMap(
            onMapReady: _onMapCreated,
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(int index, String imagePath, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
          // Apply the flinch effect to the selected category item
          transforms[index] = Matrix4.identity()..scale(0.9);
          // Reset the flinch effect after a short duration
          Future.delayed(Duration(milliseconds: 200), () {
            setState(() {
              transforms[index] = Matrix4.identity();
            });
          });
        });
        _onCategoryItemTapped(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 80, // Adjust the width as needed
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(_selectedCategoryIndex == index ? 4 : 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedCategoryIndex == index ? Colors.brown : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        transform: transforms[index],
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 60, // Adjust the image size as needed
              height: 60,
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategoryItemTapped(int index) {
    switch (index) {
      case 0:
      // Handle tap on "한식" category
        print('한식 category tapped');
        break;
      case 1:
      // Handle tap on "양식" category
        print('양식 category tapped');
        break;
      case 2:
      // Handle tap on "일식" category
        print('일식 category tapped');
        break;
      case 3:
      // Handle tap on "중식" category
        print('중식 category tapped');
        break;
      case 4:
      // Handle tap on "분식" category
        print('분식 category tapped');
        break;
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Handle location permission denied
        return;
      }
    }
    // Location permission granted, show current location
    _showCurrentLocation();
  }

  void _onMapCreated(NaverMapController controller) {
    _mapController = controller;
    _requestLocationPermission();
  }

  void _showCurrentLocation() async {
    _locationOverlay = await _mapController.getLocationOverlay();
    _locationOverlay?.setIsVisible(true);

    // Continuously update the location overlay
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream().listen((Position position) {
      NLatLng location = NLatLng(position.latitude, position.longitude);
      _locationOverlay?.setPosition(location);
      //_mapController.moveCamera(CameraUpdate.scrollTo(location));
    });
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchPage();
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('찜 목록'));
  }
}

class RandomScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('랜덤 게임'));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyPage();
  }
}