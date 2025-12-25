import 'package:flutter/material.dart';

class OrderTotal extends StatelessWidget {
  final double subTotal;
  final double discount;
  final double shipingCost;
  const OrderTotal({
    super.key,
    required this.subTotal,
    required this.discount,
    required this.shipingCost,
  });

  @override
  Widget build(BuildContext context) {
    final double total = subTotal - discount + shipingCost;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Column(
        children: [
          _showDetail('Subtotal', subTotal.toStringAsFixed(2)),
          _showDetail('Discount', discount.toStringAsFixed(2)),
          _showDetail('Shipping Cost', shipingCost.toStringAsFixed(2)),
          const Divider(height: 24, thickness: 1),
          _showDetail('Total', total.toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _showDetail(String fieldName, String fieldText) {
    bool isDiscount = fieldName.toLowerCase().contains('discount');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(fieldName, style: TextStyle(fontSize: 16, color: Colors.grey)),
        Row(
          children: [
            if (!isDiscount) ...[
              const Icon(Icons.currency_rupee, size: 16, color: Colors.green),
            ],
            if (isDiscount)
              Text(
                '$fieldText%',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            else
              Text(fieldText, style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
