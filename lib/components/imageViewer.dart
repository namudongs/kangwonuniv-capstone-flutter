import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final PageController _pageController = PageController();
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier(0);

  ImageViewer({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SizedBox(
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                onPageChanged: (index) => _pageIndexNotifier.value = index,
                itemBuilder: (context, index) {
                  return Image.network(
                    imageUrls[index],
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ValueListenableBuilder<int>(
                  valueListenable: _pageIndexNotifier,
                  builder: (context, index, _) {
                    return Text(
                      '${index + 1}/${imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
