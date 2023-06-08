import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tensai3/needs.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
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
  calc(){
    za = 0.15 * double.parse(am.text) * double.parse(kr.text) * double.parse(ts.text);
    if(lgod==null && sprem==null){
      zps = za;
      lgod = 0;
    }
    else{
      zps = lgod+double.parse(sprem.text);
      lgod = ((double.parse(sts.text)*(1+double.parse(N.text)*double.parse(rud.text))-double.parse(sts.text)*double.parse(ats.text))/double.parse(N.text))*double.parse(am.text)*0.8;
    }
    lob = 365 * (double.parse(n.text)*double.parse(lkr.text)+double.parse(lo.text));
    zt = 0.01 * lob * double.parse(nt.text) * double.parse(kn.text) * double.parse(tst.text);
    zsm = zt * double.parse(pr01.text);
    zrt = double.parse(krt.text) * double.parse(am.text) * double.parse(kr.text) * double.parse(ts.text);
    zsh = double.parse(tssh.text) * double.parse(m.text) * lob/(double.parse(sh.text)*double.parse(ksh.text));
    zzp = (double.parse(mp.text)*(double.parse(zb.text) * double.parse(nb.text)+double.parse(zk.text)*double.parse(nk.text))*double.parse(am.text)*double.parse(k.text))*1.2;
    zp = zt + zsm + zrt + zsh + zzp;
    zn = 0.2*zp;
    sm = (zps + (zp+ zn)*double.parse(r.text)) * double.parse(knds.text);
  }
  // text editing controllers
  final sprem = TextEditingController();
  final sts = TextEditingController();
  final N = TextEditingController();
  final rud = TextEditingController();
  final ats = TextEditingController();
  final am = TextEditingController();
  final pr015 = TextEditingController();
  final ts = TextEditingController();
  final kr = TextEditingController();
  final nt = TextEditingController();
  final kn = TextEditingController();
  final tst = TextEditingController();
  final pr001 = TextEditingController();
  final n = TextEditingController();
  final lkr = TextEditingController();
  final lo = TextEditingController();
  final pr01 = TextEditingController();
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
  final koof12 = TextEditingController();
  final pr02 = TextEditingController();
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
                  const SizedBox(height: 50),

                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),
                  Field(text: "Размер годовой страховой премии,согласно ГК РК", controller: sprem, needToValidate: false,),
                  Field(text: "среднерыночная стоимость одного транспортного средства", controller: sts, needToValidate: false,),
                  Field(text: "срок контракта лизинга", controller: N,needToValidate: false,),
                  Field(text: "ставка лизингового процента по контракту", controller: rud,needToValidate: false,),
                  Field(text: "размер авансового платежа по контракту лизинга (процентная ставка от стоимости транспортного средства).", controller: ats,needToValidate: false,),
                  Field(text: "количество автобусов в день на маршруте по графику", controller: am,needToValidate: true,),
                  Field(text: "Норма амортизации по автотранспорту в размере 15%", controller: pr015,needToValidate: true,),
                  Field(text: "Стоимость 1 автобуса из закрепленных на маршруте, в тенге", controller: ts,needToValidate: true,),
                  Field(text: "коэф. резерва автобуса принимаемый на уровне 1,2", controller: kr,needToValidate: true,),
                  Field(text: "базовая норма расхода топлива на 100 км (ПП РК от 11.08.2009 г.№1210)", controller: nt,needToValidate: true,),
                  Field(text: "совокупный коэффициент надбавок к базавой норме для реальных условий работы автобусов на маршруте, определяется в соответствии с Нормами расхода топлива.", controller: kn,needToValidate: true,),
                  Field(text: "средняя годовая розничная стоимость 1 литра топлива в тенге с НДС на дату расчета тарифа с учетом использования летнего и зимнего видов топлива( Цт=Цз.т.*7+Цл.т.*5/12) фор (6)  (260*7+345*5/12)", controller: tst,needToValidate: true,),
                  Field(text: "пересчет расхода топлива со 100 км на 1 км", controller: pr001,needToValidate: true,),
                  Field(text: "ежедневное количество кругорейсов на маршруте ( 8,2 кругов * 10 машин)", controller: n,needToValidate: true,),
                  Field(text: "протяженность кругорейса на маршруте в км ", controller: lkr,needToValidate: true,),
                  Field(text: "ежедневный нулевой пробег, км (15 км* 10 машин) ", controller: lo,needToValidate: true,),
                  Field(text: "расходы на смазочные - 10% от стоимости диз.топлива", controller: pr01,needToValidate: true,),
                  Field(text: "расходы на проведение ремонтов и Т/О автобусов принимаются как 20% от стоимости авто", controller: krt,needToValidate: true,),
                  Field(text: "закупочная цена одного комплекта шин (шина, камера,ободная лента) в тенге на момент расчета.с  НДС", controller: tssh,needToValidate: true,),
                  Field(text: "количество колес на автобусе (без запасного колеса)", controller: m,needToValidate: true,),
                  Field(text: "эксплуатационная норма пробега автошины, определяется в соответствии с Нормами расхода топлива, в км", controller: sh,needToValidate: true,),
                  Field(text: "коэффициент корректировки эксплуатационных норм пробега автошин, определяется в соответствии с Нормами расходатоплива;", controller: ksh,needToValidate: true,),
                  Field(text: "количество месяцев обслуживания маршрута в году", controller: mp,needToValidate: true,),
                  Field(text: "месячная зарплата водителя", controller: zb,needToValidate: true,),
                  Field(text: "количество водителей", controller: nb,needToValidate: true,),
                  Field(text: "месячная зарплата кондуктора", controller: zk,needToValidate: true,),
                  Field(text: "количество кондукторов", controller: nk,needToValidate: true,),
                  Field(text: "коэфициент учитывающий соц.налог составляет 12,5%", controller: k,needToValidate: true,),
                  Field(text: "поправочный кооф., учит.начисл.работников", controller: koof12,needToValidate: true,),
                  Field(text: "накладные расходы не должны превышат 20% от прямых расходов", controller: pr02,needToValidate: true,),
                  Field(text: "коэффициент расчетной рентабельности к затратам перевозчика (принимается как 15%)", controller: r,needToValidate: true,),
                  Field(text: "коэффициент налога на добавленную стоимость равный 1, (принимается как 12%)", controller: knds,needToValidate: true,),

                  // sign in button
                  MyButton(
                    formKey: _formKey,
                  ),

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