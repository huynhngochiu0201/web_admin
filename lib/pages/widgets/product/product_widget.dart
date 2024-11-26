import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_admin/constants/double_extension.dart';
import 'package:web_admin/pages/widgets/product/add_product.dart';
import '../../../components/button/cr_elevated_button.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../entities/models/product_model.dart';
import '../../../services/remote/product_service.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late Future<List<ProductModel>> _productsFuture;
  final StreamController<bool> _refreshController = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
    _refreshController.stream.listen((_) {
      setState(() {
        _productsFuture = _fetchProducts();
      });
    });
  }

  @override
  void dispose() {
    _refreshController.close();
    super.dispose();
  }

  Future<List<ProductModel>> _fetchProducts() async {
    try {
      ProductService productService = ProductService();
      return await productService.fetchAllProductsByCreateAt();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> _deleteProduct(ProductModel product) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content:
              Text('Bạn có chắc chắn muốn xóa sản phẩm "${product.name}"?'),
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
      ProductService productService = ProductService();
      await productService.deleteProductById(product.id,
          categoryId: product.categoryId);
      setState(() {
        _productsFuture = _fetchProducts();
      });

      if (mounted) {
        showTopSnackBar(
          context,
          const TDSnackBar.success(message: 'Xóa sản phẩm thành công'),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopSnackBar(
          context,
          TDSnackBar.error(message: 'Xóa sản phẩm thất bại: $e'),
        );
      }
    }
  }

  Widget _buildProductRow(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
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
                    product.image ?? '-',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('ID: ${product.id}', overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10.0),
          SizedBox(width: 160, child: Text(product.quantity.toString())),
          SizedBox(width: 160, child: Text(product.price.toVND())),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProduct(
                        product: product,
                        onProductAdded: () {
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
                onTap: () => _deleteProduct(product),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return CrElevatedButton(
      text: 'Add new product',
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddProduct(
              onProductAdded: () {
                _refreshController.add(true);
              },
            ),
          ),
        );

        if (result == true) {
          // Đã được xử lý bởi onProductAdded callback
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
                Text('Product', style: AppStyle.textHeader),
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
                  child: FutureBuilder<List<ProductModel>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      final products = snapshot.data ?? [];
                      if (products.isEmpty) {
                        return const Center(
                          child: Text('No products available'),
                        );
                      }

                      return ListView.separated(
                        itemCount: products.length,
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.grey),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildProductRow(product);
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
