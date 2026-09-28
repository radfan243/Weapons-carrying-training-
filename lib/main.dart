import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const TrainingApp());

class Lesson {
  final String title, subtitle, detail, icon;
  const Lesson(this.title, this.subtitle, this.detail, this.icon);
}

const lessons = <Lesson>[
  Lesson('السلامة أولاً','01','ابدأ دائمًا في بيئة تدريب آمنة وتحت إشراف مدرب. اعتبر أداة التدريب غير جاهزة حتى يتم التحقق من حالتها.','🛡️'),
  Lesson('فحص المكان','02','تأكد من خلو مساحة التدريب من الأشخاص والعوائق، وحدد مسار الحركة الآمن قبل البدء.','👁️'),
  Lesson('التعرّف على أداة التدريب','03','تعلّم أسماء الأجزاء بشكل تعريفي فقط، واستخدم نموذجًا تدريبيًا غير عامل عند التعلم.','🔎'),
  Lesson('الحمل الآمن','04','توضح الرسوم وضعية حمل غير قتالية مع إبقاء الأداة في اتجاه آمن بعيدًا عن الأشخاص.','🎒'),
  Lesson('الانتقال لوضع الراحة','05','تحرك ببطء وابقِ وضعية الجسم مستقرة، ثم أعد الأداة إلى وضع الراحة المخصص للتدريب.','🧍'),
  Lesson('العودة إلى التخزين','06','عند انتهاء الدرس، أعد أداة التدريب إلى مكان التخزين المخصص واتبع تعليمات المدرب.','📦'),
  Lesson('موقف خطر غير قتالي','07','في حالة خطر، الأولوية للابتعاد وطلب المساعدة وإبلاغ المدرب أو الجهات المختصة، وليس المواجهة.','🚨'),
];

class TrainingApp extends StatelessWidget {
  const TrainingApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'تدريبات حمل السلاح',
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF080B10),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB9FF3D), brightness: Brightness.dark),
    ),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  int index = 0;
  bool playing = true;

  @override
  void dispose(){ controller.dispose(); super.dispose(); }

  void select(int i){ setState((){ index=i; playing=true; controller.repeat(); }); }

  @override
  Widget build(BuildContext context){
    final l=lessons[index];
    return Scaffold(
      appBar: AppBar(
        title: const Text('تدريبات حمل السلاح', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions:[IconButton(onPressed:(){showAboutDialog(context:context,applicationName:'تدريبات حمل السلاح',children:[const Text('تطبيق تعليمي للسلامة والحمل غير القتالي. لا يشرح الاستهداف أو إطلاق النار أو التكتيكات القتالية.')]);},icon:const Icon(Icons.info_outline))]
      ),
      body: SafeArea(
        child: Column(children:[
          const Padding(padding: EdgeInsets.symmetric(horizontal:16),child: Align(alignment:Alignment.centerRight,child:Text('التدريب الآمن • خطوة بخطوة',style:TextStyle(color:Colors.white54)))),
          const SizedBox(height:10),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:14),
            child: AnimatedSwitcher(duration: const Duration(milliseconds:350),child: _lessonCard(l,index)),
          )),
          _controls(),
          SizedBox(height:88, child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal:14,vertical:10),
            scrollDirection: Axis.horizontal, itemCount: lessons.length,
            separatorBuilder:(_,__)=>const SizedBox(width:8),
            itemBuilder:(c,i)=>GestureDetector(onTap:()=>select(i),child:Container(
              width:64, decoration:BoxDecoration(
                borderRadius:BorderRadius.circular(16),
                color:i==index?const Color(0xFFB9FF3D):const Color(0xFF151A22),
                border:Border.all(color:i==index?Colors.transparent:Colors.white12),
              ),
              child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
                Text(lessons[i].icon,style:const TextStyle(fontSize:22)),
                Text(lessons[i].subtitle,style:TextStyle(fontWeight:FontWeight.bold,color:i==index?Colors.black:Colors.white70))
              ])
            ))
          ))
        ])
      ),
    );
  }

  Widget _lessonCard(Lesson l,int key)=>Container(
    key:ValueKey(key),
    decoration:BoxDecoration(
      borderRadius:BorderRadius.circular(28),
      gradient:const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xFF151B24),Color(0xFF0D1118)]),
      border:Border.all(color:Colors.white10),
    ),
    child:Column(children:[
      Padding(padding:const EdgeInsets.fromLTRB(18,18,18,8),child:Row(children:[
        CircleAvatar(radius:25,backgroundColor:const Color(0xFFB9FF3D),child:Text(l.subtitle,style:const TextStyle(color:Colors.black,fontWeight:FontWeight.w900))),
        const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
          Text(l.title,textAlign:TextAlign.right,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900)),
          Text('الخطوة \${l.subtitle}',style:const TextStyle(color:Colors.white54))
        ])),Text(l.icon,style:const TextStyle(fontSize:32))
      ])),
      Expanded(child: AnimatedBuilder(animation:controller,builder:(context,child)=>CustomPaint(
        painter: TrainingPainter(progress:controller.value,lesson:index),
        child: const SizedBox.expand(),
      ))),
      Padding(padding:const EdgeInsets.fromLTRB(18,8,18,20),child:Container(
        padding:const EdgeInsets.all(16),
        decoration:BoxDecoration(color:Colors.black26,borderRadius:BorderRadius.circular(18)),
        child:Text(l.detail,textAlign:TextAlign.right,style:const TextStyle(fontSize:15,height:1.5,color:Colors.white70))
      ))
    ])
  );

  Widget _controls()=>Padding(
    padding:const EdgeInsets.fromLTRB(14,4,14,0),
    child:Row(children:[
      Expanded(child:FilledButton.icon(
        onPressed:(){setState((){playing=!playing; if(playing){controller.repeat();}else{controller.stop();}});},
        icon:Icon(playing?Icons.pause_rounded:Icons.play_arrow_rounded),
        label:Text(playing?'إيقاف الحركة':'تشغيل الحركة'),
      )),
      const SizedBox(width:8),
      IconButton.filled(onPressed:(){controller.reset();if(playing)controller.repeat();},icon:const Icon(Icons.replay_rounded)),
      const SizedBox(width:4),
      IconButton.filled(onPressed:index<lessons.length-1?()=>select(index+1):null,icon:const Icon(Icons.arrow_forward_rounded)),
    ])
  );
}

