class CurrentLocationRequestModel {
  final String idUser;
  final String search;
  final String? idAreas;

  const CurrentLocationRequestModel({
    required this.idUser,
    this.search = '',
    this.idAreas,
  });

  Map<String, dynamic> toJson() {
    return {
      'IdUser': idUser,
      'Search': search,
      'IdAreas': idAreas,
    };
  }
}

