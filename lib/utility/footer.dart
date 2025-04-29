// 📌 Footer 섹션
import 'utility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildFooter() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildLinkedWidget(Icon(FontAwesomeIcons.twitter, size: 25, color: Colors.black), "https://twitter.com"),
          SizedBox(width: 50),
          buildLinkedWidget(Icon(FontAwesomeIcons.squareInstagram, size: 25, color: Colors.black), "https://www.instagram.com"),
          SizedBox(width: 50),
          buildLinkedWidget(Icon(FontAwesomeIcons.youtube, size: 25, color: Colors.black), "https://www.youtube.com/@%EB%B0%95%EC%9D%B8%ED%9D%AC-i6x"),
        ],
      ),
      const SizedBox(height: 20),
      buildDivider(),
      const SizedBox(height: 10),
      const Text(
        "dlsgml5131@gmail.com",
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
      const Text(
        "+82 01066697471",
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
      const Text(
        "08:00 - 22:00 - Everyday",
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
      const SizedBox(height: 10),
      buildDivider(),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("About", style: TextStyle(fontSize: 14, color: Colors.black)),
          SizedBox(width: 20),
          Text("Contact", style: TextStyle(fontSize: 14, color: Colors.black)),
          SizedBox(width: 20),
          Text("Blog", style: TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
      const SizedBox(height: 20),
      const Text(
        "Copyright© OpenUI All Rights Reserved.",
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
      const SizedBox(height: 30),
    ],
  );
}

// 📌 Follow Us 섹션
Widget buildFollowUsSection() {
  return Column(
    children: [
      const Text(
        "FOLLOW US",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4),
      ),
      const SizedBox(height: 10),
      const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.grey),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
          children: [
            buildLinkedWidget(buildInstagramImage("assets/images/testbanner.jpg", "@dlsgml"), "https://github.com/CHOULOKY"),
            buildLinkedWidget(buildInstagramImage("assets/images/testbanner.jpg", "@sample"), ""),
            buildLinkedWidget(buildInstagramImage("assets/images/testbanner.jpg", "@sample"), ""),
            buildLinkedWidget(buildInstagramImage("assets/images/testbanner.jpg", "@sample"), ""),
          ],
        ),
      ),
      const SizedBox(height: 60),
    ],
  );
}

Widget buildInstagramImage(String imagePath, String username) {
  return Stack(
    children: [
      SizedBox(
        child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity,),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: (0.4 * 255)), // 아래쪽 진한 검은색
                    Colors.transparent, // 위쪽 투명
                  ]
              )
          ),
        ),
      ),
      Positioned(
        bottom: 10,
        left: 10,
        right: 0,
        child: Text(username, style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 255, 255, 0.8)),),
      ),
    ],
  );
  /*
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
          ),
        ),
        const SizedBox(height: 5),
        Text(username, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
     */
}
