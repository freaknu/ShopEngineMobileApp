import 'package:ecommerce_app/core/constants/widgets/custon_icon_component.dart';
import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';
import 'package:flutter/material.dart';

class AddressCardWidget extends StatelessWidget {
  final Address address;
  final bool isSelected; 
  final VoidCallback?
  onTap; 
  final VoidCallback? onEdit; 
  final VoidCallback? onDelete; 

  const AddressCardWidget({
    super.key,
    required this.address,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6), // reduced horizontal padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 1.5 : 0.5, // even thinner border
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18), // reduced horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Type + Name
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(
                        address.addressType,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTypeIcon(address.addressType),
                          size: 20,
                          color: _getTypeColor(address.addressType),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          (address.addressType ?? 'Other').toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _getTypeColor(address.addressType),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      address.name ?? 'Unnamed',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Full Address
              Text(
                address.address ?? '',
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),

              if (address.landmark?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  'Near ${address.landmark}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              const SizedBox(height: 6),

              Text(
                '${address.city}, ${address.state} - ${address.pinCode}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 14),

              // Contact Info Row
              Column(
                children: [
                  _contactItem(
                    Icons.phone_outlined,
                    address.phoneNumber ?? 'N/A',
                  ),
                  const SizedBox(width: 20),
                  _contactItem(Icons.email_outlined, address.email ?? 'N/A'),
                ],
              ),

              const SizedBox(height: 16),

              // Action Buttons (Edit / Delete)
              if (onEdit != null || onDelete != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      customIcon(
                        Image.asset('assets/images/edit.png', width: 22, height: 22),
                        onEdit,
                      ),
                      SizedBox(width: 10,),
                    if (onDelete != null)
                      customIcon(
                        Image.asset('assets/images/trash.png', width: 22, height: 22),
                        onDelete,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  IconData _getTypeIcon(String? type) {
    switch (type?.toUpperCase()) {
      case 'HOME':
        return Icons.home_outlined;
      case 'WORK':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }

  Color _getTypeColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'HOME':
        return Colors.green.shade600;
      case 'WORK':
        return Colors.blue.shade600;
      default:
        return Colors.orange.shade700;
    }
  }
}
