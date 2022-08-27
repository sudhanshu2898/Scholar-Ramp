import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scholarramp/config.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class NotesViewer extends StatefulWidget {
  String title, url;
  NotesViewer({
    this.title,
    this.url
  });
  @override
  _NotesViewerState createState() => _NotesViewerState(title: title, url: url);
}

class _NotesViewerState extends State<NotesViewer> {
  String title, url;
  _NotesViewerState({
    this.title,
    this.url
  });

  bool isDocumentLoading = true;
  PDFDocument _pdfDocument;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    _pdfDocument = await PDFDocument.fromURL(url);
    setState(() => isDocumentLoading = false);
  }

  Widget screenContent(){
    if(isDocumentLoading == true){
      return Center(
        child: SpinKitRing(
          size: 20,
          lineWidth: 3,
          color: gradientEndColor,
        ),
      );
    }else{
      return PDFViewer(
        document: _pdfDocument,
        zoomSteps: 1,
        showNavigation: false,
        showPicker: false,
        scrollDirection: Axis.vertical,
        lazyLoad: false,
        progressIndicator: SpinKitRing(
          size: 20,
          lineWidth: 3,
          color: gradientEndColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: gradientStartColor,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: GradientText(
            text:title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            colors: <Color>[
              gradientStartColor,
              gradientEndColor
            ],
          ),
        ),
        body: Center(
          child: screenContent(),
        ),
      ),
    );
  }
}
