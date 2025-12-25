# Reusable UI Components

## Overview
This directory contains modern, reusable UI components following clean architecture principles that can be used throughout the app.

## Components

### 1. AppDialogs (app_dialogs.dart)

Beautiful, modern dialogs with glassmorphism effects and gradient styling.

#### Confirmation Dialog (Yes/No)
```dart
// Example: Logout confirmation
final result = await AppDialogs.showConfirmationDialog(
  context: context,
  title: 'Logout',
  message: 'Are you sure you want to logout?',
  confirmText: 'Yes, Logout',
  cancelText: 'Cancel',
  icon: Icons.logout_rounded,
  isDangerous: true, // Makes button red for dangerous actions
);

if (result == true) {
  // User confirmed - perform action
  _logout();
}
```

#### Delete Confirmation
```dart
final result = await AppDialogs.showConfirmationDialog(
  context: context,
  title: 'Delete Item',
  message: 'This item will be permanently deleted. Continue?',
  confirmText: 'Delete',
  cancelText: 'Keep',
  icon: Icons.delete_rounded,
  isDangerous: true,
);

if (result == true) {
  _deleteItem();
}
```

#### Info Dialog
```dart
await AppDialogs.showInfoDialog(
  context: context,
  title: 'Welcome!',
  message: 'Thank you for using our app. Enjoy shopping!',
  buttonText: 'Get Started',
  icon: Icons.celebration_rounded,
);
```

#### Success Dialog
```dart
await AppDialogs.showSuccessDialog(
  context: context,
  title: 'Order Placed!',
  message: 'Your order has been successfully placed and will be delivered soon.',
  buttonText: 'Track Order',
);
```

#### Error Dialog
```dart
await AppDialogs.showErrorDialog(
  context: context,
  title: 'Payment Failed',
  message: 'Unable to process payment. Please try again.',
  buttonText: 'Retry',
);
```

### 2. AppLoading (app_loading.dart)

Modern loading indicators with beautiful animations.

#### Loading Overlay (for async operations)
```dart
// Show loading
AppLoading.show(context, message: 'Processing payment...');

try {
  await _processPayment();
  AppLoading.hide();
  // Show success
} catch (e) {
  AppLoading.hide();
  // Show error
}
```

#### Full Screen Loading
```dart
// Use as a page while fetching data
return LoadingScreen(message: 'Loading your orders...');
```

#### Small Inline Loading
```dart
// For buttons or small spaces
SmallLoadingIndicator(
  size: 24,
  color: Colors.white,
)
```

## Usage Examples in BLoC Pattern

### In Authentication

```dart
// In login button onPressed
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthLoading) {
      AppLoading.show(context, message: 'Signing in...');
    } else if (state is AuthSuccess) {
      AppLoading.hide();
      AppDialogs.showSuccessDialog(
        context: context,
        title: 'Welcome Back!',
        message: 'You have successfully logged in.',
      );
    } else if (state is AuthError) {
      AppLoading.hide();
      AppDialogs.showErrorDialog(
        context: context,
        title: 'Login Failed',
        message: state.message,
      );
    }
  },
  child: YourLoginForm(),
)
```

### In Product Operations

```dart
// Delete product from cart
Future<void> _deleteProduct(String productId) async {
  final confirm = await AppDialogs.showConfirmationDialog(
    context: context,
    title: 'Remove from Cart',
    message: 'Remove this item from your cart?',
    confirmText: 'Remove',
    cancelText: 'Keep',
    icon: Icons.remove_shopping_cart_rounded,
    isDangerous: true,
  );

  if (confirm == true) {
    AppLoading.show(context);
    context.read<CartBloc>().add(RemoveFromCart(productId));
  }
}
```

### In Order Placement

```dart
BlocListener<OrderBloc, OrderState>(
  listener: (context, state) {
    if (state is OrderPlacing) {
      AppLoading.show(context, message: 'Placing your order...');
    } else if (state is OrderPlaced) {
      AppLoading.hide();
      AppDialogs.showSuccessDialog(
        context: context,
        title: 'Order Confirmed!',
        message: 'Order #${state.orderId} has been placed successfully.',
        buttonText: 'View Order',
      ).then((_) {
        // Navigate to order details
        Get.toNamed('/order-details', arguments: state.orderId);
      });
    } else if (state is OrderError) {
      AppLoading.hide();
      AppDialogs.showErrorDialog(
        context: context,
        title: 'Order Failed',
        message: state.message,
        buttonText: 'Try Again',
      );
    }
  },
  child: YourCheckoutButton(),
)
```

## Design Features

- ✨ **Glassmorphism Effects**: Frosted glass appearance with backdrop blur
- 🎨 **Gradient Styling**: Uses app's color palette for consistency
- 🌊 **Smooth Animations**: Scale, fade, and rotation animations
- 🎯 **Material Design 3**: Modern, accessible design patterns
- 📱 **Responsive**: Works on all screen sizes
- ⚡ **Performance**: Optimized animations with proper disposal
- 🎭 **Context-Aware**: Different styles for success, error, warning
- 🔒 **Type-Safe**: Full TypeScript-like type safety

## Best Practices

1. **Always hide loading overlays** in both success and error cases
2. **Use dangerous flag** for destructive actions (delete, logout)
3. **Provide clear messages** that explain what will happen
4. **Handle dialog results** properly (can be null if dismissed)
5. **Show loading** for any operation taking >300ms
6. **Use appropriate icons** for better visual communication

## Clean Architecture Integration

These components live in the `core/constants/widgets` layer and can be used by:
- ✅ Presentation Layer (pages, widgets)
- ✅ BLoC Listeners and Builders
- ❌ Domain Layer (keep business logic pure)
- ❌ Data Layer (no UI dependencies)

## Customization

All components use `AppcolorPallets` for theming. To change the look globally:
1. Update colors in `appcolor_pallets.dart`
2. All dialogs and loading screens will automatically update
