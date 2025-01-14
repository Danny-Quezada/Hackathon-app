class Constant {
  static const String route = "http://192.168.1.24:5000/api";
  static const String createUser = "${route}/Usuario/";
  static const String getUser = "${route}/Usuario/verificar";
  static const String userChangeState = "${route}/Usuario/estado";

  static const String createFarm = "${route}/Finca";
  static const String getFarms = "${route}/Finca/Usuario";
  static const String inviteFarm = "${route}/Finca/invitacion";

  static const String createGroup = "${route}/Grupo";
  static const String getGroups = "${route}/Grupo/Finca";

  static const String getTreatmentByUser = "${route}/Tratamiento/Usuario";
  static const String createTreatment = "${route}/Tratamiento";
  static const String getTreatmentByCattle = "${route}/Tratamiento/Ganado";
  static const String getTreatmentByGroup = "${route}/Tratamiento/Grupo";
  static const String getTreatmentByFarm = "${route}/Tratamiento/Finca";
  static const String deleteTreatment = "${route}/Tratamiento";

  static const String createCattle = "${route}/Ganado";
  static const String getCattleByGroup = "${route}/Ganado/Grupo";
  static const String getCattle = "${route}/Ganado";
  static const String getGraphicByCattle = "${route}/Ganado/Grupo/Grafico";

  static const String createMeditation = "${route}/Farmaco";
  static const String getMeditationbyFarm = "${route}/Farmaco/finca";

  static const String createPhysicalProblem = "${route}/ProblemaFisico";
  static const String getPhysicalProblemByCattle =
      "${route}/ProblemaFisico/ganado";
  static const String updatePhysicalProblem = "${route}/ProblemaFisico";
  static const String deletePhysicalProblem = "${route}/ProblemaFisico";
  static const String getGraphicByPhysicalProblem =
      "${route}/ProblemaFisico/Grafico";

  static const String createAnimalHeartCalendar = "${route}/Recordatorio";
  static const String getAnimalHeartCalendarByCattle =
      "${route}/Recordatorio/Ganado";
  static const String updateAnimalHeartCalendar = "${route}/Recordatorio";
  static const String deleteAnimalHeartCalendar = "${route}/Recordatorio";

  static const String createInsemination = "${route}/Inseminacion";

  static const String createCowCalving = "${route}/Parto";
  static const String getGraphicByCowCalving = "${route}/Parto/Grafico";

  static const String getDocuments = "${route}/Documento";
  static const String getPdfbyDocument = "${route}/Documento";
}
