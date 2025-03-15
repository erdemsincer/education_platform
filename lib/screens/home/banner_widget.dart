import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';

class BannerWidget extends StatefulWidget {
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Future<Map<String, dynamic>?> _banner;

  @override
  void initState() {
    super.initState();
    _banner = ApiService().getBanner();  // API'den tek bannerı al
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(  // API verisi çekiliyor
      future: _banner,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());  // Yükleniyor göstergesi
        } else if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));  // Hata mesajı
        } else if (!snapshot.hasData) {
          return Center(child: Text("Banner bulunamadı"));  // Banner yoksa mesaj
        } else {
          var banner = snapshot.data;

          // Tek bir banner gösteriyoruz
          return Container(
            width: double.infinity,  // Genişlik tam ekran olacak
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),  // Margin ekledik
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),  // Kutunun köşe yuvarlaklıkları
              color: Colors.white,  // Arka plan rengi beyaz
              boxShadow: [
                BoxShadow(  // Kutunun etrafına gölge ekledik
                  color: Colors.black12,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 4), // Gölgenin konumu
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),  // Resmin köşe yuvarlaklıkları
                  child: Image.asset(
                    "assets/img/hero/heroman.png",  // Burada asset yolu kullanıyoruz
                    fit: BoxFit.cover,  // Resmi kutuya tam oturtuyoruz
                    width: double.infinity,  // Genişlik tam ekran
                    height: 300,  // Yüksekliği artırdık
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    banner!['title'],  // Banner başlığını ekliyoruz
                    style: TextStyle(
                      fontSize: 24,  // Font boyutunu artırdık
                      fontWeight: FontWeight.w600,  // Font ağırlığını değiştirdik
                      color: Colors.blueAccent,  // Başlık rengi mavi
                      fontFamily: 'Roboto',  // Font ailesini değiştirdik
                      letterSpacing: 2,  // Harfler arası mesafeyi artırdık
                    ),
                    textAlign: TextAlign.center,  // Başlığı ortaladık
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
