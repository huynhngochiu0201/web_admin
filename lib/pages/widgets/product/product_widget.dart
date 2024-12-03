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
import 'package:intl/intl.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
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
          ),
          Expanded(flex: 2, child: Text(product.quantity.toString())),
          Expanded(flex: 2, child: Text(product.price.toVND())),
          Expanded(
            flex: 2,
            child: Text(
              product.createAt != null
                  ? DateFormat('dd/MM/yyyy HH:mm')
                      .format(product.createAt!.toDate())
                  : '-',
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProduct(
                          product: product,
                          onProductAdded: () {},
                        ),
                      ),
                    );

                    if (result == true) {
                      // Giao diện sẽ tự động cập nhật qua StreamBuilder
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
              onProductAdded: () {},
            ),
          ),
        );

        if (result == true) {
          // Giao diện sẽ tự động cập nhật qua StreamBuilder
        }
      },
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text('Product')),
          Expanded(flex: 2, child: Text('Quantitl')),
          Expanded(flex: 2, child: Text('Price')),
          Expanded(flex: 2, child: Text('Time')),
          Expanded(flex: 1, child: Text('')),
        ],
      ),
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
            _buildTableHeader(),
            const SizedBox(height: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: StreamBuilder<List<ProductModel>>(
                    stream: ProductService().fetchProductsStream(),
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
