import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:foodmap/mypage/my_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;


  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    //ProfileScreen(),
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


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryImage(0, 'assets/images/korea.png', 'kor'),
            _buildCategoryImage(1, 'assets/images/western.png', 'wes'),
            _buildCategoryImage(2, 'assets/images/japen.png', 'ja'),
            _buildCategoryImage(3, 'assets/images/china.png', 'ch'),
            _buildCategoryImage(4, 'assets/images/snack.png', 'sn'),
          ],
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

  Widget _buildCategoryImage(int index, String imagePath, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          transforms[index] = Matrix4.identity()..scale(0.9);
        });
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            transforms[index] = Matrix4.identity();
          });
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            transform: transforms[index],
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
