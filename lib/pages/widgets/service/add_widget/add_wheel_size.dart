import 'package:flutter/material.dart';
import 'package:web_admin/components/button/cr_elevated_button.dart';
import 'package:web_admin/components/text_field/cr_text_field.dart';
import 'package:web_admin/constants/app_style.dart';
import '../../../../components/app_bar/custom_app_bar.dart';
import '../../../../components/snack_bar/td_snack_bar.dart';
import '../../../../components/snack_bar/top_snack_bar.dart';
import '../../../../constants/app_color.dart';
import '../../../../entities/models/wheel_size_model.dart';
import '../../../../services/remote/wheel_size_service.dart';

class AddWheelSize extends StatefulWidget {
  final VoidCallback? onWheelSizeAdded;
  final WheelSizeModel? wheelSize;

  const AddWheelSize({
    super.key,
    this.onWheelSizeAdded,
    this.wheelSize,
  });

  @override
  State<AddWheelSize> createState() => _AddWheelSizeState();
}

class _AddWheelSizeState extends State<AddWheelSize> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool _isLoading = false;

  final WheelSizeService _wheelSizeService = WheelSizeService();

  @override
  void initState() {
    super.initState();
    if (widget.wheelSize != null) {
      nameController.text = widget.wheelSize!.name ?? '';
      priceController.text = widget.wheelSize!.price.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();

    super.dispose();
  }

  Future<void> _submitForm() async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();

    if (name.isEmpty) {
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Please enter wheel size'),
      );
      return;
    }

    if (priceText.isEmpty) {
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Please enter price'),
      );
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null) {
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Please enter valid price'),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.wheelSize != null) {
        await _wheelSizeService.updateWheelSizeById(
          widget.wheelSize!.id,
          name,
          price,
        );
        showTopSnackBar(
          context,
          const TDSnackBar.success(message: 'Wheel size updated successfully'),
        );
      } else {
        await _wheelSizeService.addWheelSize(name: name, price: price);
        showTopSnackBar(
          context,
          const TDSnackBar.success(message: 'Wheel size added successfully'),
        );
      }

      if (widget.onWheelSizeAdded != null) {
        widget.onWheelSizeAdded!();
      }
      Navigator.of(context).pop();
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
              title: widget.wheelSize != null
                  ? 'Edit Wheel Size'
                  : 'Add Wheel Size'),
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
              child: Text('Wheel Size', style: AppStyle.bold_12)),
          const SizedBox(height: 10.0),
          CrTextField(
            controller: nameController,
            hintText: 'Wheel Size',
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
