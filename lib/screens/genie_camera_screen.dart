import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/openai_vision_service.dart';
import '../widgets/neon_button.dart';
import 'analysis_result_screen.dart';


class GenieCameraScreen extends StatefulWidget {
  const GenieCameraScreen({super.key});

  @override
  State<GenieCameraScreen> createState() => _GenieCameraScreenState();
}

class _GenieCameraScreenState extends State<GenieCameraScreen>
    with TickerProviderStateMixin {
  final _picker = ImagePicker();
  final _service = OpenAiVisionService();
  final List<Uint8List> _images = [];
  bool _analyzing = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.93, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 4) return;
    try {
      final xFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (xFile == null) return;
      final bytes = await xFile.readAsBytes();
      setState(() => _images.add(bytes));
    } catch (e) {
      _showError('Could not load image. Try again.');
    }
  }

  void _removeImage(int index) =>
      setState(() => _images.removeAt(index));

  Future<void> _analyze() async {
    if (_images.isEmpty) return;
    setState(() => _analyzing = true);
    final result = await _service.analyzeImages(_images);
    if (!mounted) return;
    setState(() => _analyzing = false);
    if (result.hasError) {
      _showError(result.error!);
      return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => AnalysisResultScreen(
          result: result,
          allImages: _images,
        ),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('🧞 $message',
          style: const TextStyle(color: Colors.cyan)),
      backgroundColor: const Color(0xFF0d0225),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.cyan),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.8,
            colors: [Color(0xFF2d0060), Color(0xFF0d0030)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(t),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    children: [
                      _buildGeniePrompt(t),
                      const SizedBox(height: 16),
                      _buildImageGrid(),
                      const SizedBox(height: 16),
                      _buildPickerButtons(t),
                      const SizedBox(height: 16),
                      _buildAnalyzeButton(t),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String Function(String) t) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1a0040),
        border: const Border(
            bottom: BorderSide(color: Colors.cyan, width: 1.5)),
        boxShadow: [BoxShadow(
          color: Colors.cyan.withValues(alpha: 0.2),
          blurRadius: 14,
          offset: const Offset(0, 3),
        )],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.cyan),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Colors.cyan, size: 15),
                  SizedBox(width: 5),
                  Text('Back',
                      style:
                          TextStyle(color: Colors.cyan, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '🧞 ${t('genie')}',
              style: GoogleFonts.cinzel(
                fontSize: 20,
                color: Colors.cyan,
                letterSpacing: 2,
                shadows: const [
                  Shadow(color: Colors.cyan, blurRadius: 10)
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFFFD700)),
              boxShadow: [BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                blurRadius: 8,
              )],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🪙', style: TextStyle(fontSize: 12)),
                SizedBox(width: 3),
                Text('100', style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeniePrompt(String Function(String) t) {
    return Column(
      children: [
        const Text('🧞', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          _analyzing ? t('analyzing') : t('show_spirits'),
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            color: const Color(0xFFd4af37),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        Text(
          t('add_photos'),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid() {
    // Fixed height 140px — always compact regardless of screen size
    const slotHeight = 140.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final slotWidth = (constraints.maxWidth - 12) / 2;
        return Column(
          children: [
            Row(
              children: [
                _buildSlot(0, slotWidth, slotHeight),
                const SizedBox(width: 12),
                _buildSlot(1, slotWidth, slotHeight),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildSlot(2, slotWidth, slotHeight),
                const SizedBox(width: 12),
                _buildSlot(3, slotWidth, slotHeight),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlot(int i, double width, double height) {
    final hasImage = i < _images.length;
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasImage
                ? Colors.cyan.withValues(alpha: 0.8)
                : Colors.cyan.withValues(alpha: 0.25),
            width: hasImage ? 2 : 1,
          ),
          color: hasImage
              ? Colors.cyan.withValues(alpha: 0.05)
              : const Color(0xFF1a0040).withValues(alpha: 0.5),
          boxShadow: hasImage
              ? [BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.2),
                  blurRadius: 10)]
              : [],
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.memory(_images[i], fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => _removeImage(i),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.75),
                          border: Border.all(
                              color: Colors.cyan, width: 1),
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.cyan, size: 12),
                      ),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.cyan.withValues(alpha: 0.4),
                      size: 28,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Slot ${i + 1}',
                      style: TextStyle(
                        color: Colors.cyan.withValues(alpha: 0.35),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPickerButtons(String Function(String) t) {
    final canAdd = _images.length < 4 && !_analyzing;
    return Row(
      children: [
        Expanded(
          child: NeonButton(
            label: t('take_photo'),
            onTap: kIsWeb || !canAdd
                ? null
                : () => _pickImage(ImageSource.camera),
            color: Colors.cyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NeonButton(
            label: t('upload_photo'),
            onTap: canAdd ? () => _pickImage(ImageSource.gallery) : null,
            color: const Color(0xFFCC88FF),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton(String Function(String) t) {
    if (_analyzing) {
      return AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, __) => Transform.scale(
          scale: _pulseAnim.value,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.8)),
              color: const Color(0xFFFFD700).withValues(alpha: 0.1),
              boxShadow: [BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                blurRadius: 20,
              )],
            ),
            child: Text(
              t('analyzing'),
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFFFD700),
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (_images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              t('costs_tokens'),
              style: TextStyle(
                color: const Color(0xFFFFD700).withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ),
        NeonButton(
          label: t('reveal_button'),
          onTap: _images.isNotEmpty ? _analyze : null,
          color: const Color(0xFFFFD700),
          fullWidth: true,
          fontSize: 14,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ],
    );
  }
}