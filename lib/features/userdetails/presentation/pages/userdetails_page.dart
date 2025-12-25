import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/app_dialogs.dart';
import 'package:ecommerce_app/core/constants/widgets/app_loading.dart';
import 'package:ecommerce_app/core/constants/widgets/button_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/custon_icon_component.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_bloc.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_event.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_state.dart';
import 'package:ecommerce_app/features/userdetails/presentation/pages/addressupdate_page.dart';
import 'package:ecommerce_app/features/userdetails/presentation/widgets/addresscard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserdetailsPage extends StatefulWidget {
  const UserdetailsPage({super.key});

  @override
  State<UserdetailsPage> createState() => _UserdetailsPageState();
}

class _UserdetailsPageState extends State<UserdetailsPage> {
  int? defaultAddressId;
  bool _isDeletingAddress = false;
  bool _isHandlingSuccess = false;

  @override
  void initState() {
    _loadDefaultAddress();
    _getAllAddress();
    super.initState();
  }

  @override
  void dispose() {
    _isHandlingSuccess = false;
    _isDeletingAddress = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload default address when returning from update page
    _loadDefaultAddress();
  }

  Future<void> _loadDefaultAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      defaultAddressId = prefs.getInt('default_address_id');
    });
  }

  Future<void> _setDefaultAddress(int addressId) async {
    if (addressId == -1) return; // Invalid address ID

    try {
      final prefs = await SharedPreferences.getInstance();

      // If clicking on already selected address, unselect it
      if (addressId == defaultAddressId) {
        await prefs.remove('default_address_id');
        if (mounted) {
          setState(() {
            defaultAddressId = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Default address removed'),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          print("Default address removed");
        }
        return;
      }

      // Set new default address
      final success = await prefs.setInt('default_address_id', addressId);

      if (success && mounted) {
        setState(() {
          defaultAddressId = addressId;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Default address updated successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Debug print
        print("Default address saved: $addressId");
      } else {
        throw Exception('Failed to save address to preferences');
      }
    } catch (e) {
      print("Error saving default address: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Failed to save default address'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _getAllAddress() {
    context.read<AddressBloc>().add(AddressGetEvent());
  }

  void _deleteAddress(int addressId) async {
    final confirm = await AppDialogs.showConfirmationDialog(
      context: context,
      title: 'Delete Address',
      message:
          'Are you sure you want to delete this address? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_rounded,
      isDangerous: true,
    );

    if (confirm == true) {
      // If deleting the default address, remove it from preferences
      if (addressId == defaultAddressId) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('default_address_id');
        setState(() {
          defaultAddressId = null;
        });
        print("Removed default address from preferences");
      }

      setState(() {
        _isDeletingAddress = true;
      });
      context.read<AddressBloc>().add(AddressDeleteEvent(addressId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Addresses', context, [
        customIcon(
          Image.asset('assets/images/plus.png', width: 30),
          () => Get.toNamed('/addresscreate'),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: SingleChildScrollView(
          child: BlocConsumer<AddressBloc, AddressState>(
            listenWhen: (previous, current) {
              // Only listen to state changes, not rebuilds of the same state
              return previous.runtimeType != current.runtimeType;
            },
            listener: (context, state) async {
              // Handle loading state for delete operations
              if (state is AddressLoadingState && _isDeletingAddress) {
                _isHandlingSuccess = false; // Reset flag when loading starts
                AppLoading.show(context, message: 'Deleting address...');
              } else if (state is AddressDeleteState) {
                if (_isHandlingSuccess)
                  return; // Already handling success, skip
                _isHandlingSuccess = true;

                AppLoading.hide();
                setState(() {
                  _isDeletingAddress = false;
                });
                if (!mounted) return;
                
                await AppDialogs.showSuccessDialog(
                  context: context,
                  title: 'Address Deleted',
                  message: 'The address has been successfully deleted.',
                  buttonText: 'OK',
                );
              } else if (state is AddressFailure) {
                if (_isDeletingAddress) {
                  AppLoading.hide();
                  setState(() {
                    _isDeletingAddress = false;
                  });
                }
                if (!mounted) return;
                
                await AppDialogs.showErrorDialog(
                  context: context,
                  title: 'Error',
                  message: state.message,
                  buttonText: 'OK',
                );
              }
            },
            builder: (context, state) {
              if (state is AddressLoadedAllAddress) {
                if (state.allAddress.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No addresses found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new address to get started!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 200,
                          child: ButtonWidget(
                            buttonText: "Create Address",
                            buttonBackGroundColor: AppcolorPallets.primaryColor,
                            buttonTextColor: Colors.white,
                            onClick: () => Get.toNamed('/addresscreate'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: state.allAddress
                      .map(
                        (address) => AddressCardWidget(
                          address: address,
                          isSelected: address.id == defaultAddressId,
                          onTap: () => _setDefaultAddress(address.id ?? -1),
                          onEdit: () =>
                              Get.to(AddressupdatePage(address: address)),
                          onDelete: () => _deleteAddress(address.id ?? -1),
                        ),
                      )
                      .toList(),
                );
              } else if (state is AddressLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
