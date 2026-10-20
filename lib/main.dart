
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/worship_screen.dart';
import 'screens/rights_screen.dart';
import 'screens/reflection_screen.dart';
import 'screens/report_screen.dart';
import 'screens/today_amal_screen.dart';
import 'services/storage_service.dart';
import 'services/daily_content_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PathcholaApp());
}

class PathcholaApp extends StatefulWidget {
  const PathcholaApp({super.key});

  @override
  State<PathcholaApp> createState() => _PathcholaAppState();
}

class _PathcholaAppState extends State<PathcholaApp> {
  final StorageService _storage = StorageService();
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  Map<String, dynamic> _data = {};

  bool _english = false;
  bool _dark = false;
  bool _loading = true;
  bool _dailyDialogShown = false;
  bool _handlingBack = false;

  String? _loadError;
  String _userName = '';
  int _selectedIndex = 0;

  static const String _themeKey = 'pathchola_theme_dark_v2';
  static const String _nameKey = 'pathchola_user_name';
  static const String _exitReminderIndexKey =
      'pathchola_exit_reminder_index';

  static const List<Map<String, String>> _exitReminders = [
    {
      'bn': 'আজকের ফরজ সালাতগুলো আদায় করেছেন তো?',
      'en': 'Have you performed today’s obligatory prayers?',
    },
    {
      'bn': 'ফজরের দুই রাকাত সুন্নত আদায় করেছেন তো?',
      'en': 'Have you performed the two Sunnah rakats before Fajr?',
    },
    {
      'bn': 'আজ কুরআন তিলাওয়াত করেছেন তো?',
      'en': 'Have you recited the Quran today?',
    },
    {
      'bn': 'আজ সকালের যিকির ও দোয়া পড়েছেন তো?',
      'en': 'Have you done your morning adhkar and duas?',
    },
    {
      'bn': 'আজ সন্ধ্যার যিকির ও দোয়া পড়েছেন তো?',
      'en': 'Have you done your evening adhkar and duas?',
    },
    {
      'bn': 'আজ আল্লাহর কাছে ক্ষমা চেয়েছ ও ইস্তিগফার করেছেন তো?',
      'en': 'Have you asked Allah for forgiveness and made istighfar?',
    },
    {
      'bn': 'আজ নবী ﷺ-এর ওপর দরুদ পাঠ করেছেন তো?',
      'en': 'Have you sent blessings upon Prophet Muhammad ﷺ today?',
    },
    {
      'bn': 'আজ বিতরের সালাত আদায় করেছেন তো?',
      'en': 'Have you performed Witr prayer today?',
    },
    {
      'bn': 'আজ কোনো উপকারী ইসলামি জ্ঞান অর্জন করেছেন তো?',
      'en': 'Have you learned something beneficial about Islam today?',
    },
    {
      'bn': 'আজ মা-বাবার সঙ্গে সদাচরণ ও দায়িত্ব পালনের চেষ্টা করেছেন তো?',
      'en': 'Have you tried to be kind to your parents and fulfil your duties?',
    },
    {
      'bn': 'আজ মানুষের হক ও আমানত রক্ষা করেছেন তো?',
      'en': 'Have you respected people’s rights and protected trusts?',
    },
    {
      'bn': 'আজ আত্মীয়তার সম্পর্ক বজায় রাখার চেষ্টা করেছেন তো?',
      'en': 'Have you tried to maintain family ties today?',
    },
    {
      'bn': 'আজ কোনো ভালো কাজ বা সদকা করেছেন তো?',
      'en': 'Have you done a good deed or given charity today?',
    },
    {
      'bn': 'আজ মিথ্যা বলা থেকে বেঁচে ছিলেন তো?',
      'en': 'Have you avoided lying today?',
    },
    {
      'bn': 'আজ গীবত ও অপবাদ থেকে বিরত ছিলেন তো?',
      'en': 'Have you avoided backbiting and slander today?',
    },
    {
      'bn': 'আজ প্রতারণা ও ধোঁকা থেকে বেঁচে ছিলেন তো?',
      'en': 'Have you avoided cheating and deception today?',
    },
    {
      'bn': 'আজ রাগের সময় নিজেকে সংযত রাখার চেষ্টা করেছেন তো?',
      'en': 'Have you tried to control your anger today?',
    },
    {
      'bn': 'আজ অহংকার থেকে দূরে থাকার চেষ্টা করেছেন তো?',
      'en': 'Have you tried to stay away from arrogance today?',
    },
    {
      'bn': 'আজ লোক দেখানো আমল থেকে বেঁচে থাকার চেষ্টা করেছেন তো?',
      'en': 'Have you tried to avoid showing off in worship today?',
    },
    {
      'bn': 'আজ হালাল উপার্জন ও সঠিক লেনদেনের বিষয়ে সতর্ক ছিলেন তো?',
      'en': 'Have you been mindful of lawful earnings and honest dealings?',
    },
    {
      'bn': 'আজ নিজের দৃষ্টি ও আচরণ সংযত রেখেছেন তো?',
      'en': 'Have you guarded your gaze and conduct today?',
    },
    {
      'bn': 'আজ অপচয় ও অন্যের অধিকার নষ্ট করা থেকে বিরত ছিলেন তো?',
      'en': 'Have you avoided waste and violating others’ rights?',
    },
    {
      'bn': 'আজ কারও সঙ্গে খারাপ কথা বললে ক্ষমা চাওয়ার কথা ভেবেছেন তো?',
      'en': 'If you spoke harshly to someone, have you considered apologising?',
    },
    {
      'bn': 'আজ কাউকে কষ্ট দিলে তা সংশোধনের চেষ্টা করেছেন তো?',
      'en': 'If you hurt someone, have you tried to make things right?',
    },
    {
      'bn': 'আজ নিয়ত শুদ্ধ রাখার চেষ্টা করেছেন তো?',
      'en': 'Have you tried to keep your intentions sincere today?',
    },
    {
      'bn': 'আজ তাহাজ্জুদ বা অন্য কোনো নফল ইবাদতের সুযোগ হয়েছে তো?',
      'en': 'Have you had an opportunity for Tahajjud or another voluntary act?',
    },
    {
      'bn': 'আজ দুহা/চাশতের সালাত আদায় করেছেন তো, যদি সুযোগ হয়ে থাকে?',
      'en': 'Have you performed Duha prayer if you had the opportunity?',
    },
    {
      'bn': 'আজ নিজের ভুলগুলো নিয়ে আত্মসমালোচনা করেছেন তো?',
      'en': 'Have you reflected on your mistakes today?',
    },
    {
      'bn': 'আজকের আমলগুলোর তালিকা মিলিয়ে দেখেছেন তো?',
      'en': 'Have you reviewed your daily Amal checklist?',
    },
    {
      'bn': 'আগামীকাল আরও ভালো হওয়ার জন্য একটি ছোট লক্ষ্য ঠিক করেছেন তো?',
      'en': 'Have you set one small goal to improve tomorrow?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final results = await Future.wait([
        _storage.loadData(),
        _storage.loadEnglish(),
      ]);

      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString(_nameKey)?.trim() ?? '';

