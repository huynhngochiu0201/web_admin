import 'package:flutter/material.dart';
import '../../../entities/models/service_model.dart';
import '../../../services/remote/service.dart';

class ReplaceTirePage extends StatelessWidget {
  const ReplaceTirePage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Service();
    final List<String> statuses = ['Pending', 'Delivered', 'Cancelled'];

    // Hàm cập nhật trạng thái
    Future<void> updateStatus(
        ServiceModel serviceModel, String newStatus) async {
      try {
        await service.updateService(serviceModel.userId!, newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated status to $newStatus')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: StreamBuilder<List<ServiceModel>>(
          stream: service.streamAllServices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No services available.'));
            }

            final services = snapshot.data!
                .where((service) => service.service == "replace_tire")
                .toList();

            if (services.isEmpty) {
              return const Center(
                  child: Text('No replace tire services available.'));
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Container(
                  height: 50.0,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 1.0, color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            service.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Address
                        SizedBox(
                          width: 200,
                          child: Text(
                            service.address,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        // Phone
                        SizedBox(
                          width: 100,
                          child: Text(
                            service.phone,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Dropdown for status
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          value: service.status ?? statuses[0],
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (String? newStatus) {
                            if (newStatus != null) {
                              updateStatus(service, newStatus);
                            }
                          },
                          items: statuses
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
