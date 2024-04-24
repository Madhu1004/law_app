import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/enums.dart';
import '../utils/constants/sizes.dart';


class TGridViewItems extends StatelessWidget {
  const TGridViewItems({
    super.key,
  });

  Future<List<Map<String, dynamic>>> fetchDataFromFirebase() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('Services').get();

      return snapshot.docs.map((doc) {
        return {
          'imageUrl': doc['imageUrl'],
          'title': doc['title'],
          'description': doc['description'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to load data from Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchDataFromFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if data fetch fails
        } else {
          // Data fetched successfully, build grid with fetched items
          return TGridLayout(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return TServicesCardVertical(
                imageUrl: item['imageUrl'] ?? '',
                title: item['title'] ?? '',
                description: item['description'] ?? '',
              );
            },
          );
        }
      },
    );
  }
}

class TGridLayout extends StatelessWidget {
  const TGridLayout({
    super.key,
    required this.itemCount,
    this.mainAxisExtent = 247,
    required this.itemBuilder,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: itemCount,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: mainAxisExtent,
          mainAxisSpacing: TSizes.gridViewSpacing,
          crossAxisSpacing: TSizes.gridViewSpacing,
        ),
        itemBuilder: itemBuilder);
  }
}

class TServicesCardVertical extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const TServicesCardVertical({
    super.key, // Adding Key? key parameter
    required this.imageUrl,
    required this.title,
    required this.description,
  }); // Passing the key to the super constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCardDetails(context); // Call function to show details on tap
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage( // Using CachedNetworkImage instead of Image.network
              imageUrl: imageUrl,
              width: double.infinity,
              height: 110,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder widget while loading
              errorWidget: (context, url, error) => const Icon(Icons.error), // Widget to display in case of error
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                color: TColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: TSizes.fontSizeSm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show card details in a dialog
  void _showCardDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
                // You can add more details here if needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}



class TServiceTitleText extends StatelessWidget {
  const TServiceTitleText({
    super.key,
    required this.title,
    this.smallSize = false,
    this.maxLines = 5,
    this.color,
    this.textAlign = TextAlign.left,
    this.brandTextSizes = TextSizes.small,
  });

  final String title;
  final bool smallSize;
  final Color? color;
  final int maxLines;
  final TextSizes brandTextSizes;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: brandTextSizes == TextSizes.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
          : brandTextSizes == TextSizes.medium
          ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
          : Theme.of(context).textTheme.bodyMedium!.apply(color: color),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