      if (!mounted) return;

      setState(() {
        _data = Map<String, dynamic>.from(
          results[0] as Map<String, dynamic>,
        );
        _english = results[1] as bool;
        _dark = prefs.getBool(_themeKey) ?? false;
        _userName = savedName;
        _loading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _ensureUserName();
        if (mounted) {
          await _scheduleDailyPopup();
        }
      });
    } catch (e, stackTrace) {
      debugPrint('PATHCHOLA LOAD ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _loadError = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _ensureUserName() async {
    if (!mounted || _userName.trim().isNotEmpty) return;

    final controller = TextEditingController();

    try {
      final context = _navigatorKey.currentContext;
      if (context == null) return;

      final name = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            _english ? 'Welcome to Prohori' : 'প্রহরীতে স্বাগতম',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _english
                    ? 'What should we call you?'
                    : 'আপনাকে কি নামে ডাকব?',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: _english ? 'Your name' : 'আপনার নাম',
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.of(dialogContext).pop(value.trim());
                  }
                },
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.of(dialogContext).pop(
                    controller.text.trim(),
                  );
                }
              },
              child: Text(_english ? 'Continue' : 'শুরু করি'),
            ),
          ],
        ),
      );

      final cleanName = name?.trim() ?? '';
      if (cleanName.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, cleanName);

      if (mounted) {
        setState(() => _userName = cleanName);
      }
    } finally {
      controller.dispose();
    }
  }

  Future<void> _scheduleDailyPopup() async {
    if (!mounted || _dailyDialogShown || _loadError != null) return;

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted || _dailyDialogShown) return;

    final context = _navigatorKey.currentContext;
    if (context == null) return;

    _dailyDialogShown = true;
    await _showDailyPopup(context);
  }

  Future<void> _showDailyPopup(BuildContext dialogContext) async {
    if (!mounted) return;

    final item = DailyContentService.forToday();

    await showDialog<void>(
      context: dialogContext,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context) {
        final isQuran = item.isQuran;

        return AlertDialog(
          icon: Icon(
            isQuran
                ? Icons.menu_book_rounded
                : Icons.auto_stories_rounded,
            size: 38,
            color: const Color(0xFFB69A55),
          ),
          title: Text(
            isQuran
                ? (_english ? 'Verse of the day' : 'আজকের কুরআনের আয়াত')
                : (_english ? 'Hadith of the day' : 'আজকের হাদিস'),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    item.arabic,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      height: 1.9,
                      color: Color(0xFFB69A55),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _english ? item.english : item.bangla,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17, height: 1.7),
                ),
                const SizedBox(height: 16),
                Text(
                  item.reference,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF39775A),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(),
              child: Text(_english ? 'Continue' : 'শুরু করি'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeData(Map<String, dynamic> newData) async {
    final previous = _data;
    final updated = Map<String, dynamic>.from(newData);

    setState(() => _data = updated);

    try {
      await _storage.saveData(updated);
    } catch (e, stackTrace) {
      debugPrint('PATHCHOLA SAVE ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() => _data = previous);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _english
                ? 'Could not save data. Please try again.'
                : 'ডেটা সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।',
          ),
        ),
      );

      rethrow;
    }
  }

  Future<void> _toggleLanguage() async {
    final next = !_english;

    setState(() => _english = next);

    try {
      await _storage.saveEnglish(next);
    } catch (e) {
      debugPrint('PATHCHOLA LANGUAGE ERROR: $e');
    }
  }

  Future<void> _toggleTheme() async {
    final next = !_dark;

    setState(() => _dark = next);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, next);
    } catch (e) {
      debugPrint('PATHCHOLA THEME ERROR: $e');
    }
  }

  void _openTodayAmal() {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;

    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => TodayAmalScreen(
          data: Map<String, dynamic>.from(_data),
          english: _english,
          onDataChanged: _changeData,
        ),
      ),
    );
  }

  Future<bool> _confirmExitWithAmalReminder() async {
    if (!mounted) return false;

    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_exitReminderIndexKey) ?? 0;
    final index = savedIndex % _exitReminders.length;
    final reminder = _exitReminders[index];

    final context = _navigatorKey.currentContext;
    if (context == null) return false;

    final shouldExit = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.volunteer_activism_rounded,
          size: 34,
          color: Color(0xFFB69A55),
        ),
        title: Text(
          _english
              ? 'One last reminder, $_userName'
              : 'একটু মনে করিয়ে দিই, $_userName',
        ),
        content: Text(
          '${_english ? reminder['en']! : reminder['bn']!}\n\n'
          '${_english ? 'Would you like to review your deeds before leaving?' : 'বের হওয়ার আগে আমলগুলো একবার দেখে নেবে?'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(_english ? 'Stay' : 'আরও থাকি'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(_english ? 'Exit' : 'বন্ধ করি'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      await prefs.setInt(
        _exitReminderIndexKey,
        (index + 1) % _exitReminders.length,
      );
      return true;
    }

    return false;
  }

  Future<void> _handleBack() async {
    if (_handlingBack || !mounted) return;

    _handlingBack = true;

    try {
      if (_selectedIndex != 0) {
        setState(() => _selectedIndex = 0);
        return;
      }

      final shouldExit = await _confirmExitWithAmalReminder();

      if (shouldExit && mounted) {
        await SystemNavigator.pop();
      }
    } catch (e) {
      debugPrint('PATHCHOLA EXIT ERROR: $e');
    } finally {
      _handlingBack = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF39775A),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF39775A),
      secondary: const Color(0xFFB69A55),
      surface: const Color(0xFFFFFEF8),
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF39775A),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF78B89A),
      secondary: const Color(0xFFD6BE7D),
      surface: const Color(0xFF20352B),
    );

    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'প্রহরী',
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: const Color(0xFFF5F6EF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F6EF),
          foregroundColor: Color(0xFF254B39),
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFEF8),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: Color(0xFFE4E7D9),
              width: 0.7,
            ),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFFFFFEF8),
          indicatorColor: Color(0xFFDDEBDD),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: const Color(0xFF14221B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14221B),
          foregroundColor: Color(0xFFE5EBDD),
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF20352B),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF20352B),
          indicatorColor: Color(0xFF365642),
          elevation: 0,
        ),
      ),
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 18),
              Text(
                _english
                    ? 'Loading Prohori...'
                    : 'প্রহরী চালু হচ্ছে...',
              ),
            ],
          ),
        ),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('পথচলা')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 60,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  _english
                      ? 'Saved data could not be loaded.'
                      : 'সংরক্ষিত ডেটা লোড করা যায়নি।',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  _loadError!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    _english ? 'Try again' : 'আবার চেষ্টা করুন',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screens = [
      HomeScreen(
        data: _data,
        english: _english,
        onGoals: () => setState(() => _selectedIndex = 1),
        onWorship: () => setState(() => _selectedIndex = 2),
        onTodayAmal: _openTodayAmal,
        onRights: () => setState(() => _selectedIndex = 3),
        onReflection: () => setState(() => _selectedIndex = 4),
      ),
      GoalsScreen(
        data: _data,
        english: _english,
        onDataChanged: _changeData,
      ),
      WorshipScreen(
        data: _data,
        english: _english,
        onDataChanged: _changeData,
      ),
      RightsScreen(
        data: _data,
        english: _english,
        onDataChanged: _changeData,
      ),
      ReflectionScreen(
        key: const ValueKey('reflection-screen'),
        data: _data,
        english: _english,
        onDataChanged: _changeData,
      ),
      ReportScreen(
        data: _data,
        english: _english,
      ),
    ];

    final titles = _english
        ? [
            'Home',
            'Goals',
            'Prohori',
            'Rights',
            'Reflection',
            'Report',
          ]
        : [
            'হোম',
            'লক্ষ্য',
            'প্রহরী',
            'দায়িত্ব',
            'আত্মসমালোচনা',
            'রিপোর্ট',
          ];

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titles[_selectedIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: _english ? 'Change language' : 'ভাষা পরিবর্তন',
              onPressed: _toggleLanguage,
              icon: const Icon(Icons.translate),
            ),
            IconButton(
              tooltip: _english ? 'Change theme' : 'থিম পরিবর্তন',
              onPressed: _toggleTheme,
              icon: Icon(_dark ? Icons.light_mode : Icons.dark_mode),
            ),
            const SizedBox(width: 5),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: _english ? 'Home' : 'হোম',
            ),
            NavigationDestination(
              icon: const Icon(Icons.flag_outlined),
              selectedIcon: const Icon(Icons.flag),
              label: _english ? 'Goals' : 'লক্ষ্য',
            ),
            NavigationDestination(
              icon: const Icon(Icons.mosque_outlined),
              selectedIcon: const Icon(Icons.mosque),
              label: _english ? 'Prohori' : 'প্রহরী',
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border),
              selectedIcon: const Icon(Icons.favorite),
              label: _english ? 'Rights' : 'দায়িত্ব',
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book),
              label: _english ? 'Reflect' : 'ভাবনা',
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: _english ? 'Report' : 'রিপোর্ট',
            ),
          ],
        ),
      ),
    );
  }
}
