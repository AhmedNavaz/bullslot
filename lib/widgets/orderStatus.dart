import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/controllers/productController.dart';
import 'package:bullslot/models/orderStatus.dart';
import 'package:bullslot/models/product.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../constants/colors.dart';
import '../controllers/orderController.dart';
import '../services/utils.dart';

class OrderStatusWidget extends StatefulWidget {
  OrderStatusWidget({super.key, this.orderStatus});

  OrderStatus? orderStatus;

  @override
  State<OrderStatusWidget> createState() => _OrderStatusWidgetState();
}

class _OrderStatusWidgetState extends State<OrderStatusWidget> {
  Utils utils = Utils();
  late String clock;
  late Timer clockSec;

  ProductController productController = Get.find<ProductController>();
  OrderController orderController = Get.find<OrderController>();

  Product? product;

  @override
  void initState() {
    if (widget.orderStatus!.slots == 0) {
      for (var element in productController.liveProducts) {
        if (element.id == widget.orderStatus!.productId) {
          product = element;
        }
      }
    } else {
      for (var element in productController.products) {
        if (element.id == widget.orderStatus!.productId) {
          product = element;
        }
      }
    }

    super.initState();

    clock = DateTime.now().second.toString();
    // defines a timer
    clockSec = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        clock = DateTime.now().second.toString();
      });
    });
  }

  Future<void> _generateInvoice() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = await drawHeader(page, pageSize, grid);
    //Draw grid
    drawGrid(page, grid, result);
    //Add invoice footer
    drawFooter(page, pageSize);

    List<int> bytes = await document.save();
    document.dispose();

    utils.saveAndOpenInvoice(bytes, 'Invoice.pdf');
  }

  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    String footerContent = orderController.officeAddress.value;

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    page.graphics.drawString(
        'Delivery Fee', PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    double fee = double.parse(widget.orderStatus!.deliveryCharges!);

    page.graphics.drawString(double.parse(fee.toStringAsFixed(2)).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 30,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 30,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
  }

  Future<PdfLayoutResult> drawHeader(
      PdfPage page, Size pageSize, PdfGrid grid) async {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    // page.graphics.drawRectangle(
    //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
    //     brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawImage(PdfBitmap(await _readImageData('logo.png')),
        Rect.fromLTWH(410, 10, 80, 80));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Order ID: ${(widget.orderStatus!.id)!.split('-').first.toUpperCase()}\r\n\r\nDate: ${format.format(widget.orderStatus!.date!)}\r\n\r\nDelivery Type: ${widget.orderStatus!.deliveryType}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    String address = '''Bill To: \r\n\r\n${widget.orderStatus!.name!}, 
        \r\n\r\n${widget.orderStatus!.address} 
        \r\n\r\n${widget.orderStatus!.email}\r\n\r\n${widget.orderStatus!.phone}''';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value =
        product!.totalSlots == null ? 'Price' : 'Slot Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    //Add row
    double price = product!.totalSlots == null
        ? double.parse(product!.totalPrice!)
        : double.parse(product!.totalPrice!) / product!.totalSlots!;
    int quantity =
        widget.orderStatus!.slots! == 0 ? 1 : widget.orderStatus!.slots!;
    addProduct(
        widget.orderStatus!.productId!.split('-').first.toUpperCase(),
        product!.title!,
        double.parse(price.toStringAsFixed(2)),
        widget.orderStatus!.slots!,
        double.parse((price * quantity).toStringAsFixed(2)),
        grid);
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  void addProduct(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                child: Image.network(
                  product!.images![0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'Order ID: ${'#${widget.orderStatus!.id}'.split('-').first.toUpperCase()}',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 16),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        '${product!.title}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.white70,
                            size: 20,
                          ),
                          Text(
                            product!.location!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white70),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            width: double.infinity,
            child: product!.totalSlots != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Slots:   ${product!.totalSlots}'.split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        'Remaining Slots:   ${product!.availableSlots}'
                            .split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        '#${product!.totalPrice}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
          ),
          product!.totalSlots != null
              ? Container(
                  color: secondaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Original Price: #${product!.totalPrice}'.split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        'Slot Price: #${double.parse(product!.totalPrice!) / product!.totalSlots!.toDouble()}'
                            .split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: '${widget.orderStatus!.status}'.split('.')[1] ==
                        'DELIVERED'
                    ? Colors.black
                    : '${widget.orderStatus!.status}'.split('.')[1] == 'PAID'
                        ? accentColor
                        : '${widget.orderStatus!.status}'.split('.')[1] ==
                                'REJECTED'
                            ? Colors.red
                            : '${widget.orderStatus!.status}'.split('.')[1] ==
                                    'REFUNDED'
                                ? Colors.blueAccent
                                : Colors.grey,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            child: widget.orderStatus!.status!.toString().split('.')[1] ==
                        'PAID' ||
                    widget.orderStatus!.status!.toString().split('.')[1] ==
                        'DELIVERED' ||
                    widget.orderStatus!.status!.toString().split('.')[1] ==
                        'REFUNDED'
                ? Row(
                    children: [
                      Text(
                        '${widget.orderStatus!.status}'.split('.')[1],
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (widget.orderStatus!.status!
                                  .toString()
                                  .split('.')[1] ==
                              'REFUNDED') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      title: Text('Refund Details'),
                                    ),
                                    body: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Refund Reason',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2!
                                                  .copyWith(
                                                      fontSize: 20,
                                                      color: Colors.black)),
                                          Text(
                                              widget.orderStatus!.refundReason!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                          const SizedBox(height: 20),
                                          Text('Refund Proof',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2!
                                                  .copyWith(
                                                      fontSize: 20,
                                                      color: Colors.black)),
                                          Image.network(
                                            widget.orderStatus!.refundProof!,
                                            height: 300,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          } else {
                            _generateInvoice();
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                                widget.orderStatus!.status!
                                            .toString()
                                            .split('.')[1] ==
                                        'REFUNDED'
                                    ? 'Details'
                                    : 'Invoice',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.white)),
                            Icon(
                                widget.orderStatus!.status!
                                            .toString()
                                            .split('.')[1] ==
                                        'REFUNDED'
                                    ? Icons.open_in_new
                                    : Icons.download,
                                color: Colors.white,
                                size: 20),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      '${widget.orderStatus!.status}'.split('.')[1],
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 20),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
