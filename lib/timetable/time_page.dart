import 'package:flutter/material.dart';
import 'package:capstone/components/color.dart';
import 'package:flutter/cupertino.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  List friends = ["고양이1", "고양이2", "고양이3", "고양이4", "고양이5"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(),
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10),
                  const Text(
                    '2021년 2학기',
                    style: TextStyle(color: Palette.everyRed, fontSize: 13),
                  ),
                  const Text(
                    '시간표 🍒',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TimePage()));
                },
                icon: const Icon(
                  CupertinoIcons.plus_square,
                ),
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TimePage()));
                },
                icon: const Icon(
                  CupertinoIcons.gear,
                ),
                color: Colors.black,
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TimePage()));
                    },
                    icon: const Icon(
                      CupertinoIcons.list_bullet,
                    ),
                    color: Colors.black,
                  ))
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 400,
                          margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              myTable("월", const Color(0xffe28b7b),
                                  startnum: 27, endnum: 50, subject: "운영체제"),
                              myTable("화", const Color(0xff90cec1),
                                  startnum: 42, endnum: 59, subject: "알고리즘"),
                              myTable("수", const Color(0xff90cec1),
                                  startnum: 13, endnum: 20, subject: "알고리즘"),
                              myTable("목", Colors.grey.shade300),
                              myTable("금", const Color(0xffffc476),
                                  startnum: 9, endnum: 29, subject: "자료구조"),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            height: 60 + 60.0 * friends.length,
                            width: 400,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('친구 시간표',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TimePage()));
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.plus_square,
                                            ),
                                            color: Colors.black,
                                          ),
                                        )
                                      ]),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  friendName(friends[0]),
                                  friendName(friends[1]),
                                  friendName(friends[2]),
                                  friendName(friends[3]),
                                  friendName(friends[4]),
                                ])),
                        Container(
                            margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            height: 150,
                            width: 400,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('학점계산기',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TimePage()));
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.pencil),
                                            color: Colors.black,
                                          ),
                                        )
                                      ]),
                                  TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "평균 학점  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              "4.5",
                                              style: TextStyle(
                                                  color: Palette.everyRed,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              " / 4.5",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0),
                                            ),
                                            Text(
                                              "  취득 학점  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              "130",
                                              style: TextStyle(
                                                  color: Palette.everyRed,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              " / 130",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0),
                                            ),
                                          ])),
                                ])),
                      ]),
                ))));
  }
}

Widget friendName(String name) {
  return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.black, fontSize: 17.0),
            ),
          ]));
}

Widget myTable(String week, Color col,
    {int startnum = 0, int endnum = 0, String subject = ""}) {
  return Expanded(
    child: Table(
      border: TableBorder(
          right: BorderSide(
              color: week == "금" ? Colors.transparent : Colors.grey.shade300)),
      children: [
        TableRow(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            children: [
              SizedBox(
                  height: 30.0,
                  child: Center(
                      child: Text(
                    week,
                  ))),
            ]),
        for (int i = 0; i < 60; i++)
          TableRow(children: [
            Container(
              decoration: BoxDecoration(
                color: i >= startnum && i < endnum ? col : Colors.transparent,
                border: Border(
                  top: BorderSide(
                      width: 0.50,
                      color: i % 6 == 0 && !(i >= startnum && i < endnum)
                          ? Colors.grey.shade300
                          : Colors.transparent),
                  bottom: const BorderSide(width: 0, color: Colors.transparent),
                ),
              ),
              height: 10.0,
            ),
          ]),
      ],
    ),
  );
}
