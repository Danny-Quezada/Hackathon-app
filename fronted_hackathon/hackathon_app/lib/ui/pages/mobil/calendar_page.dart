import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hackathon_app/app_core/services/notification_services.dart';
import 'package:hackathon_app/ui/config/color_palette.dart';
import 'package:hackathon_app/ui/util/meeting_data_source.dart';
import 'package:hackathon_app/ui/util/validator_textfield.dart';
import 'package:hackathon_app/ui/widgets/button_widget.dart';
import 'package:hackathon_app/ui/widgets/custom_form_field.dart';
import 'package:hackathon_app/ui/widgets/time_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import "dart:math" as math;

PersistentBottomSheetController? _controller;
MeetingDataSource? meetingDataSource = MeetingDataSource([]);
final globalKey = GlobalKey<ScaffoldState>();

class CalendarPage extends StatelessWidget {
  String CattleId;
  CalendarPage({required this.CattleId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      key: globalKey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 10, top: 10, left: 10),
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: SfCalendar(
                view: CalendarView.month,
                blackoutDates: [
                  DateTime.now().add(Duration(days: -30)),
                ],
                onLongPress: (calendarLongPressDetails) {
                  // if ((calendarLongPressDetails.date!)
                  //     .isAfter(DateTime.now())) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      content: AddReminder(
                          CattleId: CattleId,
                          dateTime: calendarLongPressDetails.date!),
                    ),
                  );
                  //}
                },
                onTap: (calendarTapDetails) {},
                initialDisplayDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
                allowedViews: [CalendarView.schedule, CalendarView.month],
                dataSource: meetingDataSource,
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  showAgenda: true,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

final _formKey = GlobalKey<FormState>();

class AddReminder extends StatelessWidget {
  NotificationService notificationService = NotificationService();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  FocusNode titleNode = FocusNode();
  FocusNode descriptionNode = FocusNode();
  String CattleId;
  DateTime dateTime;
  TimeOfDay? timeOfDay = TimeOfDay.now();
  AddReminder({required this.CattleId, required this.dateTime});

  Future<void> createNotification(context) async {
    await notificationService.showNotification(
      0,
      titleController.text,
      "Se ha creado un nuevo recordatorio",
      jsonEncode({
        "title": titleController.text,
        "eventDate": DateFormat("EEEE, d MMM y").format(dateTime),
        "eventTime": timeOfDay!.format(context),
      }),
    );

    await notificationService.scheduleNotification(
        1,
        titleController.text,
        "Recuerda esto: ${titleController.text} a las ${timeOfDay!.format(context)}",
        dateTime!,
        timeOfDay!,
        jsonEncode({
          "title": titleController.text + " Vaca: ${CattleId}",
          "eventDate": DateFormat("EEEE, d MMM y").format(dateTime!),
          "eventTime": timeOfDay!.format(context),
          "CattleId": CattleId
        }),
        DateTimeComponents.dayOfWeekAndTime);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SizedBox(
        height: size.height * .50,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                  textEditingController: titleController,
                  validator: ValidatorTextField.genericStringValidator,
                  nextFocusNode: descriptionNode,
                  focusNode: titleNode,
                  hintText: "Poner vacuna a ${CattleId}",
                  labelText: "Título",
                  obscureText: false),
              SizedBox(
                height: 200,
                child: CustomFormField(
                  textEditingController: descriptionController,
                  validator: ValidatorTextField.genericStringValidator,
                  nextFocusNode: null,
                  focusNode: descriptionNode,
                  hintText: "Se debe de poner...",
                  labelText: "Descripción",
                  obscureText: false,
                  border: false,
                ),
              ),
              TimePicker(
                  color: Colors.grey.shade400,
                  size: const Size(269, 36),
                  timeController: timeController),
              const SizedBox(
                height: 35,
              ),
              Center(
                  child: ButtonWidget(
                      text: "Agregar",
                      size: Size(250, 60),
                      color: ColorPalette.colorPrincipal,
                      rounded: 25,
                      function: () async {
                        final FormState form = _formKey.currentState!;
                        if (form.validate()) {
                          timeOfDay =timeController.text.isEmpty?  TimeOfDay.fromDateTime(DateTime.now())  : fromString(timeController.text);
                          final app = Meeting(
                              titleController.text,
                              dateTime,
                              dateTime,
                              Colors.primaries[math.Random()
                                  .nextInt(Colors.primaries.length)],
                              false);
                          meetingDataSource!.appointments!.add(app);
                          meetingDataSource!.notifyListeners(
                              CalendarDataSourceAction.add, <Meeting>[app]);
                          createNotification(context);
                          Navigator.pop(context);
                        }
                      },
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
  TimeOfDay fromString(String time) {
  int hh = 0;
  if (time.endsWith('PM')) hh = 12;
  time = time.split(' ')[0];
  return TimeOfDay(
    hour: hh + int.parse(time.split(":")[0]) % 24, // in case of a bad time format entered manually by the user
    minute: int.parse(time.split(":")[1]) % 60,
  );
}
}