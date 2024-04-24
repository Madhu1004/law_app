import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:law_app/screens/applications/applications.dart';
import 'package:law_app/utils/constants/colors.dart';
import 'package:law_app/utils/constants/sizes.dart';
import '../../reusable_widgets/girds.dart';
import '../../reusable_widgets/reusable_widgets.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  const THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left:TSizes.defaultSpace, right: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        const TSectionHeading(
                          title: 'Our Popular Services',
                          showActionButton: false,
                          textColor: TColors.white,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        // Pass snapshot to THomeServices
                        FutureBuilder<List<PopularService>>(
                          future: FirebaseService().fetchPopularServices(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return THomeServices(popularServices: snapshot.data ?? []);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBetweenSections),
                  const Padding(padding: EdgeInsets.only(left:TSizes.defaultSpace,right: TSizes.defaultSpace,bottom: TSizes.defaultSpace),
                  child: TBannerSlider()),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:TSizes.defaultSpace, right:TSizes.defaultSpace, bottom:TSizes.defaultSpace),
              child: Column(
                children: [
                  TSectionHeading(
                    title: 'Our Services',
                    onPressed: () => Get.to(() => const ApplicationScreen()),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TGridViewItems(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TBannerSlider extends StatelessWidget {
  const TBannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchImagesFromFolder('Banners'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching images
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Show an error message if fetching images fails
          return Text('Error: ${snapshot.error}');
        } else {
          final List<String> banners = snapshot.data ?? [];
          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                ),
                items: banners.map((url) => _buildBannerImage(url)).toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              // Display page indicator
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  banners.length,
                      (index) => const TCircularContainer(
                    margin: EdgeInsets.only(right: 10),
                    width: 20,
                    height: 3,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildBannerImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}


Future<List<String>> fetchImagesFromFolder(String folderPath) async {
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ListResult result = await storage.ref(folderPath).listAll();
    // Extract download URLs of images from Firebase Storage
    return await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching images: $e');
    }
    return []; // Return an empty list if fetching images fails
  }
}

class PopularService {
  final String imageUrl;
  final String title;

  PopularService({
    required this.imageUrl,
    required this.title,
  });
}

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PopularService>> fetchPopularServices() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('PopularServices').get();

      return snapshot.docs.map((doc) {
        return PopularService(
          imageUrl: doc['imageUrl'],
          title: doc['title'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular services: $e');
    }
  }
}

class THomeServices extends StatelessWidget {
  final List<PopularService> popularServices;

  const THomeServices({
    super.key,
    required this.popularServices,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: popularServices.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final service = popularServices[index];
          return THorizontalServices(
            imageUrl: service.imageUrl,
            title: service.title,
          );
        },
      ),
    );
  }
}

class THorizontalServices extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  const THorizontalServices({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TVerticalImageText(imageUrl: imageUrl, title: title, onTap: onTap);
  }
}

class TVerticalImageText extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  const TVerticalImageText({
    super.key,
    required this.imageUrl,
    required this.title,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: backgroundColor ?? (dark ? Colors.black : Colors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            SizedBox(
              width: 55,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: textColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}