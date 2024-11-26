import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_admin/components/button/cr_elevated_button.dart';
import 'package:web_admin/pages/widgets/category/add_category.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../entities/models/category_model.dart';
import '../../../services/remote/category_service.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late final CategoryService _categoryService;
  late Future<List<CategoryModel>> _categoriesFuture;

  // Thêm loading state
  bool _isLoading = false;

  // Thêm StreamController để quản lý cập nhật
  final StreamController<bool> _refreshController = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _categoryService = CategoryService();
    _categoriesFuture = _categoryService.fetchCategories();

    // Lắng nghe sự kiện refresh
    _refreshController.stream.listen((_) {
      _refreshCategories();
    });
  }

  @override
  void dispose() {
    _refreshController.close();
    super.dispose();
  }

  // Cải thiện hàm refresh để xử lý loading state
  Future<void> _refreshCategories() async {
    if (_isLoading) return; // Tránh gọi nhiều lần khi đang loading

    setState(() {
      _isLoading = true;
      _categoriesFuture = _categoryService.fetchCategories();
    });

    try {
      await _categoriesFuture;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Cải thiện hàm delete với dialog xác nhận
  Future<void> _deleteCategory(
      BuildContext context, CategoryModel category) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content:
              Text('Bạn có chắc chắn muốn xóa danh mục "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      setState(() => _isLoading = true);
      await _categoryService.deleteCategory(category.id);

      // Cập nhật lại categoriesFuture trực tiếp thay vì gọi _refreshCategories
      setState(() {
        _categoriesFuture = _categoryService.fetchCategories();
      });

      if (mounted) {
        showTopSnackBar(
          context,
          const TDSnackBar.success(message: 'Xóa danh mục thành công'),
        );
      }
    } catch (error) {
      if (mounted) {
        showTopSnackBar(
          context,
          TDSnackBar.error(message: 'Xóa danh mục thất bại: $error'),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Cải thiện phần hiển thị danh sách
  Widget _buildCategoryItem(CategoryModel category) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  category.image ?? '-',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            SizedBox(
              width: 400,
              child: Text(
                category.name ?? 'Không có tên',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCategory(
                        category: category,
                        onCategoryAdded: () {
                          _refreshController.add(true);
                        },
                      ),
                    ),
                  );

                  if (result == true) {
                    // Refresh handled by onProductAdded callback
                  }
                },
                child: const Text('Edit'),
              ),
            GestureDetector(
              onTap: () => _deleteCategory(context, category),
              child: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }

  // Sửa lại phần CrElevatedButton trong build method
  Widget _buildAddButton() {
    return CrElevatedButton(
      text: 'Add new category',
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddCategory(
              onCategoryAdded: () {
                // Trigger refresh khi thêm thành công
                _refreshController.add(true);
              },
            ),
          ),
        );

        // Nếu có result và thành công thì refresh
        if (result == true) {
          _refreshController.add(true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.Ef5f5f5,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
        ).copyWith(top: 10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category', style: AppStyle.textHeader),
                const Spacer(),
                _buildAddButton(),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FutureBuilder<List<CategoryModel>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final categories = snapshot.data ?? [];
                      if (categories.isEmpty) {
                        return const Center(
                            child: Text('Không có danh mục nào'));
                      }

                      return ListView.separated(
                        itemCount: categories.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return _buildCategoryItem(category);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
