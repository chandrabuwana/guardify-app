import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/personnel.dart';

part 'personnel_model.g.dart';

@JsonSerializable()
class PersonnelModel extends Personnel {
  PersonnelModel({
    required super.id,
    required super.nrp,
    required super.name,
    required super.email,
    super.photoUrl,
    required super.role,
    required super.status,
    super.updateBy,
    super.updateDate,
    super.noKtp,
    super.tempatLahir,
    super.tanggalLahir,
    super.jenisKelamin,
    super.pendidikan,
    super.teleponPribadi,
    super.teleponDarurat,
    super.site,
    super.jabatan,
    super.atasan,
    super.tanggalPenerimaanKaryawan,
    super.masaBerlakuPermit,
    super.kompetensiPekerjaan,
    super.wargaNegara,
    super.provinsi,
    super.kotaKabupaten,
    super.kecamatan,
    super.kelurahan,
    super.alamatDomisili,
    super.ktpUrl,
    super.ktaUrl,
    super.fotoUrl,
    super.p3tdK3lhUrl,
    super.p3tdSecurityUrl,
    super.pernyataanTidakMerokokUrl,
  });

  factory PersonnelModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonnelModelToJson(this);
}
