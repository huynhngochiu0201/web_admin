import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin/components/button/cr_elevated_button.dart';
import 'package:web_admin/components/text_field/cr_text_field.dart';
import 'package:web_admin/constants/app_style.dart';
import '../../../components/app_bar/custom_app_bar.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../constants/app_color.dart';
import '../../../constants/define_collection.dart';
import '../../../entities/models/add_product_model.dart';
import '../../../entities/models/category_model.dart';
import '../../../entities/models/product_model.dart';
import '../../../services/remote/product_service.dart';

class AddProduct extends StatefulWidget {
  final VoidCallback? onProductAdded;
  final ProductModel? product;

  const AddProduct({
    super.key,
    this.onProductAdded,
    this.product,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Uint8List? _selectedImage;
  CategoryModel? _selectedCategory;
  bool _isLoading = false;
  bool _isCategoryLoading = true;

  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories().then((_) {
      if (widget.product != null) {
        _nameController.text = widget.product!.name;
        _priceController.text = widget.product!.price.toString();
        _quantityController.text = widget.product!.quantity.toString();
        _descriptionController.text = widget.product!.description ?? '';
        _selectedCategory = _categories.firstWhere(
            (category) => category.id == widget.product!.categoryId);
        setState(() {});
      }
    });
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(AppDefineCollection.APP_CATEGORY)
          .get();

      setState(() {
        _categories = snapshot.docs
            .map((doc) => CategoryModel.fromJson(doc.data()))
            .toList();
        _isCategoryLoading = false;
      });
    } catch (e) {
      setState(() {
        _isCategoryLoading = false;
      });
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Failed to load categories: $e'));
    }
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (image != null) {
      final imageBytes = await image.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      showTopSnackBar(
          context, const TDSnackBar.error(message: 'Please select a category'));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.product != null) {
        final addProductModel = AddProductModel(
          id: widget.product!.id,
          cateId: _selectedCategory!.id,
          productName: _nameController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          quantity: int.parse(_quantityController.text.trim()),
          description: _descriptionController.text.trim(),
          image: _selectedImage,
        );
        await ProductService().updateProduct(addProductModel);
        showTopSnackBar(context,
            const TDSnackBar.success(message: 'Product updated successfully'));
      } else {
        final addProductModel = AddProductModel(
          id: widget.product?.id,
          cateId: _selectedCategory!.id,
          productName: _nameController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          quantity: int.parse(_quantityController.text.trim()),
          description: _descriptionController.text.trim(),
          image: _selectedImage,
        );
        await ProductService().addNewProduct(addProductModel);
        showTopSnackBar(context,
            const TDSnackBar.success(message: 'Product added successfully'));
      }

      widget.onProductAdded?.call();
      _formKey.currentState!.reset();
      _resetState();
      Navigator.pop(context);
    } catch (e) {
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Operation failed: $e'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetState() {
    setState(() {
      _selectedImage = null;
      _selectedCategory = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
              title: widget.product != null ? 'Edit Product' : 'Add Product'),
          backgroundColor: AppColor.Ef5f5f5,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
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
        onPressed: _isLoading ? null : _submit,
      ),
    );
  }

  Flexible _buildName() {
    return Flexible(
      child: Column(
        children: [
          Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Name Category', style: AppStyle.bold_12)),
              const SizedBox(height: 10.0),
              CrTextField(
                controller: _nameController,
                hintText: 'Name Category',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  if (value.length < 3) {
                    return 'Product name must be at least 3 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _priceController,
                  label: 'Price',
                  hintText: 'Enter price',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value.trim());
                    if (price == null) {
                      return 'Enter a valid number';
                    }
                    if (price <= 0) {
                      return 'Price must be greater than 0';
                    }
                    if (price > 999999999) {
                      return 'Price is too high';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: _buildTextField(
                  controller: _quantityController,
                  label: 'Quantity',
                  hintText: 'Enter quantity',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity is required';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Enter a valid integer';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Category',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 5.0),
              _isCategoryLoading
                  ? const CircularProgressIndicator()
                  : _buildCategoryDropdown(),
            ],
          ),
          const SizedBox(height: 20.0),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        const SizedBox(height: 5.0),
        CrTextField(
          controller: controller,
          keyboardType: keyboardType,
          hintText: hintText,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<CategoryModel>(
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        // labelText: 'Select Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: AppColor.grey.withOpacity(0.3),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
      ),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      hint: const Text('Select Category'),
      value: _selectedCategory,
      onChanged: (CategoryModel? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator: (CategoryModel? value) {
        if (value == null) {
          return 'Please select a category';
        }
        return null;
      },
      items: _categories
          .map<DropdownMenuItem<CategoryModel>>((CategoryModel category) {
        return DropdownMenuItem<CategoryModel>(
          value: category,
          child: Text(category.name
              .toString()), // or category.name if you have a name field
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Description',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.grey.withOpacity(0.3),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _descriptionController,
              maxLines: 10,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter product description...',
              ),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
          ),
        ),
      ],
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
