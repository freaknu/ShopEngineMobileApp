import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/app_dialogs.dart';
import 'package:ecommerce_app/core/constants/widgets/app_loading.dart';
import 'package:ecommerce_app/core/constants/widgets/button_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/custon_icon_component.dart';
import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_bloc.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_event.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_state.dart';
import 'package:ecommerce_app/features/userdetails/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class AddresscreatePage extends StatefulWidget {
  const AddresscreatePage({super.key});

  @override
  State<AddresscreatePage> createState() => _AddresscreatePageState();
}

class _AddresscreatePageState extends State<AddresscreatePage> {
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final landmarkController = TextEditingController();
  final pinCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  String addressType = 'HOME';
  double? latitude;
  double? longitude;
  bool _isHandlingSuccess = false;

  @override
  void dispose() {
    _isHandlingSuccess = false;
    nameController.dispose();
    countryController.dispose();
    cityController.dispose();
    stateController.dispose();
    landmarkController.dispose();
    pinCodeController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _getLocationAndFillFields() async {
    AppLoading.show(context, message: 'Getting your location...');
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLoading.hide();
        await AppDialogs.showInfoDialog(
          context: context,
          title: 'Location Services Disabled',
          message: 'Please enable location services to continue.',
          icon: Icons.location_off_rounded,
        );
        await Geolocator.openLocationSettings();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLoading.hide();
          await AppDialogs.showErrorDialog(
            context: context,
            title: 'Permission Denied',
            message: 'Location permission is required to auto-fill your address.',
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        AppLoading.hide();
        await AppDialogs.showErrorDialog(
          context: context,
          title: 'Permission Denied',
          message: 'Location permission is permanently denied. Please enable it from settings.',
        );
        return;
      }
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = pos.latitude;
      longitude = pos.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude!,
        longitude!,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          addressController.text = [
            place.street,
            place.subLocality,
            place.thoroughfare,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          cityController.text = place.locality ?? '';
          stateController.text = place.administrativeArea ?? '';
          countryController.text = place.country ?? '';
          pinCodeController.text = place.postalCode ?? '';
          landmarkController.text = place.subLocality ?? '';
        });
      }
      
      AppLoading.hide();
      await AppDialogs.showSuccessDialog(
        context: context,
        title: 'Location Found!',
        message: 'Your address has been auto-filled successfully.',
        buttonText: 'OK',
      );
    } catch (e) {
      AppLoading.hide();
      await AppDialogs.showErrorDialog(
        context: context,
        title: 'Location Error',
        message: 'Failed to get location: ${e.toString()}',
      );
    }
  }

  void createAddress() async {
    print("create address is called");
    final now = DateTime.now();
    context.read<AddressBloc>().add(
      AddressCreateEvent(
        Address(
          id: 0,
          userId: 0,
          addressType: addressType,
          name: nameController.text,
          email: emailController.text,
          address: addressController.text,
          city: cityController.text,
          state: stateController.text,
          landmark: landmarkController.text,
          pinCode: pinCodeController.text,
          phoneNumber: phoneNumberController.text,
          latitude: latitude ?? 0.0,
          longitude: longitude ?? 0.0,
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (previous, current) {
        // Only listen to state changes, not rebuilds of the same state
        return previous.runtimeType != current.runtimeType;
      },
      listener: (context, state) async {
        if (state is AddressLoadingState) {
          _isHandlingSuccess = false; // Reset flag when loading starts
          AppLoading.show(context, message: 'Saving address...');
        } else if (state is AddressLoadSuccess) {
          if (_isHandlingSuccess) return; // Already handling success, skip
          _isHandlingSuccess = true;
          
          AppLoading.hide();
          if (!mounted) {
            _isHandlingSuccess = false;
            return;
          }
          
          await AppDialogs.showSuccessDialog(
            context: context,
            title: 'Address Saved!',
            message: 'Your address has been saved successfully.',
            buttonText: 'Done',
          );
          if (mounted) {
            _isHandlingSuccess = false; // Reset flag before navigation
            Get.back();
          }
        } else if (state is AddressLoadedAllAddress) {
          // This state is for fetching, not for creation feedback
          // Don't show any UI here
          AppLoading.hide();
        } else if (state is AddressFailure) {
          AppLoading.hide();
          if (!mounted) return;
          
          await AppDialogs.showErrorDialog(
            context: context,
            title: 'Failed to Save',
            message: state.message,
            buttonText: 'Try Again',
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
      appBar: customAppBar('Create Address', context, [
        customIcon(
          Image.asset('assets/images/location.png',width: 30,),
          _getLocationAndFillFields,
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                textEditingController: nameController,
                fieldName: 'Name',
                placeHolder: 'Enter Your Name',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textEditingController: emailController,
                fieldName: 'Email',
                placeHolder: 'Enter Your Email',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textEditingController: phoneNumberController,
                fieldName: 'Phone Number',
                placeHolder: 'Enter Your Phone Number',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textEditingController: addressController,
                fieldName: 'Address',
                placeHolder: 'Enter Your Address',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      textEditingController: countryController,
                      fieldName: 'Country',
                      placeHolder: 'India',
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomTextField(
                      textEditingController: cityController,
                      fieldName: 'City',
                      placeHolder: 'Madhubani',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      textEditingController: stateController,
                      fieldName: 'State',
                      placeHolder: 'Enter State',
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomTextField(
                      textEditingController: pinCodeController,
                      fieldName: 'Pin Code',
                      placeHolder: 'Enter Pin Code',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textEditingController: landmarkController,
                fieldName: 'Landmark',
                placeHolder: 'Enter Landmark (optional)',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address Type',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppcolorPallets.thirdColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: addressType,
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10),
                              items: const [
                                DropdownMenuItem(
                                  value: 'HOME',
                                  child: Text('Home'),
                                ),
                                DropdownMenuItem(
                                  value: 'WORK',
                                  child: Text('Work'),
                                ),
                                DropdownMenuItem(
                                  value: 'OTHER',
                                  child: Text('Other'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => addressType = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ButtonWidget(
            buttonText: "Submit",
            buttonBackGroundColor: AppcolorPallets.primaryColor,
            buttonTextColor: Colors.white,
            onClick: createAddress,
          ),
        ),
      ),
      ),
    );
  }
}
