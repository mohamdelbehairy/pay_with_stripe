 # Pay with Strip

Pay with Strip is a Flutter package that simplifies the Stripe payment process. Instead of handling multiple steps manually, this package allows you to complete the entire payment process with just a single line of code.

With this package, you can easily collect payment details using Stripe’s secure infrastructure, providing a smooth and hassle-free experience for both developers and users.


### Android & iOS

| Android | iOS |
|---------|-----|
| <img src="https://github.com/user-attachments/assets/1efb9d66-6230-44a8-94d3-f657ffb7921f" height="500"/> | <img src="https://github.com/user-attachments/assets/e38338cf-38f0-431c-ac67-aaa87257d247" height="500"/> |


#### Recommended usage

If you're selling digital products or services within your app, (e.g. subscriptions, in-game currencies, game levels, access to premium content, or unlocking a full version), you must use the app store's in-app purchase APIs. See [Apple's](https://developer.apple.com/app-store/review/guidelines/#payments) and [Google's](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en&ref_topic=9857752) guidelines for more information. For all other scenarios you can use this SDK to process payments via Stripe.

## 🚀  Installation

To install the Pay with strip Package, follow these steps

1. Add the package to your project's dependencies in the `pubspec.yaml` file:
   ```yaml
   dependencies:
     pay_with_strip: ^0.0.1
    ``` 
2. Run the following command to fetch the package:

    ``` 
    flutter pub get
    ``` 



### Requirements
#### Note: Currently, this package supports only Android and iOS. Web support is planned for future updates.

#### Android


This plugin requires several changes to be able to work on Android devices. Please make sure you follow all these steps:

1. Use Android 5.0 (API level 21) and above.
2. Use Kotlin version 1.8.0 and above: [example](https://github.com/flutter-stripe/flutter_stripe/blob/main/example/android/settings.gradle#L22)
3. Requires Android Gradle plugin 8 and higher
4. Using a descendant of `Theme.AppCompat` for your activity: [example](https://github.com/flutter-stripe/flutter_stripe/blob/main/example/android/app/src/main/res/values/styles.xml#L15), [example night theme](https://github.com/flutter-stripe/flutter_stripe/blob/main/example/android/app/src/main/res/values-night/styles.xml#L16)
5. Using an up-to-date Android gradle build tools version: [example](https://github.com/flutter-stripe/flutter_stripe/blob/main/example/android/build.gradle#L9) and an up-to-date gradle version accordingly: [example](https://github.com/flutter-stripe/flutter_stripe/blob/main/example/android/gradle/wrapper/gradle-wrapper.properties#L6) 
6. Using `FlutterFragmentActivity` instead of `FlutterActivity` in `MainActivity.kt`: [example](https://github.com/flutter-stripe/flutter_stripe/blob/79b201a2e9b827196d6a97bb41e1d0e526632a5a/example/android/app/src/main/kotlin/com/flutter/stripe/example/MainActivity.kt#L6)
7. Add the following rules to your `proguard-rules.pro` file: [example](https://github.com/flutter-stripe/flutter_stripe/blob/master/example/android/app/proguard-rules.pro)  
```proguard
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
```
8. Add the following line to your `gradle.properties` file: [example](https://github.com/flutter-stripe/flutter_stripe/blob/master/example/android/gradle.properties)
```properties
android.enableR8.fullMode=false
```
This will prevent crashes with the Stripe SDK on Android (see [issue](https://github.com/flutter-stripe/flutter_stripe/issues/1909)).

9. Rebuild the app, as the above changes don't update with hot reload

These changes are needed because the Android Stripe SDK requires the use of the AppCompat theme for their UI components and the Support Fragment Manager for the Payment Sheets

If you are having troubles to make this package to work on Android, join [this discussion](https://github.com/flutter-stripe/flutter_stripe/discussions/538) to get some support.

#### iOS

Compatible with apps targeting iOS 13 or above.

To upgrade your iOS deployment target to 13.0, you can either do so in Xcode under your Build Settings, or by modifying IPHONEOS_DEPLOYMENT_TARGET in your project.pbxproj directly.

You will also need to update in your Podfile:

`platform :ios, '13.0'`

For card scanning add the following to your Info.plist:

```xml
<key>NSCameraUsageDescription</key>
<string>Scan your card to add it automatically</string>
<key>NSCameraUsageDescription</key>
<string>To scan cards</string>
```

## Usage
1. Import the package into your Dart file:

    ``` 
    import 'package:pay_with_strip/pay_with_strip.dart';
    ```
2. To initiate a payment using Pay with Strip, use the following method:
    ```dart
    final result = await PayWithStrip.makePayment(
        paymentModel: PaymentModel(
        publishableKey: publishableKey, // get publish key from strip dashboard
        secretKey:secretKey, // get secretKey key from strip dashboard
        amount: 100)); // $100  

    log("result: $result"); 
    
    ```    
3. **(Optional)** Save card details for future payments  

   If you want to **store the user's card details**, so they don't need to enter them again for future payments, use the following method **once during account creation**:  

    ```dart
    await PayWithStrip.createCustomer(
        customerModel: CustomerModel(
        customerId: "customerId", // A unique ID created for the user
        secretKey: "secretKey")); // get secretKey key from strip dashboard
    ```  
   
   - This allows the user to **make future payments instantly** without re-entering card details.  
   - The **`customerId`** used here must be the **same** as the one used during payment to link the saved card to the user.  
   - If this method is not used, the user will need to enter their card details manually for each transaction.  



### Payment Configuration Parameters  

Below is a list of parameters required to configure and process a payment using **Pay with Strip**.  
Mandatory fields are marked as **required**, while others are optional and can be customized based on your needs.  

| Attribute              | Type         | Required | Description |
|------------------------|-------------|----------|-------------|
| `publishableKey`      | `String`     | ✅ Yes  | The publishable key from your Stripe dashboard. |
| `secretKey`          | `String`     | ✅ Yes  | The secret key from your Stripe dashboard. |
| `amount`             | `num`        | ✅ Yes  | The payment amount (e.g., `100` for $100). |
| `currency`           | `Currency`   | ❌ No  | The currency for the payment. Supports only **USD** and **EUR**. Defaults to **USD** if not provided. |
| `saveCard`           | `bool`       | ❌ No  | If `true`, the card details will be saved for future use. The user won't need to re-enter them. |
| `customerId`         | `String?`    | ❌ No  | A unique ID for the user. Required for saving and reusing cards. Can only be used if the user already exists in Stripe's Customers database. |
| `merchantDisplayName` | `String`     | ❌ No  | The name of the merchant displayed in the payment UI. |
| `style`              | `ThemeMode?` | ❌ No  | The theme style for the payment UI (e.g., light or dark mode). |



## ⚡ Donate 

If you would like to support me, please consider making a donation through one of the following links:

* [PayPal](https://paypal.me/Elbehairy20)

* [Contact with me](https://www.linkedin.com/in/mohamed-elbehairy-899957258/?trk=public-profile-join-page)

Thank you for your support!