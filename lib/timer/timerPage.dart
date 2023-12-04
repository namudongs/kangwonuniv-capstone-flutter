import 'dart:async';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _seconds = 0;
  String _timerTitle = '';
  final TextEditingController _titleController = TextEditingController();
  final List<Map<String, dynamic>> _studyRecords = [];

  void _startTimer() {
    if (_timerTitle.isEmpty) {
      _showAlert('제목을 입력해주세요');
      return;
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (_seconds > 0) {
      _studyRecords.add({'title': _timerTitle, 'time': _seconds});
    }

    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _timerTitle = '';
      _titleController.clear();
    });
  }

  void _deleteRecord(int index) {
    setState(() {
      _studyRecords.removeAt(index);
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공부 타이머')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '타이머 제목',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _timerTitle = value;
              },
            ),
            const SizedBox(height: 20),
            Text(
              '시간: ${_formatTime(_seconds)}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('시작'),
                ),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: const Text('정지'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _studyRecords.length,
                itemBuilder: (context, index) {
                  final record = _studyRecords[index];
                  return Dismissible(
                    key: Key(record.toString()),
                    onDismissed: (direction) {
                      _deleteRecord(index);
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(record['title']),
                      subtitle: Text('공부 시간: ${_formatTime(record['time'])}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final int min = seconds ~/ 60;
    final int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
