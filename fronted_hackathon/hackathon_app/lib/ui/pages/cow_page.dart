import 'package:flutter/material.dart';
import 'package:hackathon_app/domain/models/cow.dart';
import 'package:hackathon_app/ui/config/color_palette.dart';
import 'package:hackathon_app/ui/widgets/button_widget.dart';

import '../widgets/custom_card_widget.dart';
import 'cow_information_page.dart';

class CowPage extends StatelessWidget {
  int idCastle;
  CowPage({required this.idCastle});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      floatingActionButton: Container(
        width: size.width,
       
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonWidget(
                text: "Seleccionar",
                size: Size(size.width / 3.2, 20),
                color: Colors.blue.shade400,
                rounded: 20,
                function: () {},
                fontSize: 14),
            ButtonWidget(
                text: "Crear vaca",
                size: Size(size.width / 3.2, 20),
                color: ColorPalette.colorPrincipal,
                rounded: 20,
                function: () {},
                fontSize: 14),
            ButtonWidget(
                text: "Crear toro",
                size: Size(size.width / 3.2, 20),
                color: ColorPalette.colorPrincipal,
                rounded: 20,
                function: () {},
                fontSize: 14)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  height: 35,
                  child: const SearchBar(
                    elevation: MaterialStatePropertyAll<double?>(0),
                    leading: Icon(
                      Icons.search,
                      color: Color(0xffABA5A5),
                    ),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Color(0xFFf2f2f2)),
                  )),
              SizedBox(
                width: size.width,
                height: size.height - 35,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomCardWdiget(
                        function: () =>cowInformationPage(context, Cow(idCow: 2)),
                        const [
                          "Reyna",
                          "4 años",
                        ],
                        urlImage: "",
                        title: "Vaca",
                        description:
                            "Ultima vacuna: 00:00:00 \n ultima desparasitacion: 00:00:00 \n Peso: 262kg",
                        radius: 12)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));

  }
  void cowInformationPage(BuildContext context, Cow cow){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CowInformationPage(cow: cow);
    },));
  }
}
