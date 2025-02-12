import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mscl_user/Controller/locale_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mscl_user/color.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Set the initial selected language based on the current locale
    final currentLocale = Provider.of<LanguageProvider>(context, listen: false).locale.languageCode;
    _selectedLanguage = currentLocale == 'ta' ? 'Tamil' : 'English';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title:  Text(AppLocalizations.of(context)!.lang),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          style: IconButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 215, 229, 241),
            padding: const EdgeInsets.only(left: 9)
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LanguageOption(
              language: 'Tamil',
              isSelected: _selectedLanguage == 'Tamil',
              onTap: () {
                setState(() {
                  _selectedLanguage = 'Tamil';
                });
                Provider.of<LanguageProvider>(context, listen: false).setLocale('ta');
              },
            ),
            const SizedBox(height: 16.0),
            LanguageOption(
              language: 'English',
              isSelected: _selectedLanguage == 'English',
              onTap: () {
                setState(() {
                  _selectedLanguage = 'English';
                });
                Provider.of<LanguageProvider>(context, listen: false).setLocale('en');
              },
            ),
          
          ],
        ),
      ),
    );
  }
}

class LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOption({super.key, 
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}
