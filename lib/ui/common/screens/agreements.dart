import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsOfUsagePage extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Dodact Kullanım Şartları Sözleşmesi"),
      ),
      body: SfPdfViewer.network(
        'https://dodact.com/wp-content/uploads/2021/12/Kullanim-Kosullari.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Dodact Gizlilik Sözleşmesi"),
      ),
      body: SfPdfViewer.network(
        'https://dodact.com/wp-content/uploads/2021/12/Gizlilik-Sozlesmesi-Dodact-Guncel.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}

class CopyrightPage extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Dodact Telif Hakları Sözleşmesi"),
      ),
      body: SfPdfViewer.network(
        'https://dodact.com/wp-content/uploads/2021/12/Telif-Hakki.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}

class KvkkPage extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Dodact KVKK Metni"),
      ),
      body: SfPdfViewer.network(
        'https://dodact.com/wp-content/uploads/2021/12/Dodact-KVKK.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}
