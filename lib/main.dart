import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const BekamApp());

const markets = [
  'سوق غذائية', 'سوق مواشي', 'سوق تنظيف', 'سوق ملابس',
  'سوق عطار', 'سوق هواتف', 'سوق أحذية', 'سوق بقوليات',
  'سوق صيدلية', 'سوق ذهب', 'سوق منزلية', 'سوق ألعاب',
  'سوق كهربائية', 'جملة',
];

const marketEnglish = [
  'Food Market', 'Livestock Market', 'Cleaning Market', 'Clothing Market',
  'Herbal Market', 'Phones Market', 'Shoes Market', 'Legumes Market',
  'Pharmacy', 'Gold Market', 'Home Market', 'Toys Market',
  'Electrical Market', 'Wholesale',
];

class BekamApp extends StatefulWidget {
  const BekamApp({super.key});
  @override
  State<BekamApp> createState() => _BekamAppState();
}

class _BekamAppState extends State<BekamApp> {
  String? language;
  bool dark = false;
  double fontScale = 1;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      language = p.getString('language');
      dark = p.getBool('dark') ?? false;
      fontScale = p.getDouble('fontScale') ?? 1;
      loaded = true;
    });
  }

  Future<void> _save(String key, Object value) async {
    final p = await SharedPreferences.getInstance();
    if (value is String) await p.setString(key, value);
    if (value is bool) await p.setBool(key, value);
    if (value is double) await p.setDouble(key, value);
  }

  void _setLanguage(String value) {
    setState(() => language = value);
    _save('language', value);
  }

  void _setDark(bool value) {
    setState(() => dark = value);
    _save('dark', value);
  }

  void _setFont(double value) {
    setState(() => fontScale = value);
    _save('fontScale', value);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language != 'en';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بكم؟',
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1687F8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F8FC),
          foregroundColor: Color(0xFF172B4D),
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1687F8),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101B2A),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF172638),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      home: !loaded
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : language == null
              ? LanguageScreen(onChoose: _setLanguage)
              : Directionality(
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  child: AppShell(
                    language: language!,
                    dark: dark,
                    fontScale: fontScale,
                    onLanguage: _setLanguage,
                    onDark: _setDark,
                    onFont: _setFont,
                  ),
                ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  final ValueChanged<String> onChoose;
  const LanguageScreen({super.key, required this.onChoose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071B35), Color(0xFF087CEB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront_rounded, color: Colors.white, size: 76),
                  const SizedBox(height: 16),
                  const Text(
                    'HELLO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'المبرمج احمد امليمدي',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 56),
                  const Text(
                    'اختر اللغة / Choose language',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => onChoose('ar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF086DD0),
                        padding: const EdgeInsets.symmetric(vertical: 17),
                      ),
                      child: const Text('العربية', style: TextStyle(fontSize: 17)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => onChoose('en'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                        padding: const EdgeInsets.symmetric(vertical: 17),
                      ),
                      child: const Text('ENGLISH', style: TextStyle(fontSize: 17)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String market;
  final String name;
  final String size;
  final double price;
  final double? wholesale;
  final String imagePath;
  final String hash;

  Product({
    required this.id,
    required this.market,
    required this.name,
    required this.size,
    required this.price,
    required this.wholesale,
    required this.imagePath,
    required this.hash,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'market': market, 'name': name, 'size': size,
    'price': price, 'wholesale': wholesale, 'imagePath': imagePath, 'hash': hash,
  };

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'], market: j['market'], name: j['name'], size: j['size'],
    price: (j['price'] as num).toDouble(),
    wholesale: j['wholesale'] == null ? null : (j['wholesale'] as num).toDouble(),
    imagePath: j['imagePath'], hash: j['hash'] ?? '',
  );
}

class AppShell extends StatefulWidget {
  final String language;
  final bool dark;
  final double fontScale;
  final ValueChanged<String> onLanguage;
  final ValueChanged<bool> onDark;
  final ValueChanged<double> onFont;

  const AppShell({
    super.key, required this.language, required this.dark,
    required this.fontScale, required this.onLanguage,
    required this.onDark, required this.onFont,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;
  String? selectedMarket;
  List<Product> products = [];
  bool busy = false;
  final picker = ImagePicker();

  bool get ar => widget.language == 'ar';
  String tr(String a, String e) => ar ? a : e;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('products');
    if (raw != null) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (mounted) setState(() => products = list);
      } catch (_) {}
    }
  }

  Future<void> _saveProducts() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('products', jsonEncode(products.map((e) => e.toJson()).toList()));
  }

  Future<String> _privateCopy(XFile file) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/bekam_products');
    if (!await folder.exists()) await folder.create(recursive: true);
    final ext = file.path.contains('.') ? file.path.split('.').last : 'jpg';
    final destination = '${folder.path}/${DateTime.now().microsecondsSinceEpoch}.$ext';
    return (await File(file.path).copy(destination)).path;
  }

  Future<String> _makeHash(String path) async {
    final bytes = await File(path).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return '';
    final small = img.copyResize(decoded, width: 8, height: 8);
    final gray = img.grayscale(small);
    int total = 0;
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        total += gray.getPixel(x, y).r.toInt();
      }
    }
    final average = total / 64;
    final out = StringBuffer();
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        out.write(gray.getPixel(x, y).r >= average ? '1' : '0');
      }
    }
    return out.toString();
  }

  int _distance(String a, String b) {
    if (a.length != 64 || b.length != 64) return 64;
    int count = 0;
    for (int i = 0; i < 64; i++) {
      if (a[i] != b[i]) count++;
    }
    return count;
  }

  Future<void> _addProduct() async {
    if (selectedMarket == null) {
      _snack(tr('اختر سوقاً أولاً', 'Choose a market first'));
      return;
    }
    final source = await _chooseImageSource();
    if (source == null) return;
    final file = await picker.pickImage(
      source: source,
      imageQuality: 88,
      maxWidth: 1600,
    );
    if (file == null) return;
    final path = await _privateCopy(file);
    final hash = await _makeHash(path);
    if (!mounted) return;
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final wholesaleController = TextEditingController();
    String size = 'بدون';
    bool addWholesale = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text(tr('بيانات المنتج', 'Product details')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(File(path), height: 130, width: 180, fit: BoxFit.cover),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: tr('اسم المنتج', 'Product name'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: size,
                  decoration: InputDecoration(
                    labelText: tr('حجم المنتج', 'Product size'),
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'كبير', child: Text(tr('كبير', 'Large'))),
                    DropdownMenuItem(value: 'متوسط', child: Text(tr('متوسط', 'Medium'))),
                    DropdownMenuItem(value: 'صغير', child: Text(tr('صغير', 'Small'))),
                    DropdownMenuItem(value: 'بدون', child: Text(tr('بدون', 'None'))),
                  ],
                  onChanged: (v) => setDialog(() => size = v ?? 'بدون'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: tr('السعر', 'Price'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: addWholesale,
                  title: Text(tr('إضافة سعر الجملة؟', 'Add wholesale price?')),
                  onChanged: (v) => setDialog(() => addWholesale = v ?? false),
                ),
                if (addWholesale)
                  TextField(
                    controller: wholesaleController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: tr('سعر الجملة', 'Wholesale price'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(tr('إلغاء', 'Cancel'))),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    double.tryParse(priceController.text.trim()) == null ||
                    (addWholesale && double.tryParse(wholesaleController.text.trim()) == null)) {
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              child: Text(tr('حفظ المنتج', 'Save product')),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final product = Product(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        market: selectedMarket!,
        name: nameController.text.trim(),
        size: size,
        price: double.parse(priceController.text.trim()),
        wholesale: addWholesale ? double.parse(wholesaleController.text.trim()) : null,
        imagePath: path,
        hash: hash,
      );
      setState(() => products.insert(0, product));
      await _saveProducts();
      _snack(tr('تمت إضافة المنتج بنجاح', 'Product added successfully'));
    } else {
      // Keep no unused photo after cancelling the form.
      try { await File(path).delete(); } catch (_) {}
    }
    nameController.dispose();
    priceController.dispose();
    wholesaleController.dispose();
  }

  Future<ImageSource?> _chooseImageSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(tr('تصوير منتج', 'Take a photo')),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(tr('استرداد منتج من الملفات', 'Choose from files')),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _scanProduct() async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final file = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 88,
        maxWidth: 1600,
      );
      if (file == null) return;
      final tempPath = file.path;
      final hash = await _makeHash(tempPath);
      final candidates = products.where((p) =>
        (selectedMarket == null || p.market == selectedMarket) && p.hash.isNotEmpty
      ).toList();

      Product? best;
      int bestDistance = 65;
      for (final p in candidates) {
        final d = _distance(hash, p.hash);
        if (d < bestDistance) {
          bestDistance = d;
          best = p;
        }
      }
      if (!mounted) return;
      if (best != null && bestDistance <= 12) {
        _showProduct(best);
      } else {
        _snack(tr('هذا المنتج غير مُضاف', 'This product has not been added'));
      }
    } catch (e) {
      _snack(tr('تعذر فتح الكاميرا أو قراءة الصورة', 'Could not use the camera or read the image'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _showProduct(Product p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(p.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (File(p.imagePath).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(File(p.imagePath), height: 150, fit: BoxFit.cover),
              ),
            const SizedBox(height: 14),
            _infoRow(tr('السعر', 'Price'), '${p.price}'),
            _infoRow(tr('الحجم', 'Size'), p.size),
            if (p.wholesale != null) _infoRow(tr('سعر الجملة', 'Wholesale'), '${p.wholesale}'),
          ],
        ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: Text(tr('إغلاق', 'Close'))),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
    ),
  );

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openHelp() async {
    final uri = Uri.parse('https://wa.me/218934274024');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _snack(tr('تعذر فتح واتساب', 'Could not open WhatsApp'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.fontScale;
    final pages = [
      _homePage(scale),
      _cameraPage(scale),
      _settingsPage(scale),
    ];
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(scale),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(tr('بكم؟', 'Bekam'), style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(
                tr('المبرمج احمد امليمدي', 'Programmer: Ahmed Almilaidi'),
                style: TextStyle(fontSize: 10 * scale, color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
          actions: [
            if (selectedMarket != null)
              IconButton(
                tooltip: tr('العودة للأسواق', 'Back to markets'),
                onPressed: () => setState(() => selectedMarket = null),
                icon: const Icon(Icons.grid_view_rounded),
              ),
          ],
        ),
        body: IndexedStack(index: tab, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr('الرئيسية', 'Home')),
            NavigationDestination(icon: const Icon(Icons.camera_alt_outlined), selectedIcon: const Icon(Icons.camera_alt), label: tr('كاميرا', 'Camera')),
            NavigationDestination(icon: const Icon(Icons.settings_outlined), selectedIcon: const Icon(Icons.settings), label: tr('الإعدادات', 'Settings')),
          ],
        ),
      ),
    );
  }

  Widget _homePage(double scale) {
    if (selectedMarket != null) {
      final list = products.where((p) => p.market == selectedMarket).toList();
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                Expanded(child: Text(selectedMarket!, style: TextStyle(fontSize: 20 * scale, fontWeight: FontWeight.bold))),
                FilledButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: Text(tr('إضافة منتج', 'Add product')),
                ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? _emptyState(tr('لا توجد منتجات في هذا السوق بعد', 'No products in this market yet'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final p = list[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () => _showProduct(p),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: File(p.imagePath).existsSync()
                                ? Image.file(File(p.imagePath), width: 58, height: 58, fit: BoxFit.cover)
                                : const Icon(Icons.inventory_2_outlined),
                          ),
                          title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${tr('الحجم', 'Size')}: ${p.size}'),
                          trailing: Text('${p.price}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(colors: [Color(0xFF087CEB), Color(0xFF064B9B)]),
          ),
          child: Row(
            children: [
              const Icon(Icons.storefront_rounded, color: Colors.white, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('مرحباً بك في بكم؟', 'Welcome to Bekam'), style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(tr('اختر السوق لعرض منتجاته وإضافة الأسعار', 'Choose a market to view products and add prices'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(tr('قائمة الأسواق', 'Markets'), style: TextStyle(fontSize: 20 * scale, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: markets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.35,
          ),
          itemBuilder: (context, i) {
            final name = ar ? markets[i] : marketEnglish[i];
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => setState(() => selectedMarket = markets[i]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(_marketIcon(i), size: 18, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), maxLines: 2)),
                      const Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _marketIcon(int i) {
    const icons = [
      Icons.restaurant, Icons.pets, Icons.cleaning_services, Icons.checkroom,
      Icons.spa, Icons.phone_iphone, Icons.shopping_bag, Icons.grain,
      Icons.local_pharmacy, Icons.diamond, Icons.chair, Icons.toys,
      Icons.electrical_services, Icons.inventory,
    ];
    return icons[i];
  }

  Widget _cameraPage(double scale) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 138, height: 138,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.document_scanner_outlined, size: 72, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(tr('ابحث عن سعر منتج', 'Find a product price'), style: TextStyle(fontSize: 23 * scale, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              tr('وجّه الكاميرا نحو المنتج لمقارنة صورته بالمنتجات المسجلة في التطبيق.', 'Point the camera at a product to compare it with saved products.'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            if (selectedMarket == null)
              Text(tr('يمكنك اختيار سوق من الرئيسية لتحديد نطاق البحث.', 'Choose a market on Home to limit the search.'),
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: busy ? null : _scanProduct,
                icon: busy
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.camera_alt),
                label: Text(busy ? tr('جارٍ الفحص...', 'Scanning...') : tr('صوّر المنتج', 'Scan product')),
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsPage(double scale) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(tr('الإعدادات', 'Settings'), style: TextStyle(fontSize: 22 * scale, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(tr('لغة التطبيق', 'App language')),
                subtitle: Text(ar ? 'العربية' : 'English'),
                trailing: DropdownButton<String>(
                  value: widget.language,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (v) { if (v != null) widget.onLanguage(v); },
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: Text(tr('الوضع الداكن', 'Dark mode')),
                subtitle: Text(tr('إيقافه يعرض الوضع الفاتح الأزرق', 'Turn off for the light blue theme')),
                value: widget.dark,
                onChanged: widget.onDark,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: Text(tr('حجم الخط', 'Font size')),
                subtitle: Slider(
                  value: widget.fontScale,
                  min: 0.85, max: 1.25, divisions: 4,
                  label: _fontLabel(widget.fontScale),
                  onChanged: widget.onFont,
                ),
                trailing: Text(_fontLabel(widget.fontScale)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(tr('المساعدة والتواصل', 'Help and support')),
                subtitle: const Text('+218 93 427 4024'),
                trailing: const Icon(Icons.open_in_new),
                onTap: _openHelp,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Text(
            tr('المبرمج احمد امليمدي', 'Programmer: Ahmed Almilaidi'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11),
          ),
        ),
      ],
    );
  }

  String _fontLabel(double v) {
    if (v < 0.95) return tr('صغير', 'Small');
    if (v > 1.15) return tr('كبير', 'Large');
    return tr('متوسط', 'Medium');
  }

  Widget _emptyState(String text) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 54, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    ),
  );
}