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
  late int gunlukHedef = 2000;
  bool mesajGoster = false;
  DateTime bugun = DateTime.now();

  void suEkle(int miktar) {
    setState(() {
      icililenMiktar += miktar;

      if (icililenMiktar < gunlukHedef || icililenMiktar % 500 == 0 && icililenMiktar % 200 == 0 && icililenMiktar % 300 == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Su içmeyi unutma 💧"),
            duration: Duration(seconds: 3),
          ),
        );
      }

      if (icililenMiktar >= gunlukHedef) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Tebrikler! Günlük Hedefine Ulaştın 🎉 "),
            backgroundColor: Colors.lightGreen,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void sayacSifirla() {
    setState(() {
      icililenMiktar = 0;
    });
  }

  void gunlukHedefDegistir() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(
          text: gunlukHedef.toString(),
        );
        return AlertDialog(
          title: Text("Günlük Hedefi Belirle :"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Örn 2400'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  gunlukHedef = int.tryParse(controller.text) ?? gunlukHedef;
                });
                Navigator.pop(context);
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int kalanSu =
        gunlukHedef - icililenMiktar > 0 ? gunlukHedef - icililenMiktar : 0;

    double ilerlemeDurumu = icililenMiktar / gunlukHedef;
    if (ilerlemeDurumu > 1.0) ilerlemeDurumu = 1.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Su Takip Uygulaması"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: gunlukHedefDegistir),
        ],
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

                // Butonlar - Row ile yan yana
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
      child: SizedBox(
        width: 100,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Görsel
            _buildImage(),
            const SizedBox(height: 8),
            // Miktar yazısı
            Text(
              "$miktar ml",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    switch (miktar) {
      case 200:
        return Image.asset(
          'assets/images/glass.png',
          width: 75,
          height: 100,
          fit: BoxFit.contain,
        );
      case 300:
        return Image.asset(
          'assets/images/glass.png',
          width: 80,
          height: 100,
          fit: BoxFit.contain,
        );
      case 500:
        return Image.asset(
          'assets/images/bottle.png',
          width: 100,
          height: 120,
          fit: BoxFit.contain,
        );
      default:
        return Container(width: 80, height: 100, color: Colors.grey);
    }
  }
}
