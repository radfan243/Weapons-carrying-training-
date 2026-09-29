import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const TrainingApp());

class Lesson {
  final String title, subtitle, detail, icon;
  final int motion;
  const Lesson(this.title, this.subtitle, this.detail, this.icon, this.motion);
}

const lessons = <Lesson>[
  Lesson('السلامة أولاً', '01', 'ابدأ في مساحة تدريب آمنة وتحت إشراف مدرب. هذه الوحدة لا تتضمن استخدام السلاح ضد أشخاص.', '🛡️', 0),
  Lesson('وضع الوقوف', '02', 'تدريب على التوازن والوقفة الطبيعية مع تثبيت القدمين والنظر إلى مسار الحركة. لا يوجد استهداف أو اشتباك.', '🧍', 1),
  Lesson('المشي', '03', 'المشي المنظم للأمام مع خطوات قصيرة ومتوازنة ومراقبة العوائق في مسار التدريب.', '🚶', 2),
  Lesson('الجري', '04', 'الجري التدريبي الخفيف مع المحافظة على التوازن والتنفس ومسار واضح وخالٍ من العوائق.', '🏃', 3),
  Lesson('تغيير الاتجاه', '05', 'التوقف الآمن ثم تغيير الاتجاه يمينًا أو يسارًا والعودة إلى المسار المحدد في ميدان التدريب.', '↪️', 4),
  Lesson('الانخفاض الآمن', '06', 'الانتقال من الوقوف إلى وضع منخفض لتجاوز عائق أو حماية التوازن، ثم العودة للوقوف بهدوء.', '⬇️', 5),
  Lesson('الانبطاح التدريبي', '07', 'تدريب حركي عام على الانتقال إلى الأرض ثم النهوض بأمان. استخدم أرضية مناسبة وتحت إشراف مدرب.', '🧎', 6),
  Lesson('الزحف', '08', 'زحف تدريبي منخفض لتجاوز مساحة قصيرة وآمنة، من دون ربطه بالاقتراب من أشخاص أو أهداف.', '🐾', 7),
  Lesson('التراجع', '09', 'التراجع المنظم بعيدًا عن مصدر خطر افتراضي مع المحافظة على التوازن وعدم الرجوع إلى عائق.', '↩️', 8),
  Lesson('التقدم', '10', 'التقدم داخل ممر تدريبي محدد للوصول إلى نقطة آمنة أو نقطة تجمع. لا توجد أهداف بشرية.', '➡️', 9),
  Lesson('الحركة الجانبية', '11', 'التحرك يمينًا ويسارًا حول علامات أرضية مع إبقاء مسافة آمنة من العوائق والمتدربين.', '↔️', 10),
  Lesson('تجاوز عائق', '12', 'المرور حول عائق تدريبي أو تجاوزه بطريقة آمنة مع فحص المسار قبل الحركة.', '🚧', 11),
  Lesson('الانسحاب والتجمع', '13', 'عند وجود خطر: الابتعاد عن المكان، الوصول إلى نقطة تجمع آمنة، ثم طلب المساعدة وإبلاغ المدرب.', '🚨', 12),
];

class TrainingApp extends StatelessWidget {
  const TrainingApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'تدريبات حمل السلاح',
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color(0xFF080B10),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB9FF3D),
            brightness: Brightness.dark,
          ),
        ),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  int index = 0;
  bool playing = true;
  int completed = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void select(int i) {
    setState(() {
      index = i;
      playing = true;
      controller.repeat();
    });
  }

  void markComplete() {
    setState(() {
      completed = math.max(completed, index + 1);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تسجيل الحركة ${index + 1} ✓')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = lessons[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تدريبات حمل السلاح',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () => showAboutDialog(
                context: context,
                applicationName: 'تدريبات حمل السلاح',
                children: const [
                  Text(
                    'نسخة تدريبية للحركة والسلامة الميدانية العامة. '
                    'لا تشرح الاستهداف أو إطلاق النار أو مهاجمة الأشخاص.',
                  ),
                ],
              ),
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'الحركات الميدانية • خطوة بخطوة',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '$completed/${lessons.length}',
                      style: const TextStyle(
                        color: Color(0xFFB9FF3D),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _lessonCard(l, index),
                  ),
                ),
              ),
              _controls(),
              SizedBox(
                height: 82,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  scrollDirection: Axis.horizontal,
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (c, i) => GestureDetector(
                    onTap: () => select(i),
                    child: Container(
                      width: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: i == index
                            ? const Color(0xFFB9FF3D)
                            : const Color(0xFF151A22),
                        border: Border.all(
                          color: i == index
                              ? Colors.transparent
                              : Colors.white12,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lessons[i].icon,
                              style: const TextStyle(fontSize: 21)),
                          Text(
                            lessons[i].subtitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  i == index ? Colors.black : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lessonCard(Lesson l, int key) => Container(
        key: ValueKey(key),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF151B24), Color(0xFF0D1118)],
          ),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFB9FF3D),
                    child: Text(
                      l.subtitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l.title,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'الحركة ${l.subtitle}',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  Text(l.icon, style: const TextStyle(fontSize: 32)),
                ],
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) => CustomPaint(
                  painter: TrainingPainter(
                    progress: controller.value,
                    lesson: l.motion,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  l.detail,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _controls() => Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    playing = !playing;
                    if (playing) {
                      controller.repeat();
                    } else {
                      controller.stop();
                    }
                  });
                },
                icon: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(playing ? 'إيقاف الحركة' : 'تشغيل الحركة'),
              ),
            ),
            const SizedBox(width: 7),
            IconButton.filled(
              tooltip: 'إعادة',
              onPressed: () {
                controller.reset();
                if (playing) controller.repeat();
              },
              icon: const Icon(Icons.replay_rounded),
            ),
            const SizedBox(width: 4),
            IconButton.filled(
              tooltip: 'تمت الحركة',
              onPressed: markComplete,
              icon: const Icon(Icons.check_rounded),
            ),
            const SizedBox(width: 4),
            IconButton.filled(
              tooltip: 'التالي',
              onPressed: index < lessons.length - 1
                  ? () => select(index + 1)
                  : null,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ],
        ),
      );
}

