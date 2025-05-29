import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_platform/services/api_service.dart';
import 'package:education_platform/screens/CareerTest/career_test_screen.dart';
import 'package:education_platform/screens/Discussions/discussion_user_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Kullanıcı";
  String userEmail = "";
  String profileImage = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQEBAQEBAWEBAVEBYbEBUVDRsQEA4WIB0iIiAdHx8kKDQsJCYxJx8fLTItMSsuMDAwIytKTT81NzQ5Ly4BCgoKDg0OFRANFSslFRk3KysrKy04KzctKzczNys3Nzc3Li04Ny0tLTcrLy0xKzc1Ky8rLSstLSsrKystKysrK//AABEIAMgAyAMBIgACEQEDEQH/xAAcAAABBQEBAQAAAAAAAAAAAAAFAAIDBAYHAQj/xAA9EAABAwIEAwYDBgUDBQEAAAABAAIDBBEFEiExBkFREyJhcYGRMqGxI0JScsHRFGKC4fAHFfEzc5KTomP/xAAaAQADAQEBAQAAAAAAAAAAAAABAgMABAUG/8QAIxEAAgICAgICAwEAAAAAAAAAAAECEQMhEjEEQRNRIjJxYf/aAAwDAQACEQMRAD8AHELwhS5U0sWCRJripSxQysJ0QMB8SkJIA66r2lg2CsyUV3a6eJV+CjLR18tUQURBuUWVeoksFalaQhFVISfogEile4n4iPIqIuf1v5hNfIoXVFkQEhndexHspzcbhVqK5u92gvovZ65t9XADzWMTVGrbdSmxRAKm/EYwdXX8tVNDWsebB10oyLV04FMBXqDCOJTSV4SmFyAT1zlG56R91G4o0YY5yjcU5yjKxhEry68JTSUDE9Me+z84+qSZSu77PzD6pIox1k4HPqexfb/tlRjB5TtG4/0FdjewEEHYjVBKqlEbgGggZdLm/Mp2yaOb/wCyTWzdm8ixNxGSLeyiGDS3I7J9/wDtO/ZdXhpGujykmzmFthYWvuqjuHT9yplb5uzBI2/ReCxv9mc1GAzFocIXlp2Ihcb/ACVX/aJDtG//ANTv2XaoqbJG2Np+EWB9N0HwvQOH8yE5NKxNN6OUzYNLbVjh5tIQqrwpw3t/5Bd9aVBiUzGQyPfawad+fgpqbDo+dZ8Md008EJqg1ul8xvsNlqeMJQ6R5Fg8nvZWj2WRlpndNOZVrFooVE8nw5iANAAbBUnIpNTkb9d1Wlp7HzRsFFJOaDuE90RXuUhY1DmVkrdnnTle6JUmM3sJBbxCEuKjG/ogY1gffUG4XhKCYZVkEMJ0O3gUXJWGHZl4/RRPma3dwHm6yqz17OTgT5rALMjlA5yr/wAcw7kA+F15/FMP3gsayVzk3Mm5wdQbry6wCemd32fnH1SUdKftGfnH1SRMfYaF4t8Tfy/qil0AxrEGiQssSWDveuqIqLlLVtaADfRXWVTDsfksc/FnBzgI7gHQ5t/kiUFYG2JcG3bcAut/m6nzSH4M0jTfZAMP3k/MiGF1Yfn1Bs47HxP7IVh7+/MOj/1KXLJOFgSadBhixHGOMZ520sZ0YC6Q/wA3JaHiDGG0lM+UkXtZg6uXPcHppDHNVPGZ7idzre2vsDbzJ6JcceWx+jG8RxkSX+fNU6e7xlylx8BuiOIwvqJwywvmsAtjQ4NHA0AAXA1NtynY8Y2c8dhMzjYMNvFMfw9OBct8raldAnYAVUnqANBqVCWWV0jsj48KuRgP9oceWoTDg0nRbF4ubndINum+RknhXoxUmEu5N5aqnJQHUWXRo6Qu0srE+CxFhzAXtv0Sy8jj2MvFcujk8tOW8vNRzSyO3cbeBsEaxSmyvc23l4oY+O3mumDs4skeJRyLzIrTmphanJkGVKylIXmVEw2NxabhF6KllmB7ON0hHxZWF1vZCsq13+ntZkqOzJ7sjSP6hqP1CSbpWimKKlNJkWH8NVj5IwKd9843GXn4pLrWFf8AWZ5/okpwyNq6LeRhjjkkmKbHTI+Go7kYBs6MPPf11uP1RGnkdM6R4j7Np3cX9y/mbIR/s8gyyfw8srsoteF2QenNKogrpPihldbYZDZv7K8Yyd8mSzzxKviTCzK6JhN3MPe1OQvB0A3srclXBP2TQ4ktblsIb5h76bLM02B1UunZFni7ugfqr7qWNkhohI+PuXnmbGXuedLMAGw1SSxREjlkwuziihpC5ucyEnvBjQeZ0J2O6fg1Y2R0sguGvIc0W1sSTyWWdwUXP+yMsjOroOxJPm4q1U4ocPgnGrZQ3IwXub7IZsKeNKPsEJ/k7KXEtaa6tbTRm8cZt4F/X0sT6JvGOJtpoW08e9hpzPQeZP6p3CtKIIH1MvxG+p/+j7i3p4rJz1vbTyVMnwxnug85OQ9B81THjUUor0CUr2arAKHvGR7RmDR721V6tB3vZQ8Iz9pRseTqXPDvQlMxKtjAIzC9+qk12dWOVUC62fdDHPV2Z4dz+aqugUZKjpTsYCr0PZ2FzqqghKd2aSUbKQlQUhqI27FQVdQX6DQKmQBzA9U9kqn8STso8raoC4rh4N5Cs5NRPe85Gkjktfi98twVDmsAALC3JUjNxOPJBS0ZluAyfeIaPNU62mjj0Di93yCJYxXOzFgNhz8UGcF0w5Pcmcs+K0kQEJuVTELzKqE6Isqv4TUdlIyQbskY72KqWUsQ3Hh9Nf0SsaOnZ3PBJ2OmaA8bG2vgkuBwSObO2xI+0Gx8UksYKKofLklklfR9Gs4tpnfjJ/mG3zsi2HTSTEOD2diD93vF/wA9PkuMSuLSdwfZXMM4gqackwzOZf4h8Qd5grpcDlUjsVXj9JTvEc1SyJ/QnvDztt6ovE+NwD2uzNIuCDfN4grj0FdFWOP8VC0E/FJFeN9zzLdWn2W94Tw40sJjEwngLrwO2LAd2kcrHX1U3SH32axrxyC47jx/jcTfHGbxtlOo2vc6+guVu+LcbFLSSSB3fIyxjncrGcJUwggkqpPidexP/wBH3Fv6UfQCvx1iQijZTRb2AAHs0f50WMrGOJipIu87n/M87lWqusMs8tS7ZhIZ+c/sE7hSmL5TUO5GzL9eZTfrEK3I19HSCOhjjY4ga3IO+tvqspiNG43OZxbfe2/ut+6D7JjBYd036AkrIcTYe+xBkLhls0Ndkaw+XNc/+nXSWjMtgAN87hqtDRMfluTmHIrO0VK9gcHm5NrWcSG79VrsKicyncDzFwkeykCN7iGkjdAK2aYmxkDR0CLPmuLIVVUznZgCblvdI7uUpEUmiCKiede1v4G6uxUkzLOBvzsDoq2H4bUtaS55vplF8zPG91oaAOygPtfw2WkwQiUcSNmi/VV7orW0wkLWHYu19iqtbTNjDWtFjqSotjvG9yA1Zh7JDc6HqEPfgnR3yR0heFqKySXTIuCfZnzgjvxfJNOCO/EFoAE7Kj80gfFEzn+yP6hT0/D8hOhGrSPkjYbqiVC3vN/MPqllnkgrDFmJZw7M6dmlhdpJ5bpLc0jwJYrjeySjLzMidI7cXhY5RtguesleC02d4lo09UPcyUG7Xsv01P1RvDsNM2cj4WgkNzZTI7oEfoqanyh74GCJsDi8ZbuL72Avuefsvfk2+z51KjG0mNyt+ykAaLgiwFr9f7rR4fjUhY+na8gSbWeWOaeVihPFeDiHK5vwubmYN3R9Wn0VTB5Wt75G1y7XopSRWMgnLSPfUsphI6RwcC8udm73Iemp90d43rxBAynj/CABzPIBQ8C0xPa1km5JsT1P7C3/AJFZ3Ga/t6qSU6siFx4u2aP1SpW6DegZWMP2dM3U/e8XncrYYbTiJrGDYWWb4agMkrpnahujfMrR1UuUDUC7gATsLlaTtjQVUaWkcTAwv+K5DvO5QLEzckHVGGvBbI0cnX+SGTwg7rncqR6EYXIqUFE0m5A8AidawNidbmqTmlo0Kv1MOZgbm1vqkWWPFlHhkpIzQbrZS9j4IjPhGlw7XyTGU7gAHDbS9lD5E+izxv2V4mdE8ssrLKZ24B9k4U7j90oOS+wrE6KIP2jPIkqnix+00NwWhHqbDmOec1zZuuvU/wBlnMUkDpX20ANgPLRJGalKkDNHhj37K90gF4CvQnaOOx1k7Kk1OBSjCaxXafQjzCqsVpnJTkOhjg4SRZRez7OHh/gSVlpPai3OQj5lJRl30duF/iaan4Cc1sZdKGyMJN2PNjc35hXTw1PrZ7NTc2N9eVgRy+qytHxPUTO7OSp7I5h3i3TLzHmjsWMyxnNLN2UTn/ZkkPOSwv4lfR/kfNaIOIOEquSnZHHEZXh5LnmVuZwsepHVYSrwWemIgnYWSPIJbcEhm/Lquh4fxrUPe/I0GIOOVzu45w8kEwqR2IYlJUyatabjoA2waPe3sUt/YUXMaeKKgEezsvet1OpXNqglsbWffec7/XYey1vHlZ21Q2AHuN1f5DUrP4XCZ6nMRo03P6BBaVh7dGiwai7KJredru8+apY6czmt5NGZyP2sL9As3iDrtc47vdp5BSsoW+CMRc91Qx7i4gNLQTfTVaGoC53geIdhVtJ+BwyO8LnQ+9l0V5upZUdfjzIcumo0TIIgHF9zci2p3C8qasMsLEnwCpPxIHcW9CuaqWj0IXNhSdubKQb2+Slkk7lkJjxJthb9bqRtfG8gDRQ4NvZ0TbjEvQSu01Nlalfa9lSbpqnVc1h48glnG2JDJoz2LY7JBK5rTYOaDtfmdUFFYDqTqd0Y4jwR0xY5paXBliCbF250+ayslE5pIIII3B0IXVhjFxtHneTKfOm9BZszeqkbKOqCCnd1KkbE4feKo4EFIONeOqe1w6oGA/8AEvRI8c0jgPzD7HhWI37LMfxD1JHXvBCR47GWQ1If9s0dZTb3KSzgr3vmY8G1pLgeaSk8LZ0Y88UqZpIuDqiSxia+W55MsB/UdFpcM/0vlNjNIGDmL9o75WHzW9rsep4B3pGg9L3Pss5W8dXOWCMvPInT5L27kzxKRR4twGmoKJ7w58kriGRXfla0nmGi3K6H8K04pqJ8x0L7kHwGg+dz6oPxDis9ZNDC9wJDtGi1mkkAInx1WNgpWQM0GUAeQCR/QbMFWTl7ppTu92Vvluf0Rrhikyx5zu839OSAiIl0cQ3sAfM6kraUsdgGtF7CwACM/o0SZ2yzGKhuazQT0G9lrJKCUjYAk83I9S4VHSsYGWc92srravPTyHRJx9sazh9XE4uJLCBy7pAXQcArxUQNdfvt7snW/X1W2qIm21aLHfRBZ+HIWPM1P9m4iz2j4JPMcj5JZxUlRXHJxdgydgI8UNfAQTcZkacRqHaEKu6YclySTWj1MOWtoFiO+gbY9SFapaMA35qyxw6p7CB5JCk8rl2Pc3RMazM7Mdh8PmmtlLzp8IO/VXctgPJRmbGrYIxcaA3tY7qriVGZaRtSBdzHlr/FvI+h+qtY0LxPv+ErRcK0V6BjHjMHtJcD94H+ypidRJeXHf8ATmQcE4OHRXceweSmkcC0mO/cdbSyFh67NPZ5t0WQG9F6I29FAHp4elaGse6BqjdTjklnS7RLQbPIKaz2/mH1SU1PJ32fmH1SWoxoJKiMOLQXVEv4YwT7nf5eqsswHFKlh7ONlPGdgZMhcPHc+608VBHC4RRMEbOgHxeJO59UViu22U2suzmcvE53g3CtdBVNLowXA3uZAI+l7/2Wq4iwOOdkmdt3scLOB1tpdaoPbJYEaqoyLvyNOux15oORkjI4VwjA1wkJdI/xNm+wWi7BjO4xoaBobN3Kmig7Nx/CBceCdBEdCdzulcgpEctKCBfZupXr2dxhO5uT6lWJR3SOpXmKDK1oHIgBb0Yry/Cq1JA577jRo+IqdjS+zRzROKMMblb/AMoN0hkZ3iGia5u1so0I5BY+oilYdsw5Ea3XQMdi+yPW2pWNpJc8Y8NPTl8lCW+zrxf4DM7+TD7WVqnpnu+PTwCtsYrUbAoyZ1RR5BEBoBdTOanhqgrKgMaSemii1bOmLSA2OEnLE34nuA+a6Hh9NkiYwbNaAPQLDcLULqqsD3C7Wd536D/Oi6YYrK6hSODycvKVADGKPMPDn0I6FYLFOGG5i6F4aOYdoy/gV1CviBYQTa418FmKvI51hpG3oNXJotro59M5tVUEsV87dOo7zfdVsy6XPUM2ELAOr9/YINVYfBJtG25/C0sH1Vk77J/wxpem51qJeEgQS2XKeQdqPdZyuoZITaRpHQ7tPqiazynf32fmH1Xiip/jZ+YfVJajWd9qaLONPiGrUylN9CLEbjxROwUMsAJzDQpyZXjH2gHgnOH2p8WD5EpkvdLXfhOvkrMoAc13K9j6/wDCBiOZlwR4/JNLVcYAbqFzdSiAjYy7gOhuqOOO0b+ZFWNt57oVjY+H8wR9A9ktEzI0E7n5BXYG3/RUqfUC/wDgVyA6H99kr2xkVcTjEjXNOoykHxXPqYZC5nRxHsV0WQLnVUwh8h59o76qU1R1eO7ssAFTNKZTOuF7LIAovbOvolfPlGpQHEKovPgFLWVBOgUeG0RmmjiH3nC/lzTwxizyaN7wFhvZU4kI70hv6cv88VqHNCjgjDGtaBYAABOkcbKrR57lbsC49UtYzXW5WZlqmgW5kc1e4mlzSMZvqocPw7tZbkd0H3QjGtsJRhoHPOY6+eyvMwwO+JosOeyLVc7I+6OSD1uIF2g0HgmSbNySIZ6KHNYH21UlRw/GG3JuCLnom0Tg05i0vI2sLqxJHPOblmVvQi60lsJmKnh2B72lhyOzCxGx16JLUQYa3OATkNxbTQpIWA2LhflY8wmpOmGzu67/ADZNd1GqoRs8fGDe6hh2MTv6T1Cf2gUcljoT5HosGyxA/cHe1ipWx3P1Q7tS0gO3zAX/ABj90QqJckZI3I0WQGeB18xG19PRDcYZdgPQhX4BaP01VauF4SiwrsipWBzQPvA/JEXQZWA8+aq4JGCXE/EALIq8X08EDAg7lYGvb9rKP/0f9SugSNs4hYfF2ZaiUfzX9xdJNHR4zpspUrraJs7r3TiFXlKmls6pPRXkatX/AKfYfd8k5Gg7rfPc/osq83Nl1bAcONPAxhFjlu49Sd1RIhllqi85RzSBrS48gpChuOOywuPU2WZzGRqnGWqHgR+60ZtTw35kIZw3RZnPmdzcQ3yCZxFW5nZQdAjVhB885cSSU6jpC5wvzXlMwWzHbl4ozgceZxkOjW7eaq9IUK0lAxjQSLaKtW4rG3uMGZ2wAQ/GsVcSWNOngqdJTkXJuD945bjyUlD2xuQcw6mLnBzzmcd+WQeF/qks9UYo8vbDD+IZrfD7JLcQWTDiyCcZJJGHpqAQitFiDcgDSHkbObJv5grhT5U6KsezVjy0+DiF0cEQ5HfBiDTpI0tPW2n9l5ITuxwkHS+q4nT8U1jPhnd6976onhnG9W12Yljut2b+yX4w8jpc+ItALXg+R0LT1CKyOzBoPhZc2ZxwKhzGywhri4AFpu3U+K6RFq5n5bocaDZbcbMKrS/9IKxUaNUDh9ldAIynf2bmO5HQ+SLl9rlBphdgKuU8mdgF9QLHr5rGPJxc3WN4lZlnvyLB8if7LZm5ADhrbXzWU4xZZ0ZPiClmtFMTqQAcFBM1SOfYL0EFSOyyXhqkbJWQsdtmuR1sCQPkuuRy6kclyrCaeTto3xjWNwc48gOnqumU1U17Q5vqOYPRUXRzZXs9xJ4jYZLaDcDmgPEFQ2WKNsZuXv8AUeau8Tz2hF+bwP1/RB8FhzuMh2GyDQiLlQ4U8AA07tgse0mWQ9BuiXEWIZiQNhoFTpY8jAPvHVypCIGySQ3sBsiUlR2UNhpce6G0zLu9UWNFm7zz3WjQeKaYEDqCnLjnsSb93z6qbFajIwRsbled7E7I3TxtaLm1mtudbEcz/nggMcTppHSHmdEDCwajDLE6klerS4XhzQA92w2ukpN7GPm+SXUpMBdtt1SSXUQFLZunhqrFKbMJ8F4ksAsYcCZYwNy9tvdd7o3Xf5NASSSyDEt1Ulgo3H7EeSSSUYY0Xj9FHSS5SL7XsV6kgjF926zXG4+xa7mHj6H90klpdDY/2Rh55zprYK9gFBJVPLQ6zBq822HgvUlKKOmbaWje01AyFga05RyFtSnhojeHNGoJvruF6krJHK2D+JqntewjYdS4l38tv+SmVFT2MRYOYSSS0EzbPtJCTqG/M8lfEZsTbzSSTrSCwnglJ94q/UDNIyMHTd3kkkp+wnuKZmwkEglxtYD1KlwnD8oF/MpJLN6MWMQrowAzNzGySSSWgn//2Q==";
  List<String> userRoles = [];
  String userId = "";
  String? careerAdvice;
  bool isLoadingAdvice = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "Kullanıcı";
      userEmail = prefs.getString("userEmail") ?? "";
      profileImage = prefs.getString("profileImage") ?? "https://via.placeholder.com/150";
      userRoles = prefs.getStringList("userRoles") ?? [];
      userId = prefs.getString("userId") ?? "";
    });
  }

  Future<void> _getCareerAdvice() async {
    setState(() {
      isLoadingAdvice = true;
      careerAdvice = null;
    });

    try {
      final result = await ApiService().getCareerAdvice();
      setState(() {
        careerAdvice = _extractCareerAdviceText(result ?? "Tavsiye alınamadı.");
      });
    } catch (e) {
      setState(() {
        careerAdvice = "Bir hata oluştu: $e";
      });
    } finally {
      setState(() {
        isLoadingAdvice = false;
      });
    }
  }

  String _extractCareerAdviceText(String rawJson) {
    try {
      final decoded = json.decode(rawJson);
      if (decoded is Map<String, dynamic>) {
        return decoded['career_advice'] ?? "Tavsiye bulunamadı.";
      }
      return rawJson;
    } catch (_) {
      return rawJson;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "Profilim",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.indigo, Colors.deepPurple],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              _buildInfoBox(Icons.person_outline, "Ad Soyad", userName),
              _buildInfoBox(Icons.email_outlined, "E-Posta", userEmail),

              const SizedBox(height: 25),

              isLoadingAdvice
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _getCareerAdvice,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text("Kariyer Tavsiyesi Al"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CareerTestScreen()),
                    );
                  },
                  icon: const Icon(Icons.assignment_rounded, color: Colors.indigo),
                  label: const Text(
                    "Kariyer Testi Çöz",
                    style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: Colors.indigo),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DiscussionUserScreen()),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.indigo),
                  label: const Text(
                    "Tartışmalarım",
                    style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: Colors.indigo),
                  ),
                ),
              ),

              if (careerAdvice != null) ...[
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🤖 Yapay Zeka Tavsiyesi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        careerAdvice!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
