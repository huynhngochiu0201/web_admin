import 'package:flutter/material.dart';
import 'package:web_admin/pages/widgets/service/add_widget/add_wheel_size.dart';
import '../../../../components/button/cr_elevated_button.dart';
import '../../../../entities/models/wheel_size_model.dart';
import '../../../../services/remote/wheel_size_service.dart';

class WheelSizeWidget extends StatefulWidget {
  const WheelSizeWidget({super.key});

  @override
  State<WheelSizeWidget> createState() => _WheelSizeWidgetState();
}

class _WheelSizeWidgetState extends State<WheelSizeWidget> {
  final WheelSizeService _wheelSizeService = WheelSizeService();
  List<WheelSizeModel> wheelSizes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWheelSizes();
  }

  Future<void> _loadWheelSizes() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedWheelSizes = await _wheelSizeService.fetchAllWheelSizesByCreateAt();
      if (!mounted) return;
      
      setState(() {
        wheelSizes = fetchedWheelSizes;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading wheel sizes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: CrElevatedButton(
                  text: 'Add Wheel Size',
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddWheelSize(),
                      ),
                    );
                    if (result == true) {
                      await _loadWheelSizes();
                    }
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 500.0,
                                child: Text(wheelSizes[index].name ?? ''),
                              ),
                              SizedBox(
                                width: 100.0,
                                child: Text('\$${wheelSizes[index].price}'),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  AddWheelSize(
                                                    wheelSize:
                                                        wheelSizes[index],
                                                  )));
                                      if (result == true) {
                                        _loadWheelSizes();
                                      }
                                    },
                                    child: Text('Edit'),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (await _showDeleteConfirmation(
                                          context)) {
                                        await _wheelSizeService
                                            .deleteWheelSizeById(
                                                wheelSizes[index].id);
                                        _loadWheelSizes();
                                      }
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16.0),
                    itemCount: wheelSizes.length),
          )
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text(
                  'Are you sure you want to delete this wheel size?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
