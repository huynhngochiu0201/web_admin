import 'package:flutter/material.dart';
import 'package:web_admin/components/table/custom_table.dart';
import '../../../entities/models/service_model.dart';
import '../../../services/remote/service.dart';

class ReplaceTirePage extends StatelessWidget {
  const ReplaceTirePage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Service();
    final List<String> statuses = ['Pending', 'Coming', 'Cancelled'];

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
      body: StreamBuilder<List<ServiceModel>>(
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
              .where((service) => service.nameservice == "replace_tire")
              .toList();

          if (services.isEmpty) {
            return const Center(
                child: Text('No replace tire services available.'));
          }

          return CustomTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Service Status')),
            ],
            rows: services.map((service) {
              return DataRow(cells: [
                DataCell(Text(
                  service.name,
                  overflow: TextOverflow.ellipsis,
                )),
                DataCell(Text(
                  service.address,
                  overflow: TextOverflow.ellipsis,
                )),
                DataCell(Text(
                  service.phone,
                  overflow: TextOverflow.ellipsis,
                )),
                DataCell(
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    value: statuses.contains(service.status)
                        ? service.status
                        : statuses[0],
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
                    items:
                        statuses.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }
}
