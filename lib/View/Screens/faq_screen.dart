import 'package:flutter/material.dart';
import 'package:mscl_user/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title:  Text(AppLocalizations.of(context)!.faq0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          style: IconButton.styleFrom(
           backgroundColor: const Color.fromARGB(255, 215, 229, 241),
           padding:  const EdgeInsets.only(left: 9)
         )
        ),
      ),
      body: ListView(
        children:  [
          FAQTile(
            question: AppLocalizations.of(context)!.faq1,
            answer:
                AppLocalizations.of(context)!.faq2,
          ),
          FAQTile(
            question:  AppLocalizations.of(context)!.faq3,
            answer:
               AppLocalizations.of(context)!.faq4,
          ),
          FAQTile(
            question:  AppLocalizations.of(context)!.faq5,
            answer:
               AppLocalizations.of(context)!.faq6,
          ),
          FAQTile(
            question:  AppLocalizations.of(context)!.faq7,
            answer:
                AppLocalizations.of(context)!.faq8,
          ),
          FAQTile(
            question:  AppLocalizations.of(context)!.faq9,
            answer:
                AppLocalizations.of(context)!.faq10,
          ),
        ],
      ),
    );
  }
}
class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.white),
          child: ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(answer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}