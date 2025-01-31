import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_provider_utilities/flutter_provider_utilities.dart';
import 'package:hackathon_app/infraestructure/repository/treatment_repository.dart';
import 'package:hackathon_app/provider/meditation_provider.dart';
import 'package:hackathon_app/provider/treatment_provider.dart';
import 'package:hackathon_app/ui/pages/mobil/calendar_page.dart';
import 'package:hackathon_app/ui/pages/mobil/qr_generate_page.dart';
import 'package:hackathon_app/ui/widgets/datetime_picker_widget.dart';
import 'package:hackathon_app/ui/widgets/flushbar_widget.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/Entities/cattle.dart';
import '../../../domain/models/Entities/treatment.dart';
import '../../../domain/models/enums/pharmaceuticals.dart';
import '../../config/color_palette.dart';
import '../../util/validator_textfield.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_form_field.dart';
import '../../widgets/pills_widget.dart';
import '../../widgets/rich_text_widget.dart';

String value = "Todo";

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
PersistentBottomSheetController? _controller;

class CowInformationPage extends StatelessWidget {
  Cattle cattle;
  int IdFarm;
  CowInformationPage({super.key, required this.cattle, required this.IdFarm});

  @override
  Widget build(BuildContext context) {
    final treatmentProvider =
        Provider.of<TreatmentProvider>(context, listen: false);
    treatmentProvider.doNull();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (_controller != null) {
            _controller!.close();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              Container(
                color: Colors.grey.shade100,
                width: size.width,
                height: size.height * .3,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  width: size.width,
                  height: size.height * .8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          backgroundColor:
                              Colors.grey.shade100.withOpacity(0.8),
                          radius: size.width * .2,
                          child:
                              Image.asset("assets/images/sections/image.png"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Identificador",
                          style: TextStyle(
                              fontFamily: "Karla", fontWeight: FontWeight.bold),
                        ),
                        Text(
                          cattle.idCattle.toString(),
                          style: TextStyle(
                              color: ColorPalette.colorFontTextFieldPrincipal,
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OptionMenu(
                          cattle: cattle,
                          IdFarm: IdFarm,
                        ),
                        ListMedical(
                          cattleId: cattle.idCattle,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListMedical extends StatelessWidget {
  String cattleId;
  ListMedical({required this.cattleId});

  @override
  Widget build(BuildContext context) {
    final treatmentProvider =
        Provider.of<TreatmentProvider>(context, listen: false);
    treatmentProvider.getTreatmentByCattle(cattleId, value);
    Size size = MediaQuery.of(context).size;
    return MessageListener<TreatmentProvider>(
      child: Consumer<TreatmentProvider>(
        builder: (context, TreatmentProviderConsumer, child) {
          if (treatmentProvider.list == null) {
            return Container();
          }
          return SizedBox(
              width: size.width,
              height: size.height * 0.5,
              child: ListView.builder(
                  padding: const EdgeInsets.all(15),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: treatmentProvider.list?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Selector<TreatmentProvider, Treatment>(
                      builder: (context, treatment, child) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: PillWidget(treatment.dosis.toInt(),
                              pharmaceuticals:
                                  stringToPharmaceuticals(treatment.type),
                              title: treatment.aplicationArea!,
                              function: () {}),
                        );
                      },
                      selector: (p0, p1) => treatmentProvider.list![index],
                    );
                  }));
        },
      ),
      showInfo: (info) {
        flushbarWidget(context: context, title: "Enhorabuena", message: info);
      },
      showError: (error) {
        flushbarWidget(
            context: context, title: "Error", message: error, error: false);
      },
    );
  }

  Pharmaceuticals stringToPharmaceuticals(String cadena) {
    switch (cadena) {
      case 'Medicamentos':
        return Pharmaceuticals.Medicamentos;
      case 'Vitaminas':
        return Pharmaceuticals.Vitaminas;
      case 'Vacunas':
        return Pharmaceuticals.Vacunas;
      default:
        throw ArgumentError('Unknown Pharmaceuticals value: $value');
    }
  }

  _showDetailsTreatment(Treatment treatment, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(treatment.meditationName!),
                RichTextWidget(
                    title: "Día: ",
                    content: DateFormat('hh:mm:ss').format(treatment.date!)),
                RichTextWidget(
                    title: "Dosis", content: treatment.dosis.toString()),
                RichTextWidget(
                  title: "Área: ",
                  content: treatment.aplicationArea,
                ),
                const Text("Observaciones",
                    style: TextStyle(color: Colors.red)),
                Text(treatment.observation)
              ],
            ),
          ),
        );
      },
    );
  }
}

