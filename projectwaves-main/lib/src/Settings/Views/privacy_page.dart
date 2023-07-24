import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Privacy Settings',
          style: TextStyle(
            color: Colors.black, // Couleur du texte du titre
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Here you can customize your privacy settings and manage who can see your information.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Information Collected',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('When you use our application, we may collect the following information:'),
              SizedBox(height: 8.0),
              Text('Personal Information: such as your name, email address, phone number, IP address, geographical location, etc. This information may be collected when you create an account, fill out forms, use interactive features, or communicate with us through the application.'),
              SizedBox(height: 8.0),
              Text('Device Information: such as device model, operating system, unique device identifier, error logs, etc. This information is automatically collected to improve the performance of the application and provide personalized features.'),
              SizedBox(height: 16.0),
              Text(
                '2. Use of Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('We use the collected information for the following purposes:'),
              SizedBox(height: 8.0),
              Text('Provide and improve our services: We use your information to provide you with the features of the application, respond to your requests, personalize your user experience, and improve the quality of our services.'),
              SizedBox(height: 8.0),
              Text('Communication with you: We may use your email address or other contact details to send you notifications, updates, information about our products or services, or for marketing purposes, with your consent if required by applicable law.'),
              SizedBox(height: 8.0),
              Text('Data Security: We implement appropriate security measures to protect your information against unauthorized access, loss, or damage.'),
              SizedBox(height: 16.0),
              Text(
                '3. Sharing of Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('We do not share your personal information with third parties except in the following circumstances:'),
              SizedBox(height: 8.0),
              Text('Service Providers: We may share your information with third parties who assist us in providing our services, such as data storage service providers, analytics providers, etc. These third parties are required to protect your information in accordance with this privacy policy.'),
              SizedBox(height: 8.0),
              Text('Legal Compliance: We may share your information if we are legally obligated to do so, for example, in response to a legal request, court order, or government authorities demand'),
              SizedBox(height: 16.0),
              Text(
                '4. Your Choices and Rightsn',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('You have the right to access, update, delete, or restrict the use of your personal information. You can also choose not to receive promotional communications from us. Please contact us to exercise your rights or if you have any questions regarding your personal information.'),
              SizedBox(height: 16.0),
              Text(
                '5. Cookies and Similar Technologies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('We use cookies and other similar technologies to collect information and enhance your user experience. You can manage your cookie preferences through your device or application settings.'),
              SizedBox(height: 16.0),
              Text(
                '6. Changes to the Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('We reserve the right to modify this privacy policy at any time. Any changes will be posted on this page with the updated date. Please regularly review this privacy policy to stay informed about any modifications.'),
              SizedBox(height: 8.0),
              Text('We are committed to complying with applicable laws and regulations regarding data privacy and protecting the confidentiality of your personal information.'),
              SizedBox(height: 8.0),
              Text('If you have any questions, comments, or concerns regarding our privacy policy, please contact us at [contact email address].'),
              SizedBox(height: 8.0),
              Text('Thank you for using our application !'),
              // Ajoutez plus d'options de confidentialité et de descriptions si nécessaire
            ],
          ),
        ),
      ),
    );
  }
}
