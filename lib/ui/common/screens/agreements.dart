import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsOfUsagePage extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodact Kullanım Şartları Sözleşmesi"),
      ),
      body: SfPdfViewer.network(
        'https://dodact.com/wp-content/uploads/2021/11/Kullanim-Kosullari.pdf',
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
        title: Text("Dodact Gizlilik Sözleşmesi"),
      ),
      body: SfPdfViewer.network(
        'https://dodact.com/wp-content/uploads/2021/11/Gizlilik-Sozlesmesi-Dodact-Guncel.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}

class CopyrightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class KvkkPage extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodact KVKK Sözleşmesi"),
      ),
      body: SfPdfViewer.network(
        'https://dodact.com/wp-content/uploads/2021/11/Dodact-KVKK.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}