import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:law_app/reusable_widgets/reusable_widgets.dart';
import 'package:law_app/screens/applications/application_form.dart';
import 'package:law_app/utils/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String iconUrl; // Update to icon URL
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  Service({
    required this.iconUrl,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });
}

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  late List<Service> allServices;
  List<Service> displayedServices = [];

  @override
  void initState() {
    super.initState();
    fetchServicesFromFirestore();
  }

  void fetchServicesFromFirestore() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('ListOfServices').get();

      final List<Service> services = snapshot.docs.map((doc) {
        return Service(
          iconUrl: doc['iconUrl'], // Assuming 'iconUrl' field contains the URL of the icon
          title: doc['title'],
          subTitle: doc['description'], // Assuming 'description' field contains the subtitle
          onTap: () => _showDialog(context, doc['title'], doc['content']),
        );
      }).toList();

      setState(() {
        allServices = services;
        displayedServices = services;
      });
    } catch (e) {
      throw Exception('Failed to fetch services from Firestore: $e');
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _searchServices(String query) {
    setState(() {
      displayedServices = allServices.where((service) {
        final title = service.title.toLowerCase();
        final subTitle = service.subTitle.toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) || subTitle.contains(searchQuery);
      }).toList();
    });
  }

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
                  TAppBar(
                    title: Text(
                      'Application',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.apply(color: Colors.white),
                    ),
                    showBackArrow: false,
                  ),
                  const SizedBox(height: TSizes.spaceBetweenSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  TSearchContainer(
                    text: 'Search services...',
                    icon: Icons.search,
                    onSearch: _searchServices,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TSectionHeading(
                    title: 'Services',
                    showActionButton: false,
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),
                  Column(
                    children: displayedServices
                        .map((service) => _buildServiceTile(context, service))
                        .toList(),
                  ),
                  const SizedBox(height: TSizes.spaceBetweenSections),
                  const TSectionHeading(
                    title: 'Apply for service',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Get.to(() => const ApplicationForm()),
                      child: Text(
                        'Apply here',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context, Service service) {
    return ListTile(
      leading: SizedBox(
        width: 48, // Adjust the width according to your preference
        height: 48, // Adjust the height according to your preference
        child: CachedNetworkImage(
          imageUrl: service.iconUrl,
          placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder image
          errorWidget: (context, url, error) => const Icon(Icons.error), // Error image
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        service.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: GestureDetector(
        onTap: () => _showDialog(context, service.title, service.subTitle),
        child: const Text(
          "Click to know more",
          style: TextStyle(color: Colors.deepPurple),
        ),
      ),
      onTap: () => _showDialog(context, service.title, service.subTitle),
    );
  }
}
