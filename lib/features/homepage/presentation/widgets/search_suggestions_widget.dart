import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final List<Product> products;
  final VoidCallback onProductSelected;
  
  const SearchSuggestionsWidget({
    super.key,
    required this.products,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppcolorPallets.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: products.length > 10 ? 10 : products.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.grey[200],
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              dense: true,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppcolorPallets.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppcolorPallets.primaryColor,
                  size: 20,
                ),
              ),
              title: Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '\$${product.productPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey[400],
              ),
              onTap: () {
                onProductSelected();
                Get.toNamed('/product', arguments: product.id);
              },
            );
          },
        ),
      ),
    );
  }
}
