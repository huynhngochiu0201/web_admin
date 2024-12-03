import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../components/button/cr_elevated_button.dart';
import '../../../../entities/models/area_model.dart';
import '../../../../services/remote/area_service.dart';
import '../add_widget/add_area.dart';

class AreaWidget extends StatefulWidget {
  const AreaWidget({super.key});

  @override
  State<AreaWidget> createState() => _AreaWidgetState();
}

class _AreaWidgetState extends State<AreaWidget> {
  final AreaService _areaService = AreaService();
  List<AreaModel> areas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  Future<void> _loadAreas() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final fetchedAreas = await _areaService.fetchAllAreasByCreateAt();
      if (!mounted) return;

      setState(() {
        areas = fetchedAreas;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading areas: $e')),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: CrElevatedButton(
                  text: 'Add Area',
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddArea(),
                      ),
                    );
                    if (result == true) {
                      await _loadAreas();
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
                            child: Text(areas[index].name ?? ''),
                          ),
                          SizedBox(
                            width: 100.0,
                            child: Text('\$${areas[index].price}'),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => AddArea(
                                                area: areas[index],
                                              )));
                                  if (result == true) {
                                    _loadAreas();
                                  }
                                },
                                child: Text('Edit'),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (await _showDeleteConfirmation(context)) {
                                    await _areaService
                                        .deleteAreaById(areas[index].id);
                                    _loadAreas();
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
                    itemCount: areas.length,
                  ),
          ),
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
              content: const Text('Are you sure you want to delete this area?'),
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
