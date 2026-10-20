
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final bool english;

  const AboutScreen({
    super.key,
    required this.english,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(english ? 'About Prohori' : 'প্রহরী সম্পর্কে'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0x1FC9A45C),
            child: Icon(
              Icons.mosque_rounded,
              size: 48,
              color: Color(0xFFC9A45C),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              english ? 'Prohori' : 'প্রহরী',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              english
                  ? 'Islamic Life and Goal Tracker'
                  : 'ইসলামিক জীবন ও লক্ষ্য ব্যবস্থাপনা',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          _section(
            context,
            icon: Icons.flag_rounded,
            title: english ? 'Goals' : 'লক্ষ্য',
            description: english
                ? 'Set personal goals and track your progress.'
                : 'ব্যক্তিগত লক্ষ্য তৈরি করুন এবং অগ্রগতি অনুসরণ করুন।',
          ),
          _section(
            context,
            icon: Icons.checklist_rounded,
            title: english ? "Today's Amal" : 'আজকের আমল',
            description: english
                ? 'Review your obligatory worship, Sunnah practices, good deeds and actions to avoid.'
                : 'ফরজ ইবাদত, সুন্নাহ, ভালো কাজ এবং বর্জনীয় কাজের তালিকা দেখে প্রতিদিনের আমল পর্যালোচনা করুন।',
          ),
          _section(
            context,
            icon: Icons.stars_rounded,
            title: english ? 'Amal journey' : 'আমলের যাত্রা',
            description: english
                ? 'Use the Prohori section to follow your stages and progress.'
                : 'প্রহরী বিভাগে নিজের আমলের স্তর ও অগ্রগতি অনুসরণ করুন।',
          ),
          _section(
            context,
            icon: Icons.menu_book_rounded,
            title: english ? 'Reflection' : 'আত্মসমালোচনা',
            description: english
                ? 'Review your day, recognize areas to improve and plan for tomorrow.'
                : 'দিনের কাজ পর্যালোচনা করুন, উন্নতির জায়গাগুলো চিহ্নিত করুন এবং আগামীকালের পরিকল্পনা করুন।',
          ),
          _section(
            context,
            icon: Icons.favorite_rounded,
            title: english ? 'Responsibilities' : 'দায়িত্ব ও অধিকার',
            description: english
                ? 'Keep track of responsibilities and the rights of others.'
                : 'নিজের দায়িত্ব এবং অন্যের প্রাপ্য অধিকারগুলোর প্রতি খেয়াল রাখুন।',
          ),
          _section(
            context,
            icon: Icons.tips_and_updates_rounded,
            title: english ? 'A helpful reminder' : 'একটি গুরুত্বপূর্ণ কথা',
            description: english
                ? 'This app is a personal tracker, not a religious ruling or a substitute for a qualified scholar. Verify religious references and seek reliable Islamic guidance when needed.'
                : 'এটি ব্যক্তিগত আমল পর্যালোচনার একটি সহায়ক অ্যাপ; ফতোয়া বা যোগ্য আলেমের পরামর্শের বিকল্প নয়। ধর্মীয় উদ্ধৃতি যাচাই করুন এবং প্রয়োজন হলে নির্ভরযোগ্য আলেমের পরামর্শ নিন।',
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.email_outlined,
                color: Color(0xFFC9A45C),
              ),
              title: Text(english ? 'Contact' : 'যোগাযোগ'),
              subtitle: const SelectableText('mahadisayeed@gmail.com'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              english
                  ? 'May Allah guide us towards sincere and consistent good deeds.'
                  : 'আল্লাহ আমাদের আন্তরিকতা ও ধারাবাহিকতার সঙ্গে নেক আমল করার তাওফিক দিন।',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFC9A45C), size: 27),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
