import 'dart:async';
import 'dart:io';

import 'package:file/memory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:excel/excel.dart' as Exl;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tensai3/needs.dart';
import 'package:tensai3/list.dart';

class resume extends StatefulWidget {

  resume({super.key});

  @override
  State<resume> createState() => _resumeState();
}

class _resumeState extends State<resume> {
  final user = FirebaseAuth.instance.currentUser!;

  late Exl.Excel excel;

  String eName = '';

  bool isActive = false;

  double zps = 0;

  double lgod = 0;

  double za = 0;

  double zt = 0;

  double lob = 0;

  double zsm = 0;

  double zrt = 0;

  double zsh = 0;

  double zzp = 0;

  double zn = 0;

  double zp = 0;

  double sm = 0;

  Future<void> addSto() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("files/$eName");
    File eFile = MemoryFileSystem().file('$eName')..writeAsBytesSync(excel.encode()!);
    ref.putData(await eFile.readAsBytes());
  }

  calc() async {
    if (_formKey.currentState!.validate()) {
      za = 0.15 *
          double.parse(am.text) *
          double.parse(kr.text) *
          double.parse(ts.text);
      if (sts.text == '' &&
          N.text == '' &&
          rud.text == '' &&
          ats.text == '' &&
          sprem.text == '') {
        zps = za;
        lgod = 0;
      } else {
        lgod = ((double.parse(sts.text) *
                        (1 + double.parse(N.text) * double.parse(rud.text)) -
                    double.parse(sts.text) * double.parse(ats.text)) /
                double.parse(N.text)) *
            double.parse(am.text) *
            0.8;
        zps = lgod + double.parse(sprem.text);
      }
      lob = 365 *
          (double.parse(n.text) * double.parse(lkr.text) +
              double.parse(lo.text));
      zt = 0.01 *
          lob *
          double.parse(nt.text) *
          double.parse(kn.text) *
          double.parse(tst.text);
      zsm = zt * 0.1;
      zrt = double.parse(krt.text) *
          double.parse(am.text) *
          double.parse(kr.text) *
          double.parse(ts.text);
      zsh = double.parse(tssh.text) *
          double.parse(m.text) *
          lob /
          (double.parse(sh.text) * double.parse(ksh.text));
      zzp = (double.parse(mp.text) *
              (double.parse(zb.text) * double.parse(nb.text) +
                  double.parse(zk.text) * double.parse(nk.text)) *
              double.parse(am.text) *
              double.parse(k.text)) *
          1.2;
      zp = zt + zsm + zrt + zsh + zzp;
      zn = 0.2 * zp;
      sm = (zps + (zp + zn) * double.parse(r.text)) * double.parse(knds.text);

      //Creating EXCEL

      excel = Exl.Excel.createExcel();
      excel.rename('Sheet1', busNum.text.toString());
      Exl.Sheet sheet = excel[busNum.text.toString()];
      sheet.setColWidth(1, 80);
      sheet.merge(Exl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
          Exl.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
      sheet.cell(Exl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        ..value = 'Расчёт стоимости маршрута №${busNum.text.toString()}'
        ..cellStyle = Exl.CellStyle(
            bold: true,
            horizontalAlign: Exl.HorizontalAlign.Center,
            verticalAlign: Exl.VerticalAlign.Center);

      table(
          sheet: sheet,
          startrow: 2,
          heading:
              'Зпс- общая сумма нормативных затрат перевозчика на приобретение подвижного состава',
          data: [
            [
              'Лгод',
              'размер годового лизингового платежа (годовой аннуитет) по приобретению подвижного состава',
              lgod
            ],
            [
              'Спрем',
              'Размер годовой страховой премии,согласно ГК РК',
              sprem.text.toString(),
            ],
            [
              'За',
              'Затраты на амортизацию',
              za
            ],
            [
              '',
              'Зпс=Лгод+Спрем или = За',
              zps
            ]
          ]);

      table(sheet: sheet, startrow: 9, heading: ' Лгод- Размер годового лизингового платежа по приобретению подвижного состава', data: [
        [
          'Стс',
          'среднерыночная стоимость одного транспортного средства',
          sts.text.toString(),
        ],
        [
          'N',
          'срок контракта лизинга',
          N.text.toString(),
        ],
        [
          'Rуд',
          'ставка лизингового процента по контракту',
          rud.text.toString(),
        ],
        [
          'Атс',
          'размер авансового платежа по контракту лизинга (процентная ставка от стоимости транспортного средства).',
          ats.text.toString(),
        ],
        [
          'Ам',
          'количество автобусов в день на маршруте по графику',
          am.text.toString(),
        ],
        [
          'фор(2)',
          'Лгод=((Стс х (1+N x Rуд)-Стс х Атс)/N) х Ам х 0,8 ',
          lgod,
        ],
      ]);

      table(sheet: sheet, startrow: 18, heading: ' За- Затраты на амортизацию', data: [
        [
          '0,15',
          'Норма амортизации по автотранспорту в размере 15%',
          0.15,
        ],
        [
          'Ц',
          'Стоимость 1 автобуса из закрепленных на маршруте, в тенге',
          ts.text.toString(),
        ],
        [
          'Кр',
          'коэф. резерва автобуса принимаемый на уровне 1,2',
          kr.text.toString(),
        ],
        [
          'Ам',
          'количество автобусов в день на маршруте по графику',
          am.text.toString(),
        ],
        [
          'фор(3)',
          'За=0,15 х Ам х Кр х Ц ',
          za,
        ]
      ]);

      table(sheet: sheet, startrow: 25, heading: ' Зт - Затраты на автомобильное топливо', data: [
        [
          'Lоб',
          'общий годовой пробег в км при обслуживании маршрута',
          lob,
        ],
        [
          'Нт',
          'базовая норма расхода топлива на 100 км (ПП РК от 11.08.2009 г.№1210)',
          nt.text.toString(),
        ],
        [
          'Кн',
          'совокупный коэффициент надбавок к базавой норме для реальных условий работы автобусов на маршруте, определяется в соответствии с Нормами расхода топлива. Кн=12%за 5 месяцев, коэф=1,12; 12%/12*5=5% за 12 мес.=коэф.1,05',
          kn.text.toString(),
        ],
        [
          'Цт',
          'средняя годовая розничная стоимость 1 литра топлива в тенге с НДС на дату расчета тарифа с учетом использования летнего и зимнего видов топлива( Цт=Цз.т.*7+Цл.т.*5/12) фор (6)  (260*7+345*5/12)',
          tst.text.toString(),
        ],
        [
          '0,01',
          'пересчет расхода топлива со 100 км на 1 км',
          0.01,
        ],
        [
          'фор(4)',
          'Зт=0,01 х Lоб х Нт х Кнх Цт',
          zt,
        ],
      ]);

      table(sheet: sheet, startrow: 33, heading: ' Lоб - общий годовой пробег автобуса', data: [
        [
          'Др',
          'количество дней обслуживания маршрута в году',
          365,
        ],
        [
          'n',
          'ежедневное количество кругорейсов на маршруте ( 8,2 кругов * 10 машин)',
          n.text.toString(),
        ],
        [
          'lкр',
          'протяженность кругорейса на маршруте в км',
          lkr.text.toString(),
        ],
        [
          'lо',
          'ежедневный нулевой пробег, км (15 км* 10 машин)',
          lo.text.toString(),
        ],
        [
          'Ам',
          'количество автобусов в день на маршруте по графику',
          am.text.toString(),
        ],
        [
          'фор(5)',
          'Loб=Др х (n х lкр + lо)',
          lob,
        ],
      ]);

      table(sheet: sheet, startrow: 41, heading: 'Зсм - затраты на смазочные материалы', data: [
        [
          '0,1',
          'расходы на смазочные - 10% от стоимости диз.топлива',
          0.1,
        ],
        [
          'Зт',
          'Затраты на автомобильное топливо',
          zt,
        ],
        [
          'фор(7)',
          'Зсм=3т х0,1 ',
          zsm,
        ]
      ]);

      table(sheet: sheet, startrow: 46, heading: 'Зрт - Затраты на проведение ремонтов и технического обслуживания', data: [
        [
          'Крт',
          'расходы на проведение ремонтов и Т/О автобусов принимаются как 20% от стоимости авто',
          0.2,
        ],
        [
          'Ам',
          'количество автобусов в день на маршруте по графику',
          am.text.toString(),
        ],
        [
          'Кр',
          'коэф. резерва автобуса принимаемый на уровне 1,2',
          1.2,
        ],
        [
          'Ц',
          'Средняя стоимость 1 автобуса из закрепленных на маршруте, в тенге',
          ts.text.toString(),
        ],
        [
          'фор(8)',
          'Зрт= Крт х Ам х Кр х Ц ',
          zrt,
        ],
      ]);

      table(sheet: sheet, startrow: 53, heading: 'Зш- Затраты на автошины', data: [
        [
          'Lоб',
          'общий годовой пробег автобусов при обслуживании маршрута',
          lob,
        ],
        [
          'Цш',
          'закупочная цена одного комплекта шин (шина, камера,ободная лента) в тенге на момент расчета.с  НДС',
          tssh.text.toString(),
        ],
        [
          'm',
          'количество колес на автобусе (без запасного колеса)',
          m.text.toString(),
        ],
        [
          'Ш',
          'эксплуатационная норма пробега автошины, определяется в соответствии с Нормами расхода топлива, в км',
          sh.text.toString(),
        ],
        [
          'Кш',
          'коэффициент корректировки эксплуатационных норм пробега автошин, определяется в соответствии с Нормами расходатоплива;',
          ksh.text.toString(),
        ],
        [
          'фор(9)',
          'Зш=Цш х m х Lоб/(Ш х Кш) =',
          zsh,
        ]
      ]);

      table(sheet: sheet, startrow: 61, heading: 'Ззп - Затраты на зарплату', data: [
        [
          'Мр',
          'количество месяцев обслуживания маршрута в году',
          mp.text.toString(),
        ],
        [
          'Zв',
          'месячная зарплата водителя',
          zb.text.toString(),
        ],
        [
          'Nв',
          'количество водителей',
          nb.text.toString(),
        ],
        [
          'Zк',
          'месячная зарплата кондуктора',
          zk.text.toString(),
        ],
        [
          'Nк',
          'количество кондукторов',
          nk.text.toString(),
        ],
        [
          'Ам',
          'количество автобусов на маршруте ',
          am.text.toString(),
        ],
        [
          'K',
          'коэфициент учитывающий соц.налог составляет 12,5%',
          k.text.toString(),
        ],
        [
          '1,2',
          'поправочный кооф., учит.начисл.работников',
          1.2,
        ],
        [
          'фор(10)',
          'ЗЗП=(Мр х (Zв х Nв + Zк х Nк) х Ам х К)х1,2 =',
          zzp,
        ],
      ]);

      table(sheet: sheet, startrow: 72, heading: 'Зн - Нормативная сумма накладных затрат', data: [
        [
          '0,2',
          'накладные расходы не должны превышат 20% от прямых расходов',
          0.2,
        ],
        [
          'Зт',
          'Затраты на автомобильное топливо с НДС',
          zt,
        ],
        [
          'Зсм',
          'Затраты на смазочные материалы',
          zsm,
        ],
        [
          'Зрт',
          'Затраты на проведение ремонтов и Т/О',
          zrt,
        ],
        [
          'Зш',
          'Затраты на автошины',
          zsh,
        ],
        [
          'Ззп',
          'Затраты на зарплату',
          zzp,
        ],
        [
          'фор(11)',
          'Зн=0,2 х Зп =',
          zn,
        ]
      ]);

      table(sheet: sheet, startrow: 81, heading: ' Зп - Общая сумма прямых затрат на обслуживания маршрута', data: [
        [
          '',
          'Зп= Зт+Зсм+Зрт+Зш+Ззп=',
          zp,
        ]
      ]);

      table(sheet: sheet, startrow: 84, heading: 'CM - Стоимость  маршрута', data: [
        [
          'Зпс',
          'общая сумма нормативных затрат перевозчика на приобретение подвижного состава',
          zps,
        ],
        [
          'Зп',
          'общая сумма прямых  затрат перевозчика ',
          zp,
        ],
        [
          'Зн',
          'общая сумма нормативных  накладных затрат перевозчика ',
          zn,
        ],
        [
          'R',
          'коэффициент расчетной рентабельности к затратам перевозчика (принимается как 15%)',
          1.15,
        ],
        [
          'Кндс',
          'коэффициент налога на добавленную стоимость равный 1, (принимается как 12%)',
          knds.text.toString(),
        ],
        [
          'фор(1)',
          'СМ=(Зпс+(Зп+Зн) х R)х Кндс =',
          sm,
        ],
        [
          '',
          'Стоимость 1 км',
          sm / lob,
        ]
      ]);
      /*sheet.cell(Exl.CellIndex.indexByString('B3')).cellStyle = Exl.CellStyle(
        topBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        bottomBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thin),
      );*/
      // ByteData data = await rootBundle.load('sheet_template.xlsx');
      // var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // var excel = Excel.decodeBytes(bytes);
      eName = '${(DateFormat('dd.MM.yy').format(DateTime.now()))}.xlsx';
      excel.save(fileName: eName);
      setState(() {
        isActive = true;
      });
    }
  }

  table({
    required Exl.Sheet sheet,
    required int startrow,
    required String heading,
    required List<List<dynamic>> data,
  }) {
    sheet.merge(
        Exl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startrow),
        Exl.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: startrow));
    sheet.cell(
        Exl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startrow))
      ..value = heading
      ..cellStyle = Exl.CellStyle(
        bold: true,
        textWrapping: Exl.TextWrapping.WrapText,
        horizontalAlign: Exl.HorizontalAlign.Center,
        verticalAlign: Exl.VerticalAlign.Center,
        backgroundColorHex: '#808080',
        fontColorHex: '#FFFFFF',
      );
    sheet.cell(
        Exl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startrow + 1))
      ..value = 'Значение'
      ..cellStyle = Exl.CellStyle(
        horizontalAlign: Exl.HorizontalAlign.Center,
        verticalAlign: Exl.VerticalAlign.Center,
        textWrapping: Exl.TextWrapping.WrapText,
        backgroundColorHex: '#D9D9D9',
        topBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        rightBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        bottomBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        leftBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
      );
    sheet.cell(
        Exl.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startrow + 1))
      ..value = 'Значение буквы в формуле'
      ..cellStyle = Exl.CellStyle(
        horizontalAlign: Exl.HorizontalAlign.Center,
        verticalAlign: Exl.VerticalAlign.Center,
        textWrapping: Exl.TextWrapping.WrapText,
        backgroundColorHex: '#D9D9D9',
        topBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        rightBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        bottomBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        leftBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
      );
    sheet.cell(
        Exl.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: startrow + 1))
      ..value = 'Цифра'
      ..cellStyle = Exl.CellStyle(
        horizontalAlign: Exl.HorizontalAlign.Center,
        verticalAlign: Exl.VerticalAlign.Center,
        textWrapping: Exl.TextWrapping.WrapText,
        backgroundColorHex: '#D9D9D9',
        topBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        rightBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        bottomBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
        leftBorder: Exl.Border(borderStyle: Exl.BorderStyle.Thick),
      );
    startrow++;
    for (List<dynamic> row in data) {
      sheet.cell(Exl.CellIndex.indexByColumnRow(
          columnIndex: 0, rowIndex: startrow + 1))
        ..value = row[0]
        ..cellStyle = Exl.CellStyle(
          horizontalAlign: Exl.HorizontalAlign.Center,
          verticalAlign: Exl.VerticalAlign.Center,
          textWrapping: Exl.TextWrapping.WrapText,
          backgroundColorHex: '#D9D9D9',
          topBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          rightBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          bottomBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          leftBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
        );
      sheet.cell(Exl.CellIndex.indexByColumnRow(
          columnIndex: 1, rowIndex: startrow + 1))
        ..value = row[1]
        ..cellStyle = Exl.CellStyle(
          horizontalAlign: Exl.HorizontalAlign.Center,
          verticalAlign: Exl.VerticalAlign.Center,
          textWrapping: Exl.TextWrapping.WrapText,
          backgroundColorHex: '#D9D9D9',
          topBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          rightBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          bottomBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          leftBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
        );
      sheet.cell(Exl.CellIndex.indexByColumnRow(
          columnIndex: 2, rowIndex: startrow + 1))
        ..value = row[2] == 0 ? '' : row[2]
        ..cellStyle = Exl.CellStyle(
          horizontalAlign: Exl.HorizontalAlign.Center,
          verticalAlign: Exl.VerticalAlign.Center,
          textWrapping: Exl.TextWrapping.WrapText,
          backgroundColorHex: '#D9D9D9',
          topBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          rightBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          bottomBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
          leftBorder: Exl.Border(
              borderStyle: Exl.BorderStyle.Thick, borderColorHex: '#A6A6A6'),
        );
      startrow++;
    }
  }

  // text editing controllers
  final busNum = TextEditingController();

  final sprem = TextEditingController();

  final sts = TextEditingController();

  final N = TextEditingController();

  final rud = TextEditingController();

  final ats = TextEditingController();

  final am = TextEditingController();

  final ts = TextEditingController();

  final kr = TextEditingController();

  final nt = TextEditingController();

  final kn = TextEditingController();

  final tst = TextEditingController();

  final n = TextEditingController();

  final lkr = TextEditingController();

  final lo = TextEditingController();

  final krt = TextEditingController();

  final tssh = TextEditingController();

  final m = TextEditingController();

  final sh = TextEditingController();

  final ksh = TextEditingController();

  final mp = TextEditingController();

  final zb = TextEditingController();

  final nb = TextEditingController();

  final zk = TextEditingController();

  final nk = TextEditingController();

  final k = TextEditingController();

  final r = TextEditingController();

  final knds = TextEditingController();

  // sign user in method
  void signUserIn() {}

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                FirebaseAuth.instance.signOut();

                              },
                              icon: Icon(Icons.logout)),
                          SizedBox(width: 10,),
                          IconButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => list()),
                              );

                            },
                            icon: Icon(Icons.history, color: Colors.black,),

                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),

                  // logo
                  Icon(Icons.directions_bus_rounded, size:200),

                  const SizedBox(height: 0),

                  // welcome back, you've been missed!
                  Text(
                    'Добро пожаловать, ${user.email} ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),
                  Field(
                    text: "Номер маршрута",
                    controller: busNum,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Размер годовой страховой премии,согласно ГК РК",
                    controller: sprem,
                    needToValidate: false,
                  ),
                  Field(
                    text:
                        "Среднерыночная стоимость одного транспортного средства",
                    controller: sts,
                    needToValidate: false,
                  ),
                  Field(
                    text: "Срок контракта лизинга",
                    controller: N,
                    needToValidate: false,
                  ),
                  Field(
                    text: "Ставка лизингового процента по контракту",
                    controller: rud,
                    needToValidate: false,
                  ),
                  Field(
                    text:
                        "Размер авансового платежа по контракту лизинга (процентная ставка от стоимости транспортного средства).",
                    controller: ats,
                    needToValidate: false,
                  ),
                  Field(
                    text: "Количество автобусов в день на маршруте по графику",
                    controller: am,
                    needToValidate: true,
                  ),
                  /*Field(
                    text: "Норма амортизации по автотранспорту в размере 15%",
                    controller: pr015,
                    needToValidate: true,
                  ),*/
                  Field(
                    text:
                        "Стоимость 1 автобуса из закрепленных на маршруте, в тенге",
                    controller: ts,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Коэф. резерва автобуса принимаемый на уровне 1,2",
                    controller: kr,
                    needToValidate: true,
                  ),
                  Field(
                    text:
                        "Базовая норма расхода топлива на 100 км (ПП РК от 11.08.2009 г.№1210)",
                    controller: nt,
                    needToValidate: true,
                  ),
                  Field(
                    text:
                        "Совокупный коэффициент надбавок к базавой норме для реальных условий работы автобусов на маршруте, определяется в соответствии с Нормами расхода топлива.",
                    controller: kn,
                    needToValidate: true,
                  ),
                  Field(
                    text:
                        "Средняя годовая розничная стоимость 1 литра топлива в тенге с НДС на дату расчета тарифа с учетом использования летнего и зимнего видов топлива( Цт=Цз.т.*7+Цл.т.*5/12) фор (6)  (260*7+345*5/12)",
                    controller: tst,
                    needToValidate: true,
                  ),
                  /*Field(
                    text: "пересчет расхода топлива со 100 км на 1 км",
                    controller: pr001,
                    needToValidate: true,
                  ),*/
                  Field(
                    text:
                        "Ежедневное количество кругорейсов на маршруте ( 8,2 кругов * 10 машин)",
                    controller: n,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Протяженность кругорейса на маршруте в км ",
                    controller: lkr,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Ежедневный нулевой пробег, км (15 км* 10 машин) ",
                    controller: lo,
                    needToValidate: true,
                  ),
                  /*Field(
                    text: "расходы на смазочные - 10% от стоимости диз.топлива",
                    controller: pr01,
                    needToValidate: true,
                  ),*/
                  Field(
                    text:
                        "Расходы на проведение ремонтов и Т/О автобусов принимаются как 20% от стоимости авто",
                    controller: krt,
                    needToValidate: true,
                  ),
                  Field(
                    text:
                        "Закупочная цена одного комплекта шин (шина, камера,ободная лента) в тенге на момент расчета.с  НДС",
                    controller: tssh,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Количество колес на автобусе (без запасного колеса)",
                    controller: m,
                    needToValidate: true,
                  ),
                  Field(
                    text:
                        "Эксплуатационная норма пробега автошины, определяется в соответствии с Нормами расхода топлива, в км",
                    controller: sh,
                    needToValidate: true,
                  ),
                  Field(
                    text:
                        "Коэффициент корректировки эксплуатационных норм пробега автошин, определяется в соответствии с Нормами расходатоплива;",
                    controller: ksh,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Количество месяцев обслуживания маршрута в году",
                    controller: mp,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Месячная зарплата водителя",
                    controller: zb,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Количество водителей",
                    controller: nb,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Месячная зарплата кондуктора",
                    controller: zk,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Количество кондукторов",
                    controller: nk,
                    needToValidate: true,
                  ),
                  Field(
                    text: "Коэфициент учитывающий соц.налог составляет 12,5%",
                    controller: k,
                    needToValidate: true,
                  ),
                  /*Field(
                    text: "поправочный кооф., учит.начисл.работников",
                    controller: koof12,
                    needToValidate: true,
                  ),*/
                  /*Field(
                    text:
                        "накладные расходы не должны превышат 20% от прямых расходов",
                    controller: pr02,
                    needToValidate: true,
                  ),*/
                  Field(
                    text:
                        "Коэффициент расчетной рентабельности к затратам перевозчика (принимается как 15%)",
                    controller: r,
                    needToValidate: true,
                  ),
                  Field(
                    text:
                        "Коэффициент налога на добавленную стоимость равный 1, (принимается как 12%)",
                    controller: knds,
                    needToValidate: true,
                  ),
                  SizedBox(height: 10,),

                  // sign in button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        onTap: calc,
                        formKey: _formKey,
                      ),
                      SizedBox(width: 20,),
                      MyButton1(onTap: addSto, text: 'Добавить в историю', isActive: isActive)
                    ],
                  ),
                  SizedBox(height: 20,),

                  // not a member? register now
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
