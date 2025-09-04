
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(SuTakipApp());
}

class SuTakipApp extends StatelessWidget {
  const SuTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SuTakipHomePage(),
    );
  }
}

class SuTakipHomePage extends StatefulWidget {
  const SuTakipHomePage({super.key});

  @override
  State<SuTakipHomePage> createState() => _SuTakipHomePageState();
}

class _SuTakipHomePageState extends State<SuTakipHomePage> {
  int icililenMiktar = 0;
  final int gunlukHedef = 2000;
  bool mesajGoster = false;

  void suEkle(int miktar) {
    setState(() {
      icililenMiktar += miktar;
    });
  }

  void sayacSifirla() {
    setState(() {
      icililenMiktar = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int kalanSu =
        gunlukHedef - icililenMiktar > 0 ? gunlukHedef - icililenMiktar : 0;

    double ilerlemeDurumu = icililenMiktar / gunlukHedef;
    if (ilerlemeDurumu > 1.0) ilerlemeDurumu = 1.0; // %100 geçmesin diye

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Su Takip Uygulaması"),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFE0F0FF),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 280,
                  width: 280,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: ilerlemeDurumu,
                        strokeWidth: 25,
                        backgroundColor: Colors.lightBlue[100],
                        color:
                            icililenMiktar >= gunlukHedef
                                ? Colors.lightGreen
                                : Colors.blue[700],
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$icililenMiktar ml / $gunlukHedef ml",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              icililenMiktar > gunlukHedef
                                  ? "Hedef Tamamlandı !"
                                  : "Kalan: $kalanSu ml",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    icililenMiktar > gunlukHedef
                                        ? Colors.green
                                        : Colors.blue,
                                fontWeight:
                                    icililenMiktar > gunlukHedef
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),

                Wrap(
                  spacing: 15,
                  children: [
                    SuButonu(miktar: 200, tiklandiginda: () => suEkle(200)),
                    SuButonu(miktar: 300, tiklandiginda: () => suEkle(300)),
                    SuButonu(miktar: 500, tiklandiginda: () => suEkle(500)),
                  ],
                ),

                const SizedBox(height: 100),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      icililenMiktar = 0;
                      mesajGoster = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Sıfırla"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuButonu extends StatelessWidget {
  final int miktar;
  final VoidCallback tiklandiginda;

  const SuButonu({
    super.key,
    required this.miktar,
    required this.tiklandiginda,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tiklandiginda,
      child: Column(
        children: [
          Row(
            children: [
            Column(
              children: [
              // Bardak görseli
            if (miktar == 200)
              Image.asset(
                'assets/images/glass.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain),
            const SizedBox(height: 6),
          
            // Miktar yazısı
            Text(
              "$miktar ml",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ],
            ),
          
            Column(
              children: [
              // Bardak görseli
            if (miktar == 300)
              Image.asset(
                'assets/images/glass.png',
                width: 80,
                height: 100,
                fit: BoxFit.contain),
            const SizedBox(height: 6),
          
            // Miktar yazısı
            Text(
              "$miktar ml",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ],
            ),
          
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              // Bardak görseli
            if (miktar == 500)
              Image.asset(
                'assets/images/bottle.png',
                width: 100,
                height: 120,
                fit: BoxFit.contain),
            const SizedBox(height: 6),
          
            // Miktar yazısı
            Text(
              "$miktar ml",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ],
            ),
            ],
          ),
        ]

      ),
    );
  }
}