class TrainingPainter extends CustomPainter {
  final double progress;
  final int lesson;

  TrainingPainter({required this.progress, required this.lesson});

  double wave(double speed) => math.sin(progress * math.pi * 2 * speed);

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final floor = s.height * .83;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFB9FF3D);
    final soft = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white12;
    final marker = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFB9FF3D);

    canvas.drawLine(Offset(18, floor), Offset(s.width - 18, floor), soft);
    for (int i = -2; i <= 2; i++) {
      canvas.drawCircle(Offset(cx + i * 55, floor), 5, marker);
    }

    double headY = floor - 220;
    double hipY = floor - 105;
    double shoulderY = floor - 175;
    double centerX = cx;

    if (lesson == 2 || lesson == 3 || lesson == 9) {
      centerX += wave(1) * 55;
    } else if (lesson == 10) {
      centerX += wave(1) * 70;
    } else if (lesson == 8) {
      centerX -= progress * 90;
    } else if (lesson == 4) {
      centerX += wave(1) * 18;
    }

    if (lesson == 5) {
      hipY += 42;
      shoulderY += 25;
      headY += 25;
    }

    if (lesson == 6 || lesson == 7) {
      headY = floor - 85;
      shoulderY = floor - 65;
      hipY = floor - 45;
    }

    final head = Offset(centerX, headY);
    canvas.drawCircle(head, lesson >= 6 && lesson <= 7 ? 22 : 28, p);

    if (lesson == 6 || lesson == 7) {
      final body = Offset(centerX + 48, shoulderY);
      canvas.drawLine(Offset(centerX + 10, shoulderY), body, p);
      canvas.drawLine(body, Offset(centerX + 95, hipY), p);
      final crawl = wave(1) * 22;
      canvas.drawLine(
        Offset(centerX + 45, shoulderY),
        Offset(centerX + 20, floor - 25 + crawl),
        p,
      );
      canvas.drawLine(
        Offset(centerX + 85, hipY),
        Offset(centerX + 115, floor - 18 - crawl),
        p,
      );
      canvas.drawLine(
        Offset(centerX + 70, hipY),
        Offset(centerX + 42, floor - 10 + crawl),
        p,
      );
    } else {
      final shoulder = Offset(centerX, shoulderY);
      final hip = Offset(centerX, hipY);
      canvas.drawLine(
        Offset(shoulder.dx - 42, shoulder.dy),
        Offset(shoulder.dx + 42, shoulder.dy),
        p,
      );
      canvas.drawLine(shoulder, hip, p);

      double legSwing = 0;
      if (lesson == 2 || lesson == 3 || lesson == 9) {
        legSwing = wave(1) * 22;
      } else if (lesson == 10) {
        legSwing = wave(1) * 10;
      }

      canvas.drawLine(
        hip,
        Offset(hip.dx - 30 + legSwing, hip.dy + 65),
        p,
      );
      canvas.drawLine(
        hip,
        Offset(hip.dx + 30 - legSwing, hip.dy + 65),
        p,
      );

      final armSwing = (lesson == 2 || lesson == 3 || lesson == 9)
          ? wave(1) * 22
          : wave(1) * 8;

      canvas.drawLine(
        Offset(shoulder.dx - 35, shoulder.dy),
        Offset(
          shoulder.dx - 65 + armSwing,
          shoulder.dy + 55 - armSwing * .4,
        ),
        p,
      );
      canvas.drawLine(
        Offset(shoulder.dx + 35, shoulder.dy),
        Offset(
          shoulder.dx + 65 - armSwing,
          shoulder.dy + 55 + armSwing * .4,
        ),
        p,
      );

      if (lesson == 4) {
        canvas.drawArc(
          Rect.fromCircle(center: hip, radius: 58),
          -1.0,
          2.0,
          false,
          soft,
        );
      }

      if (lesson == 11) {
        final obstacle = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..color = Colors.white24;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 48, floor - 85, 96, 65),
            const Radius.circular(12),
          ),
          obstacle,
        );
      }
    }

    if (lesson == 12) {
      final safe = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFFB9FF3D);
      canvas.drawCircle(Offset(cx, floor - 95), 58, safe);
      canvas.drawLine(
        Offset(cx - 28, floor - 95),
        Offset(cx + 28, floor - 95),
        safe,
      );
      canvas.drawLine(
        Offset(cx, floor - 123),
        Offset(cx, floor - 67),
        safe,
      );
    }

    final label = TextPainter(
      text: TextSpan(
        text: lesson == 0
            ? 'تدريب آمن • نموذج غير عامل'
            : 'مسار تدريب • حركة عامة',
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    label.paint(canvas, Offset(cx - label.width / 2, floor - 28));
  }

  @override
  bool shouldRepaint(covariant TrainingPainter old) =>
      old.progress != progress || old.lesson != lesson;
}
