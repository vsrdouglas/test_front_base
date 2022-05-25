import 'dart:typed_data';

import 'report_pdf_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GeneratePDF {
  Invoice? invoice;
  GeneratePDF({
    required this.invoice,
  });

  get bytes => null;

  generatePDFInvoice() async {
    final pw.Document doc = pw.Document();

    final pw.Font customFont =
        pw.Font.ttf((await rootBundle.load('fonts/Montserrat-Regular.ttf')));
    final ByteData bytes = await rootBundle.load('images/pdf_logo.png');
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
            margin: pw.EdgeInsets.zero,
            theme:
                pw.ThemeData(defaultTextStyle: pw.TextStyle(font: customFont))),
        header: (context) => _buildHeader(context, bytes),
        build: (context) => _buildContent(context),
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  ///Cabeçaçho
  pw.Widget _buildHeader(pw.Context context, ByteData bytes) {
    return pw.Container(
        color: PdfColor.fromHex('6CCFF7'),
        height: 150,
        child: pw.Padding(
            padding: const pw.EdgeInsets.only(
                top: 10, bottom: 10, left: 25, right: 25),
            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(right: 30),
                    width: 70,
                    child: imagem(bytes),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Report of: ' + invoice!.report!.projectName,
                        style: const pw.TextStyle(
                            fontSize: 25, color: PdfColors.white)),
                  ),
                ])));
  }

  imagem(bytes) {
    final Uint8List byteList = bytes.buffer.asUint8List();
    return pw.Image(
        pw.MemoryImage(
          byteList,
        ),
        height: 70,
        fit: pw.BoxFit.fitHeight);
  }

//caonteúdo da pagina
  List<pw.Widget> _buildContent(pw.Context context) {
    return [
      pw.Padding(
          padding: const pw.EdgeInsets.only(top: 30, left: 25, right: 25),
          child: _buildContentReport()),
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 30, left: 25, right: 25),
        child: pw.Text('Members: ',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            )),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 25, left: 25, right: 25),
        child: _contentTable(context),
      ),
    ];
  }

  pw.Widget _buildContentReport() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Report',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Container(
          height: 25,
        ),
        _titleText(
            'Period: ',
            invoice!.report!.projectStartDate +
                ' to ' +
                invoice!.report!.projectEndDate),
        _titleText('Start Date: ', invoice!.report!.startDate),
        _titleText('End Date: ', invoice!.report!.endDate),
        _titleText('Budget-Type: ', invoice!.report!.budgetType),
        if (invoice!.report!.sprintLength != 0) ...[
          _titleText(
              'Sprint Length: ', invoice!.report!.sprintLength.toString()),
        ],
        _titleText('Budget: ', 'R\$' + invoice!.report!.budget),
        _titleText('Period Budget: ', 'R\$' + invoice!.report!.periodBudget),
        _titleText('Period Cost: ', 'R\$' + invoice!.report!.periodCost),
        _titleText('Period Result: ', 'R\$' + invoice!.report!.periodResult),
      ],
    );
  }

  /// Retorna um texto com formatação própria para título
  _titleText(String desc, String value) {
    return pw.Row(children: [
      pw.Text(desc,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
    ]);
  }

  /// Constroi uma tabela com base nos produtos da fatura
  pw.Widget _contentTable(pw.Context context) {
    // Define uma lista usada no cabeçalho
    if (invoice!.members!.isEmpty) {
      return pw.Text(
        'No Assignments Found for the Selected Period!',
        style: pw.TextStyle(
          fontSize: 17,
          color: PdfColors.grey,
          fontWeight: pw.FontWeight.bold,
        ),
      );
    } else {
      const tableHeaders = ['Name', 'Monthly Cost', 'Total Cost'];

      return pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: const pw.BoxDecoration(
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(2.0)),
        ),
        headerHeight: 25,
        cellHeight: 40,
        // Define o alinhamento das células, onde a chave é a coluna
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerLeft,
        },
        // Define um estilo para o cabeçalho da tabela
        headerStyle: pw.TextStyle(
          fontSize: 10,
          color: PdfColor.fromHex('6CCFF7'),
          fontWeight: pw.FontWeight.bold,
        ),
        // Define um estilo para a célula
        cellStyle: const pw.TextStyle(
          fontSize: 10,
        ),
        // Define a decoração
        rowDecoration: pw.BoxDecoration(
          border: pw.Border(
            bottom:
                pw.BorderSide(color: PdfColor.fromHex('6CCFF7'), width: 0.5),
          ),
        ),
        headers: tableHeaders,
        // retorna os valores da tabela, de acordo com a linha e a coluna
        data: List<List<String>>.generate(
          invoice!.members!.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => _getValueIndex(invoice!.members![row], col),
          ),
        ),
      );
    }
  }

  String _getValueIndex(Member member, int col) {
    switch (col) {
      case 0:
        return member.name;
      case 1:
        return 'R\$' + member.monthlyCost;
      case 2:
        return 'R\$' + member.totalCost;
    }
    return '';
  }
}
