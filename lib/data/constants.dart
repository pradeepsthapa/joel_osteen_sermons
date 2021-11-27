import 'package:google_fonts/google_fonts.dart';
import 'font_model.dart';

class Constants{

  static const String darkMode = 'darkMode';
  static const String fontSize = 'fontSize';
  static const String backgroundColor = 'background';
  static const String fontIndex = 'fontIndex';
  static const String recentPlaylist = 'recentlyPlayed';

  static String joelOsteenAudio = "https://feeds.megaphone.fm/HSW9490884322";
  static String joelOsteenAudio2 = "https://www.joelosteen.com/Views/RSS/Feed?t=PodcastAudio&ct=CustomList&cst=Podcasts";
  static String joelOsteenVideo = "https://www.joelosteen.com/Views/RSS/Feed?t=Podcastvideo&ct=CustomList&cst=Podcasts";
  static String joelOsteenIHeart = "https://www.iheart.com/podcast/585-joel-osteen-podcast-28292517/";
  static String joelOsteenYouTube = "https://www.youtube.com/c/joelosteen";


  static List<GlobalFontModel> globalFonts = [
    // GlobalFontModel(textTheme: GoogleFonts.literataTextTheme(), fontFamily: GoogleFonts.literata().fontFamily!,fontName: "Literata"),
    // GlobalFontModel(textTheme: GoogleFonts.libreBaskervilleTextTheme(), fontFamily: GoogleFonts.libreBaskerville().fontFamily!,fontName: "Libre Baskerville"),
    GlobalFontModel(textTheme: GoogleFonts.ibmPlexSansTextTheme(), fontFamily: GoogleFonts.ibmPlexSans().fontFamily!,fontName: "IBM Plex"),
    GlobalFontModel(textTheme: GoogleFonts.quicksandTextTheme(), fontFamily: GoogleFonts.quicksand().fontFamily!,fontName: "Quicksand"),
    // GlobalFontModel(textTheme: GoogleFonts.archivoTextTheme(), fontFamily: GoogleFonts.archivo().fontFamily!,fontName: "Archivo"),
    GlobalFontModel(textTheme: GoogleFonts.loraTextTheme(), fontFamily: GoogleFonts.lora().fontFamily!,fontName: "Lora"),
    GlobalFontModel(textTheme: GoogleFonts.sourceSansProTextTheme(), fontFamily: GoogleFonts.sourceSansPro().fontFamily!,fontName: "Source Sans Pro"),
    GlobalFontModel(textTheme: GoogleFonts.montserratTextTheme(), fontFamily: GoogleFonts.montserrat().fontFamily!,fontName: "Montserrat"),
    GlobalFontModel(textTheme: GoogleFonts.workSansTextTheme(), fontFamily: GoogleFonts.workSans().fontFamily!,fontName: "Work Sans"),
    GlobalFontModel(textTheme: GoogleFonts.slabo13pxTextTheme(), fontFamily: GoogleFonts.slabo13px().fontFamily!,fontName: "Slabo 13px"),
    GlobalFontModel(textTheme: GoogleFonts.latoTextTheme(), fontFamily: GoogleFonts.lato().fontFamily!,fontName: "Lato"),
  ];

}