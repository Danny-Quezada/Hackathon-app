class AnimalHealthCalendar {
  AnimalHealthCalendar(
      {this.animalHealthCalendarId = 0,
      required this.date,
      required this.title,
      required this.description,
      required this.cattleId,
      this.meditationId});

  int? animalHealthCalendarId;
  final DateTime? date;
  final String title;
  final String description;
  final String cattleId;
  final int? meditationId;

  factory AnimalHealthCalendar.fromJson(Map<String, dynamic> json) {
    return AnimalHealthCalendar(
      animalHealthCalendarId: json["id"] ?? 0,
      date: DateTime.tryParse(json["fecha"] ?? ""),
      title: json["titulo"] ?? "",
      description: json["descripcion"] ?? "",
      cattleId: json["idGanado"] ?? "",
      meditationId: int.parse(json["idFarmaco"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "Id": animalHealthCalendarId,
        "Fecha": date?.toIso8601String(),
        "Titulo": title,
        "Descripcion": description,
        "IdGanado": cattleId,
        "IdFarmaco": meditationId,
      };
}
