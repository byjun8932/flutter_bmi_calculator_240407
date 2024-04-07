import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../result/result_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formkey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {

    super.initState();

    load();
  }

  @override
  void dispose() {

    _heightController.dispose();
    _weightController.dispose();
  }

  Future save() async {
    // 비동기와 동기에 대해서 알아보고 넘어가라...
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('height', double.parse(_heightController.text));
    await prefs.setDouble('w eight', double.parse(_weightController.text));
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    final double? height = prefs.getDouble('height');
    final double? weight = prefs.getDouble('weight');

    if(height != null && weight != null) {
      _heightController.text = '$height';
      _weightController.text = '$weight';
      print('키: $height, 몸무게 $weight');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('비만도 계산기'),
          // Text 같은 곳에서 변수가 들어가면 Const 를 안쓴다, 반대의 경우는 쓴다.
          backgroundColor: Colors.transparent,
          // 투명한 색상으로 설정
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.withOpacity(0.4),
                  Colors.limeAccent.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: '키'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '키를 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: '몸무게'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '몸무게를 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState?.validate() == false ?? false) {
                        return;
                      }

                      final height = _heightController.text;

                      save();

                      Navigator.push(
                        // Live template 만들기
                        context,
                        MaterialPageRoute(
                            builder: (container) => ResultScreen(
                                  height: double.parse(_heightController.text),
                                  weight: double.parse(_weightController.text),
                                )),
                      );
                    },
                    child: const Text('결과')),
              ],
            ),
          ),
        ));
  }
}
