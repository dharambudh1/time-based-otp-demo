import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:status_alert/status_alert.dart";
import "package:totp_demo/controller/home_controller.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller.setTOTP();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time-Based OTP Demo"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: _controller.setTOTP,
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    informationText(),
                    qrCode(),
                    secretKeyListTile(),
                    form(),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget informationText() {
    return const Text(
      "Kindly install the Google or Microsoft authenticator app or any other 2-factor / multi-factor authenticator app from the App Store or Play Store.\n\nAfter the app installation of the authenticator, either scan the QR code from the screen or copy the Secret Key and paste it into the authenticator app.\n\nAfterwards, verify the Time-based One Time Password, copy the code from the installed authenticator app and paste it here into this app.",
    );
  }

  Widget qrCode() {
    return QrImage(
      foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      data: _controller.totp.value.generateUrl(issuer: "DB", account: "Test"),
      size: 300,
    );
  }

  Widget secretKeyListTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text("Secret Key"),
      subtitle: Text(_controller.totp.value.secret),
      trailing: const Icon(Icons.copy),
      onTap: () async {
        final String secretKey = _controller.totp.value.secret;
        await Clipboard.setData(ClipboardData(text: secretKey));
        showSnackBar(text: "Secret Key copied to clipboard.");
      },
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _textEditingController,
            decoration: const InputDecoration(labelText: "6 digit auth code"),
            validator: (String? value) {
              return value == null || value.isEmpty
                  ? "Please enter some text"
                  : null;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final String otp = _textEditingController.value.text;
                final bool isVerified = _controller.totp.value.verify(otp: otp);
                showStatusAlert(verify: isVerified);
              }
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
    required String text,
  }) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showStatusAlert({required bool verify}) {
    return StatusAlert.show(
      context,
      title: "Authentication",
      subtitle: verify ? "Successfully" : "Failed",
      configuration: IconConfiguration(
        icon: verify ? Icons.check : Icons.close,
      ),
    );
  }
}
