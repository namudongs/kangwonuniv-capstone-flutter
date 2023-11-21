import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_page.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late int userMileage;

  @override
  void initState() {
    super.initState();
    _getUserMileage();
  }

  void _getUserMileage() async {
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    setState(() {
      userMileage = userData['mileage'];
    });
  }

  void _exchangeMileageForGift(int giftCost) {
    if (userMileage >= giftCost) {
      // 마일리지를 차감하고 기프티콘을 교환
      FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'mileage': userMileage - giftCost});

      // 기프티콘 교환 로직 구현 (예: 사용자에게 기프티콘 코드 제공)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('기프티콘을 교환했습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('마일리지가 부족합니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '마일리지',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 98, 0), // 강원대학교 텍스트 색상
                  fontSize: 13, // 텍스트 크기
                ),
              ),
              Text(
                '🏬상점', // 이모지와 함께 제목 설정
                style: TextStyle(
                  fontSize: 20, // 폰트 크기
                  fontWeight: FontWeight.bold, // 글씨 굵기
                  color: Colors.black, // 글자 색상
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        // 글자 색상을 사용자 설정에 따라 동적으로 변경
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '보유 마일리지: $userMileage',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('CU 3000원권 - 마일리지 4000'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(6000),
                    child: Text('교환'),
                  ),
                ),
                ListTile(
                  title: Text('CU 5000원권 - 마일리지 6000'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(6000),
                    child: Text('교환'),
                  ),
                ),
                ListTile(
                  title: Text('CU 10000원권 - 마일리지 11000'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(6000),
                    child: Text('교환'),
                  ),
                ),
                ListTile(
                  title: Text('GS25 3000원권 - 마일리지 4000'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(6000),
                    child: Text('교환'),
                  ),
                ),
                ListTile(
                  title: Text('GS25 5000원권 - 마일리지 6000'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(6000),
                    child: Text('교환'),
                  ),
                ),
                ListTile(
                  title: Text('GS25 10000원권 - 마일리지 11000'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(6000),
                    child: Text('교환'),
                  ),
                ),
                ListTile(
                  title: Text('스타벅스 아메리카노 - 마일리지 5500'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(4500),
                    child: Text('교환'),
                  ),
                ),
                // 추가 기프티콘 목록 구현
              ],
            ),
          ),
        ],
      ),
    );
  }
}