class TrainingPainter extends CustomPainter {
  final double progress; final int lesson;
  TrainingPainter({required this.progress,required this.lesson});
  @override
  void paint(Canvas canvas,Size s){
    final cx=s.width/2, floor=s.height*.82;
    final p=Paint()..style=PaintingStyle.stroke..strokeWidth=5..strokeCap=StrokeCap.round..color=const Color(0xFFB9FF3D);
    final soft=Paint()..style=PaintingStyle.stroke..strokeWidth=2..color=Colors.white12;
    canvas.drawLine(20,floor,s.width-20,floor,soft);
    for(int i=0;i<4;i++){ final r=55+i*32+math.sin(progress*math.pi*2+i)*3; canvas.drawCircle(Offset(cx,floor-80),r,soft); }
    final sway=math.sin(progress*math.pi*2)*7;
    final head=Offset(cx+sway*.3,floor-220);
    canvas.drawCircle(head,28,p);
    final shoulder=Offset(cx+sway,floor-175), hip=Offset(cx-sway*.3,floor-105);
    canvas.drawLine(Offset(shoulder.dx-42,shoulder.dy),Offset(shoulder.dx+42,shoulder.dy),p);
    canvas.drawLine(shoulder,hip,p);
    canvas.drawLine(hip,Offset(hip.dx-30,hip.dy+65),p);
    canvas.drawLine(hip,Offset(hip.dx+30,hip.dy+65),p);
    final armWave=math.sin(progress*math.pi*2)*10;
    canvas.drawLine(Offset(shoulder.dx-35,shoulder.dy),Offset(shoulder.dx-65,shoulder.dy+55+armWave),p);
    canvas.drawLine(Offset(shoulder.dx+35,shoulder.dy),Offset(shoulder.dx+65,shoulder.dy+55-armWave),p);
    final propY=floor-95+math.sin(progress*math.pi*2)*4;
    final prop=Paint()..color=const Color(0xFF8D98A6)..strokeWidth=10..strokeCap=StrokeCap.round;
    canvas.drawLine(Offset(cx-54,propY),Offset(cx+54,propY),prop);
    canvas.drawCircle(Offset(cx-54,propY),7,prop); canvas.drawCircle(Offset(cx+54,propY),7,prop);
    final label=TextPainter(text:const TextSpan(text:'أداة تدريب • غير عاملة',style:TextStyle(color:Colors.white38,fontSize:12)),textDirection:TextDirection.rtl)..layout();
    label.paint(canvas,Offset(cx-label.width/2,floor-35));
  }
  @override bool shouldRepaint(covariant TrainingPainter old)=>old.progress!=progress||old.lesson!=lesson;
}
