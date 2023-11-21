// cart_page.dart
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 장바구니 상품 목록을 관리하는 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장바구니', // 이모지와 함께 제목 설정
          style: TextStyle(
            fontSize: 20, // 폰트 크기
            fontWeight: FontWeight.bold, // 글씨 굵기
            color: Colors.black, // 글자 색상
          ),
        ),
      ),
      body: ListView(
        // 여기에 장바구니 상품 목록을 표시하는 코드
      ),
    );
  }
}