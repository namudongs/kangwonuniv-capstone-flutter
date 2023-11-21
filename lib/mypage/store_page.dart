import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late int userMileage; // 사용자 마일리지

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
        SnackBar(content: Text('기프티콘 교환 성공!')),
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
        title: Text('마일리지 상점'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '보유 마일리지: $userMileage 점',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('편의점 기프티콘 - 1000점'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(1000),
                    child: Text('교환'),
                  ),
                ),
                ListTile(
                  title: Text('카페 기프티콘 - 1500점'),
                  trailing: ElevatedButton(
                    onPressed: () => _exchangeMileageForGift(1500),
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