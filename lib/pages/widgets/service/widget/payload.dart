import 'package:flutter/material.dart';
import 'package:web_admin/pages/widgets/service/add_widget/add_payload.dart';

import '../../../../components/button/cr_elevated_button.dart';
import '../../../../entities/models/payload_model.dart';
import '../../../../services/remote/payload_service.dart';

class PayloadWidget extends StatefulWidget {
  const PayloadWidget({super.key});

  @override
  State<PayloadWidget> createState() => _PayloadWidgetState();
}

class _PayloadWidgetState extends State<PayloadWidget> {
  final PayloadService _payloadService = PayloadService();
  List<PayloadModel> payloads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPayloads();
  }

  Future<void> _loadPayloads() async {
    try {
      final fetchedPayloads =
          await _payloadService.fetchAllPayloadsByCreateAt();
      setState(() {
        payloads = fetchedPayloads;
        isLoading = false;
      });
    } catch (e) {
      // Có thể thêm xử lý hiển thị lỗi ở đây
      setState(() {
        isLoading = false;
      });
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
                        MaterialPageRoute(builder: (context) => AddPayload()));
                    if (result == true) {
                      _loadPayloads();
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
                                child: Text(payloads[index].name ?? ''),
                              ),
                              SizedBox(
                                width: 100.0,
                                child: Text('\$${payloads[index].price}'),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => AddPayload(
                                                    payload: payloads[index],
                                                  )));
                                      if (result == true) {
                                        _loadPayloads();
                                      }
                                    },
                                    child: Text('Edit'),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (await _showDeleteConfirmation(
                                          context)) {
                                        await _payloadService.deletePayloadById(
                                            payloads[index].id);
                                        _loadPayloads();
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
                    itemCount: payloads.length),
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
              content:
                  const Text('Are you sure you want to delete this payload?'),
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
