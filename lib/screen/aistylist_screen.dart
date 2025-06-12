import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utility/appbar.dart';
import '../utility/navigationbar.dart';
import '../service/authservice.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AIStylistScreen extends StatefulWidget {
  const AIStylistScreen({super.key});

  @override
  State<AIStylistScreen> createState() => _AIStylistScreenState();
}

class _AIStylistScreenState extends State<AIStylistScreen> {
  final _situationCtrl = TextEditingController();
  final _weatherCtrl = TextEditingController();
  final _temperatureCtrl = TextEditingController();
  final _styleCtrl = TextEditingController();

  final AuthService _authService = AuthService();

  bool _loading = false;
  Map<String, dynamic>? _result;

  String? _virtualTryOnImageUrl;
  bool _tryOnLoading = false;

  @override
  void dispose() {
    _situationCtrl.dispose();
    _weatherCtrl.dispose();
    _temperatureCtrl.dispose();
    _styleCtrl.dispose();
    super.dispose();
  }

  Future<void> _recommend() async {
    setState(() {
      _loading = true;
      _result = null;
      _virtualTryOnImageUrl = null;
    });

    final body = {
      "situation": _situationCtrl.text,
      "weather": _weatherCtrl.text,
      "temperature": _temperatureCtrl.text,
      "style": _styleCtrl.text,
    };

    try {
      final headers = await _authService.getJsonHeaders();
      if (headers == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
        return;
      }

      print('Sending headers: $headers');
      
      final res = await http.post(
        Uri.parse('http://localhost:8080/recommends'),
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(body),
      );
      
      if (res.statusCode == 200) {
        setState(() {
          _result = jsonDecode(res.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('추천 실패: ${res.statusCode} - ${res.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveRecommendation() async {
    if (_result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추천 결과가 없습니다. 먼저 추천을 받아주세요.')),
      );
      return;
    }

    final headers = await _authService.getJsonHeaders();
    if (headers == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final gptRecommendationJsonString = jsonEncode(_result);

    final requestBody = jsonEncode({
      "recommendationJson": gptRecommendationJsonString,
    });

    try {
      final res = await http.post(
        Uri.parse('http://localhost:8080/calendar/recommendations'),
        headers: headers,
        body: requestBody,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추천 결과가 캘린더에 성공적으로 저장되었습니다!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: ${res.statusCode} - ${res.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Future<void> _performVirtualTryOn() async {
    if (_result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추천 결과를 먼저 받아주세요.')),
      );
      return;
    }

    final topId = _result!['top']?['id'];
    final bottomId = _result!['bottom']?['id'];

    if (topId == null || bottomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상의 또는 하의 추천 정보가 없어 가상 피팅을 진행할 수 없습니다.')),
      );
      return;
    }

    setState(() {
      _tryOnLoading = true;
      _virtualTryOnImageUrl = null;
    });

    try {
      final headers = await _authService.getJsonHeaders();
      if (headers == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
        return;
      }

      final Uri uri = Uri.parse('http://localhost:8080/fashion/virtual-tryon')
          .replace(queryParameters: {
            'upperClothesId': topId.toString(),
            'lowerClothesId': bottomId.toString(),
          });

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode({}),
      );

      if (res.statusCode == 200) {
        final base64Image = base64Encode(res.bodyBytes);
        setState(() {
          _virtualTryOnImageUrl = 'data:image/png;base64,$base64Image';
        });
        print('Generated Virtual Try-On Image Data URL: $_virtualTryOnImageUrl');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('가상 피팅 실패: ${res.statusCode} - ${res.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('가상 피팅 중 오류 발생: $e')),
      );
    } finally {
      setState(() {
        _tryOnLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _result == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🤖AI 스타일 추천",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _situationCtrl,
                      decoration: const InputDecoration(labelText: "상황"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _weatherCtrl,
                      decoration: const InputDecoration(labelText: "날씨"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _temperatureCtrl,
                      decoration: const InputDecoration(labelText: "기온"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _styleCtrl,
                      decoration: const InputDecoration(labelText: "요구사항"),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: _loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _recommend,
                              child: const Text("추천 받기"),
                            ),
                    ),
                  ],
                )
              : _buildResultView(),
        ),
      ),
      bottomNavigationBar: buildNavigationBar(context, 1),
    );
  }

  Widget _buildResultView() {
    final reason = _result?['reason'] ?? '';
    final top = _result?['top'];
    final bottom = _result?['bottom'];
    final outer = _result?['outer'];
    final shoes = _result?['shoes'];

    Widget buildClothCard(Map? item, String label) {
      if (item == null) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3FB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (item['imageUrl'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item['imageUrl'],
                  width: 240,
                  height: 240,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox(
                    width: 240, height: 240,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => const SizedBox(
                    width: 240, height: 240,
                    child: Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🤖AI 추천 결과",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(reason, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          buildClothCard(top, "상의"),
          buildClothCard(bottom, "하의"),
          buildClothCard(outer, "아우터"),
          buildClothCard(shoes, "신발"),
          const SizedBox(height: 32),
          Center(
            child: _tryOnLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _performVirtualTryOn,
                    child: const Text("가상 피팅"),
                  ),
          ),
          const SizedBox(height: 24),
          if (_virtualTryOnImageUrl != null)
            Center(
              child: Column(
                children: [
                  const Text(
                    '가상 피팅 결과',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CachedNetworkImage(
                    imageUrl: _virtualTryOnImageUrl!,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8 * 1.5,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const CircularProgressIndicator(),
                    errorWidget: (_, __, ___) => const Icon(Icons.error, size: 80),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() {
                  _result = null;
                  _virtualTryOnImageUrl = null;
                }),
                child: const Text("다시 추천받기"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _saveRecommendation,
                child: const Text("저장하기"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}