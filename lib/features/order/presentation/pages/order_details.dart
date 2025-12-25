import 'package:ecommerce_app/core/common/widgets/common_message_dialog.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/button_widget.dart';
import 'package:ecommerce_app/features/order/domain/entity/order_response.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_event.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_state.dart';
import 'package:ecommerce_app/features/product/domain/entity/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final Product product;
  final OrderResponse orderResponse;
  const OrderDetails({
    super.key,
    required this.product,
    required this.orderResponse,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ({Color bgColor, Color textColor, IconData icon, String displayStatus})
  getStatusInfo() {
    final status = widget.orderResponse.orderStatus.toLowerCase();
    switch (status) {
      case 'delivered':
        return (
          bgColor: Colors.green.withOpacity(0.12),
          textColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
          displayStatus: 'Delivered',
        );
      case 'shipped':
      case 'out for delivery':
        return (
          bgColor: Colors.blue.withOpacity(0.12),
          textColor: Colors.blue.shade700,
          icon: Icons.local_shipping_outlined,
          displayStatus: 'On the Way',
        );
      case 'processing':
        return (
          bgColor: Colors.orange.withOpacity(0.12),
          textColor: Colors.orange.shade700,
          icon: Icons.schedule_outlined,
          displayStatus: 'Processing',
        );
      case 'cancelled':
        return (
          bgColor: Colors.red.withOpacity(0.12),
          textColor: Colors.red.shade700,
          icon: Icons.cancel_outlined,
          displayStatus: 'Cancelled',
        );
      default:
        return (
          bgColor: Colors.grey.withOpacity(0.12),
          textColor: Colors.grey.shade700,
          icon: Icons.info_outline,
          displayStatus: widget.orderResponse.orderStatus,
        );
    }
  }

  void _cancelOrder() {
    context.read<OrderBloc>().add(OrderCancelEvent(widget.orderResponse.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final product = widget.product;
    final order = widget.orderResponse;
    final address = order.address;
    final statusInfo = getStatusInfo();

    final subtotal = product.productPrice * (1);
    final discountAmount = subtotal * (order.discount / 100);
    final total = subtotal - discountAmount;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: customAppBar('Order Details', context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: product.productsImages.isNotEmpty
                        ? Image.network(
                            product.productsImages[0],
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) =>
                                progress == null
                                ? child
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Container(
                            width: 110,
                            height: 110,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.productName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.categoryName,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₹${product.productPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: 1',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: statusInfo.bgColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      statusInfo.icon,
                                      size: 18,
                                      color: statusInfo.textColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        statusInfo.displayStatus,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: statusInfo.textColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Description (if exists)
            if (product.productDescription.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.productDescription,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Order Information
            _buildSectionCard(
              title: 'Order Information',
              children: [
                _buildInfoRow('Order ID', order.id.toString()),
                _buildInfoRow(
                  'Order Date',
                  DateFormat(
                    'dd MMM yyyy, hh:mm a',
                  ).format(order.orderDate.toLocal()),
                ),
                _buildInfoRow(
                  'Expected Delivery',
                  order.deliveryDate != null
                      ? DateFormat('dd MMM yyyy').format(order.deliveryDate.toLocal())
                      : 'To be confirmed',
                ),
                _buildInfoRow('Quantity', (1).toString()),
                _buildInfoRow('Discount Applied', '${order.discount}%'),
              ],
            ),

            const SizedBox(height: 16),

            // Price Breakdown
            _buildSectionCard(
              title: 'Price Details',
              children: [
                _buildPriceRow(
                  'Subtotal (${1} item${(1) > 1 ? 's' : ''})',
                  '₹${subtotal.toStringAsFixed(2)}',
                ),
                _buildPriceRow(
                  'Discount (${order.discount}%)',
                  '- ₹${discountAmount.toStringAsFixed(2)}',
                  isDiscount: true,
                ),
                const Divider(height: 30, thickness: 1),
                _buildPriceRow(
                  'Total Paid',
                  '₹${total.toStringAsFixed(2)}',
                  isBold: true,
                  color: primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Shipping Address
            _buildSectionCard(
              title: 'Shipping Address',
              icon: Icons.location_on_outlined,
              children: [
                Text(
                  '${address.name} • ${address.addressType}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  address.address,
                  style: TextStyle(color: Colors.grey[800], fontSize: 14.5),
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.city}, ${address.state} - ${address.pinCode}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                if (address.landmark.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Landmark: ${address.landmark}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  'Phone: ${address.phoneNumber}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Email: ${address.email}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: (order.orderStatus.toLowerCase() != 'cancelled' && order.orderStatus.toLowerCase() != 'delivered')
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: BlocConsumer<OrderBloc, OrderState>(
                  listener: (context, state) {
                    if (state is OrderPlacedState) {
                      showDialog(
                        context: context,
                        builder: (context) => const CommonMessageDialog(
                          message: 'Order cancelled successfully!',
                          flag: true,
                        ),
                      );
                    } else if (state is OrderFailedState) {
                      showDialog(
                        context: context,
                        builder: (context) => CommonMessageDialog(
                          message: 'Failed to cancel order.',
                          flag: false,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is OrderPlacedState) {
                      // Hide button after successful cancel
                      return const SizedBox.shrink();
                    }
                    return ButtonWidget(
                      buttonText: 'Cancel Order',
                      buttonBackGroundColor: Colors.redAccent,
                      buttonTextColor: Colors.white,
                      onClick: () => _cancelOrder(),
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSectionCard({
    required String title,
    IconData? icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: primaryColor, size: 22),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.5, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.5,
                color: isDiscount ? Colors.green.shade700 : Colors.grey[800],
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color:
                    color ??
                    (isDiscount ? Colors.green.shade700 : Colors.black),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
