import 'package:ecommerce_app/core/common/widgets/common_message_dialog.dart';
import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
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

class AddressupdatePage extends StatefulWidget {
  final Address address;
  const AddressupdatePage({super.key, required this.address});

  @override
  State<AddressupdatePage> createState() => _AddressupdatePageState();
}

class _AddressupdatePageState extends State<AddressupdatePage> {
  late final TextEditingController nameController;
  late final TextEditingController countryController;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController landmarkController;
  late final TextEditingController pinCodeController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController emailController;
  late final TextEditingController addressController;
  String addressType = 'HOME';
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.address.name ?? '');
    emailController = TextEditingController(text: widget.address.email ?? '');
    phoneNumberController = TextEditingController(
      text: widget.address.phoneNumber ?? '',
    );
    addressController = TextEditingController(
      text: widget.address.address ?? '',
    );
    countryController =
        TextEditingController(); // Address model may not have country
    cityController = TextEditingController(text: widget.address.city ?? '');
    stateController = TextEditingController(text: widget.address.state ?? '');
    pinCodeController = TextEditingController(
      text: widget.address.pinCode ?? '',
    );
    landmarkController = TextEditingController(
      text: widget.address.landmark ?? '',
    );
    addressType = widget.address.addressType ?? 'HOME';
    latitude = widget.address.latitude;
    longitude = widget.address.longitude;
  }

  Future<void> _getLocationAndFillFields() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission permanently denied'),
          ),
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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
    }
  }

  void updateAddress() async {
    final now = DateTime.now();
    context.read<AddressBloc>().add(
      AddressUpdateEvent(
        Address(
          id: widget.address.id,
          userId: widget.address.userId,
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
          createdAt: widget.address.createdAt,
          updatedAt: now,
        ),
      ),
    );
  }

  void updateSuccessEvent(String message) {
    showDialog(
      context: context,
      builder: (context) => CommonMessageDialog(message: message, flag: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressLoadedAllAddress) {
          updateSuccessEvent('Address updated successfully');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar('Edit Address', context, [
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
                              color: AppcolorPallets.thirdColor.withOpacity(
                                0.5,
                              ),
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
              buttonText: "Update",
              buttonBackGroundColor: AppcolorPallets.primaryColor,
              buttonTextColor: Colors.white,
              onClick: updateAddress,
            ),
          ),
        ),
      ),
    );
  }
}
