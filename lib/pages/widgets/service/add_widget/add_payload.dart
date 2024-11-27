import 'package:flutter/material.dart';
import 'package:web_admin/components/button/cr_elevated_button.dart';
import 'package:web_admin/components/text_field/cr_text_field.dart';
import 'package:web_admin/constants/app_style.dart';
import '../../../../components/app_bar/custom_app_bar.dart';
import '../../../../components/snack_bar/td_snack_bar.dart';
import '../../../../components/snack_bar/top_snack_bar.dart';
import '../../../../constants/app_color.dart';
import '../../../../entities/models/payload_model.dart';
import '../../../../services/remote/payload_service.dart';

class AddPayload extends StatefulWidget {
  final VoidCallback? onPayloadAdded;
  final PayloadModel? payload;

  const AddPayload({
    super.key,
    this.onPayloadAdded,
    this.payload,
  });

  @override
  State<AddPayload> createState() => _AddPayloadState();
}

class _AddPayloadState extends State<AddPayload> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool _isLoading = false;

  final PayloadService _payloadService = PayloadService();

  @override
  void initState() {
    super.initState();
    if (widget.payload != null) {
      nameController.text = widget.payload!.name ?? '';
      priceController.text = widget.payload!.price.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Please enter all required information'),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String payloadName = nameController.text;
      double price = double.parse(priceController.text);

      if (widget.payload != null) {
        await _payloadService.updatePayloadById(
          widget.payload!.id,
          payloadName,
          price,
        );
        showTopSnackBar(context,
            const TDSnackBar.success(message: 'Payload updated successfully'));
      } else {
        await _payloadService.addPayload(
          name: payloadName,
          price: price,
        );
        showTopSnackBar(context,
            const TDSnackBar.success(message: 'Payload added successfully'));
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      showTopSnackBar(context, TDSnackBar.error(message: 'Error: $e'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
              title: widget.payload != null ? 'Edit Payload' : 'Add Payload'),
          backgroundColor: AppColor.Ef5f5f5,
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ).copyWith(top: 10.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildName(),
                              const SizedBox(width: 40.0),
                            ],
                          ),
                          const Spacer(),
                          _buildElevatedButton()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Align _buildElevatedButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CrElevatedButton(
        width: 100.0,
        text: _isLoading ? 'Loading...' : 'Submit',
        onPressed: _isLoading ? null : _submitForm,
      ),
    );
  }

  Flexible _buildName() {
    return Flexible(
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Payload', style: AppStyle.bold_12)),
          const SizedBox(height: 10.0),
          CrTextField(
            controller: nameController,
            hintText: 'Payload',
          ),
          const SizedBox(height: 10.0),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Price', style: AppStyle.bold_12)),
          const SizedBox(height: 10.0),
          CrTextField(
            controller: priceController,
            hintText: 'Price',
          ),
        ],
      ),
    );
  }
}
