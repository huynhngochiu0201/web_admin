import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin/components/button/cr_elevated_button.dart';
import 'package:web_admin/components/text_field/cr_text_field.dart';
import 'package:web_admin/constants/app_style.dart';
import '../../../components/app_bar/custom_app_bar.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../constants/app_color.dart';
import '../../../entities/models/category_model.dart';
import '../../../services/remote/category_service.dart';

class AddCategory extends StatefulWidget {
  final VoidCallback? onCategoryAdded;
  final CategoryModel? category;

  const AddCategory({
    super.key,
    this.onCategoryAdded,
    this.category,
  });

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _nameController = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  Uint8List? _selectedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
      });
    }
  }

  Future<void> _submitCategory() async {
    if (_isLoading) return;

    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Vui lòng nhập tên danh mục'),
      );
      return;
    }

    if (_selectedImage == null) {
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Vui lòng chọn ảnh'),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.category != null) {
        await _categoryService.updateCategory(
          id: widget.category!.id,
          name: name,
          imageBytes: _selectedImage!,
        );
      } else {
        await _categoryService.addNewCategory(
          name: name,
          imageBytes: _selectedImage!,
        );
      }

      if (!mounted) return; // Kiểm tra widget còn mounted không

      widget.onCategoryAdded?.call();

      Navigator.of(context).pop(true);

      showTopSnackBar(
        context,
        const TDSnackBar.success(message: 'Thêm danh mục thành công'),
      );
    } catch (e) {
      if (!mounted) return;

      showTopSnackBar(context, TDSnackBar.error(message: ' Lỗi: $e'));
    } finally {
      if (mounted) {
        // Kiểm tra mounted trước khi setState
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
              title:
                  widget.category != null ? 'Edit Category' : 'Add Category'),
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
                              _buildImage(),
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
        onPressed: _isLoading ? null : _submitCategory,
      ),
    );
  }

  Flexible _buildName() {
    return Flexible(
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Name Category', style: AppStyle.bold_12)),
          const SizedBox(height: 10.0),
          CrTextField(
            controller: _nameController,
            hintText: 'Name Category',
          ),
        ],
      ),
    );
  }

  Flexible _buildImage() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Image Category', style: AppStyle.bold_12)),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: AppColor.grey.withOpacity(0.3),
                ),
              ),
              height: 200.0,
              width: 200.0,
              child: Stack(
                children: [
                  _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.memory(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 200.0,
                            height: 200.0,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50.0,
                            color: AppColor.grey,
                          ),
                        ),
                  if (_selectedImage != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