class OptionMenu extends StatefulWidget {
  Cattle cattle;
  int IdFarm;
  OptionMenu({required this.cattle, required this.IdFarm});

  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(12),
                border: Border.all(color: Colors.grey.shade100, width: 2)),
            child: DropdownButton(
              items: const [
                DropdownMenuItem(
                  child: Text("Todo"),
                  value: "Todo",
                ),
                DropdownMenuItem(
                  child: Text("Medicamentos"),
                  value: "Medicamentos",
                ),
                DropdownMenuItem(
                  child: Text("Vitaminas"),
                  value: "Vitaminas",
                ),
                DropdownMenuItem(child: Text("Vacunas"), value: "Vacunas"),
              ],
              style:
                  TextStyle(color: Colors.grey.shade400, fontFamily: "Karla"),
              underline: Container(),
              value: value,
              elevation: 5,
              onChanged: (valuee) {
                setState(() {
                  value = valuee!;
                });
              },
            ),
          ),
          IconButton(
              onPressed: () {
                calendarPage(context, widget.cattle.idCattle, widget.IdFarm);
              },
              icon: Image.asset("assets/images/icons/calendar.png")),
          IconButton(
              onPressed: () {},
              icon: Image.asset("assets/images/icons/cowFamily.png")),
          IconButton(
              onPressed: () {
                _controller = _scaffoldKey.currentState!.showBottomSheet(
                    backgroundColor: Colors.white,
                    (context) => addTreatmentBottomSheet(
                          cattleId: widget.cattle.idCattle,
                          IdFarm: widget.IdFarm,
                        ));
              },
              icon: Image.asset("assets/images/icons/greenPlus.png")),
                IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return QRGeneratePage(cattleId: widget.cattle.idCattle);
                  },
                ));
              },
              icon: Icon(
                Icons.qr_code_2,
                size: 35,
              ))
        ],
      ),
    );
  }

  void calendarPage(BuildContext context, String cattleId, int IdFarm) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return CalendarPage(
          CattleId: cattleId,
          IdFarm: IdFarm,
        );
      },
    ));
  }
}

class addTreatmentBottomSheet extends StatefulWidget {
  String cattleId;
  String type = "Vacunas";
  int IdFarm;
  addTreatmentBottomSheet({required this.cattleId, required this.IdFarm});

  @override
  State<addTreatmentBottomSheet> createState() =>
      _addTreatmentBottomSheetState();
}

class _addTreatmentBottomSheetState extends State<addTreatmentBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController dosisController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  FocusNode dosisNode = FocusNode();

  FocusNode areaNode = FocusNode();

  FocusNode observationNode = FocusNode();
  String value = "Vacunas";
  int? IdMedicamento;

  @override
  Widget build(BuildContext context) {
    var treatmentProvider =
        Provider.of<TreatmentProvider>(context, listen: false);
    return Form(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormField(
                textInput: TextInputType.number,
                textEditingController: dosisController,
                validator: ValidatorTextField.genericStringValidator,
                nextFocusNode: areaNode,
                focusNode: dosisNode,
                hintText: "",
                labelText: "Dósis",
                obscureText: false),
            CustomFormField(
                textEditingController: areaController,
                validator: ValidatorTextField.genericStringValidator,
                nextFocusNode: observationNode,
                focusNode: areaNode,
                hintText: "Detrás del hombro",
                labelText: "Área de aplicación",
                obscureText: false),
            CustomFormField(
                textEditingController: observationController,
                validator: ValidatorTextField.genericDecimalValidator,
                nextFocusNode: null,
                focusNode: observationNode,
                hintText: "Molestias en la parte de la aplicación",
                labelText: "Observación",
                obscureText: false),
            DateTimePicker(
              text: "Fecha",
              size: const Size(275, 31),
              dateTimeController: dateController,
              color: ColorPalette.colorFontTextFieldPrincipal,
            ),
            DropdownButton(
              items: const [
                DropdownMenuItem(
                  child: Text("Medicamentos"),
                  value: "Medicamentos",
                ),
                DropdownMenuItem(
                  child: Text("Vitaminas"),
                  value: "Vitaminas",
                ),
                DropdownMenuItem(child: Text("Vacunas"), value: "Vacunas"),
              ],
              style:
                  TextStyle(color: Colors.grey.shade400, fontFamily: "Karla"),
              underline: Container(),
              value: value,
              elevation: 5,
              onChanged: (valuee) {
                setState(() {
                  value = valuee!;
                  widget.type = valuee!;
                });
              },
            ),
            ButtonWidget(
              color: const Color(0xFFCA78FF),
              fontSize: 16,
              size: const Size(170, 31),
              function: () async {
                IdMedicamento = await _mostrarMedicamentos(context);
              },
              rounded: 12,
              text: "Elegir fármaco",
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: ButtonWidget(
                  text: "Agregar tratamiento",
                  size: const Size(250, 55),
                  color: Colors.green.shade200,
                  rounded: 16,
                  function: () async {
                    Treatment treatment = Treatment(
                        cattleId: widget.cattleId,
                        meditationId: IdMedicamento.toString(),
                        date: DateTime.parse(dateController.text),
                        type: widget.type,
                        dosis: double.parse(dosisController.text),
                        observation: observationController.text,
                        aplicationArea: areaController.text);
                    await treatmentProvider.create(treatment);
                  },
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Future<int?> _mostrarMedicamentos(BuildContext context) async {
    final meditationProvider =
        Provider.of<MeditationProvider>(context, listen: false);
    meditationProvider.getAllFarmByUserId(widget.IdFarm);
    return showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Medicamentos',
              style: TextStyle(
                fontFamily: "Karla",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: Consumer<MeditationProvider>(
              builder: (context, MeditationProviderConsumer, child) {
                if (meditationProvider.list == null) {
                  return Container();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: meditationProvider.list?.length ?? 0,
                  itemBuilder: (BuildContext context, index) {
                    if (meditationProvider.list != null &&
                        meditationProvider.list!.length > 0) {
                      return ListTile(
                        title: Text(
                          meditationProvider.list?[index].meditationName
                              as String,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontFamily: "Karla",
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(
                              meditationProvider.list?[index].meditationId);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
