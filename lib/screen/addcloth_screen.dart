import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb; // 웹 여부 체크
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../service/clothservice.dart';
import '../utility/appbar.dart';
import '../utility/navigationbar.dart';

class AddClothScreen extends StatefulWidget {
  const AddClothScreen({super.key});

  @override
  State<AddClothScreen> createState() => _AddClothScreenState();
}

class _AddClothScreenState extends State<AddClothScreen> {
  File? _selectedImage;         // 모바일 전용
  Uint8List? _webImageData;     // 웹 전용 (이미지 바이트)

  final ImagePicker _picker = ImagePicker();

  // Dropdown 선택값들 초기화
  String? _selectedCategory;
  String? _selectedColor;
  //String? _selectedSeason;
  List<String> _selectedSeasons = [];
  String? _selectedStyle;

  bool _isLoading = false;

  final ClothService _clothService = ClothService();

  // 각 Dropdown 항목 예시
  final List<String> categories = ['TOP', 'BOTTOM', 'OUTER', 'SHOES'];
  final List<String> colors = [
    'BLACK', 'WHITE', 'BLUE', 'RED', 'GREEN', 'IVORY', 'BEIGE',
    'LIGHT_GRAY', 'GRAY', 'DARK_GRAY', 'BROWN', 'ORANGE', 'YELLOW',
    'PINK', 'PURPLE', 'GOLD', 'SILVER', 'MULTI', 'LIGHT_YELLOW',
    'CORAL', 'DARK_PINK', 'MINT', 'OLIVE', 'DARK_OLIVE', 'TEAL',
    'KHAKI', 'CYAN', 'SKY_BLUE', 'NAVY', 'LAVENDER', 'BURGUNDY',
    'CAMEL', 'DARK_BROWN', 'MAGENTA'
  ];
  final List<String> seasons = ['SPRING', 'SUMMER', 'FALL', 'WINTER', 'ALL'];
  final List<String> styles = [
    'CASUAL', 'FORMAL', 'COZY', 'BUSINESS_CASUAL', 'MODERN', 'CLASSIC',
    'MINIMAL', 'BOHEMIAN', 'LUXURY', 'SPORTY', 'ATHLEISURE', 'AFFORDABLE',
    'TRENDY', 'MID_RANGE', 'KID_CORE', 'BASIC', 'ARTISTIC', 'DRESS_UP',
    'HIPSTER', 'FEMININE', 'CHIC', 'STREET', 'KITSCH', 'PUNKY', 'OTHER'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      if (kIsWeb) {
        // 웹일 때는 XFile의 bytes를 Uint8List로 읽어서 저장
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageData = bytes;
          _selectedImage = null; // 모바일 파일은 null 처리
        });
      } else {
        // 모바일일 때는 File 객체로 저장
        setState(() {
          _selectedImage = File(pickedFile.path);
          _webImageData = null;
        });
      }
    }
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: const Text('선택하세요'),
          items: items
              .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _submit() async {
    if (_selectedCategory == null ||
        _selectedColor == null ||
        //_selectedSeason == null ||
        _selectedSeasons.isEmpty ||
        _selectedStyle == null ||
        (_selectedImage == null && _webImageData == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목을 선택하고 이미지를 첨부해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _clothService.addClothItem(
        imageFile: _selectedImage,
        webImageData: _webImageData,
        category: _selectedCategory!,
        color: _selectedColor!,
        //season: _selectedSeason!,
        seasons: _selectedSeasons,
        style: _selectedStyle!,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('옷이 성공적으로 등록되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('옷 등록에 실패했습니다.');
      }
    } catch (e) {
      debugPrint('에러 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('옷 등록 중 오류가 발생했습니다.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMultiSelectSeasons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('계절', style: TextStyle(fontWeight: FontWeight.bold)),
        ...seasons.map((season) {
          return CheckboxListTile(
            title: Text(season),
            value: _selectedSeasons.contains(season),
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _selectedSeasons.add(season);
                } else {
                  _selectedSeasons.remove(season);
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = const Center(child: Text('이미지를 선택하려면 눌러주세요'));

    if (kIsWeb && _webImageData != null) {
      imageWidget = Image.memory(_webImageData!, fit: BoxFit.cover);
    } else if (!kIsWeb && _selectedImage != null) {
      imageWidget = Image.file(_selectedImage!, fit: BoxFit.cover);
    }

    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      bottomNavigationBar: buildNavigationBar(context, 3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: imageWidget,
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdown('카테고리', _selectedCategory, categories, (val) {
                setState(() {
                  _selectedCategory = val;
                });
              }),
              const SizedBox(height: 12),
              _buildDropdown('색상', _selectedColor, colors, (val) {
                setState(() {
                  _selectedColor = val;
                });
              }),
              const SizedBox(height: 12),
              _buildDropdown('스타일', _selectedStyle, styles, (val) {
                setState(() {
                  _selectedStyle = val;
                });
              }),
              const SizedBox(height: 12),
              /*
              _buildDropdown('계절', _selectedSeason, seasons, (val) {
                setState(() {
                  _selectedSeason = val;
                });
              }),
               */
              _buildMultiSelectSeasons(),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submit,
                child: const Text('옷 등록하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
