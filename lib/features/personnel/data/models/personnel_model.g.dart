// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonnelModel _$PersonnelModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonnelModel',
      json,
      ($checkedConvert) {
        final val = PersonnelModel(
          id: $checkedConvert('id', (v) => v as String),
          nrp: $checkedConvert('nrp', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          photoUrl: $checkedConvert('photo_url', (v) => v as String?),
          role: $checkedConvert('role', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
          updateBy: $checkedConvert('update_by', (v) => v as String?),
          updateDate: $checkedConvert('update_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          noKtp: $checkedConvert('no_ktp', (v) => v as String?),
          tempatLahir: $checkedConvert('tempat_lahir', (v) => v as String?),
          tanggalLahir: $checkedConvert('tanggal_lahir',
              (v) => v == null ? null : DateTime.parse(v as String)),
          jenisKelamin: $checkedConvert('jenis_kelamin', (v) => v as String?),
          pendidikan: $checkedConvert('pendidikan', (v) => v as String?),
          teleponPribadi:
              $checkedConvert('telepon_pribadi', (v) => v as String?),
          teleponDarurat:
              $checkedConvert('telepon_darurat', (v) => v as String?),
          site: $checkedConvert('site', (v) => v as String?),
          jabatan: $checkedConvert('jabatan', (v) => v as String?),
          atasan: $checkedConvert('atasan', (v) => v as String?),
          tanggalPenerimaanKaryawan: $checkedConvert(
              'tanggal_penerimaan_karyawan',
              (v) => v == null ? null : DateTime.parse(v as String)),
          masaBerlakuPermit: $checkedConvert('masa_berlaku_permit',
              (v) => v == null ? null : DateTime.parse(v as String)),
          kompetensiPekerjaan:
              $checkedConvert('kompetensi_pekerjaan', (v) => v as String?),
          wargaNegara: $checkedConvert('warga_negara', (v) => v as String?),
          provinsi: $checkedConvert('provinsi', (v) => v as String?),
          kotaKabupaten: $checkedConvert('kota_kabupaten', (v) => v as String?),
          kecamatan: $checkedConvert('kecamatan', (v) => v as String?),
          kelurahan: $checkedConvert('kelurahan', (v) => v as String?),
          alamatDomisili:
              $checkedConvert('alamat_domisili', (v) => v as String?),
          ktpUrl: $checkedConvert('ktp_url', (v) => v as String?),
          ktaUrl: $checkedConvert('kta_url', (v) => v as String?),
          fotoUrl: $checkedConvert('foto_url', (v) => v as String?),
          p3tdK3lhUrl: $checkedConvert('p3td_k3lh_url', (v) => v as String?),
          p3tdSecurityUrl:
              $checkedConvert('p3td_security_url', (v) => v as String?),
          pernyataanTidakMerokokUrl: $checkedConvert(
              'pernyataan_tidak_merokok_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'photoUrl': 'photo_url',
        'updateBy': 'update_by',
        'updateDate': 'update_date',
        'noKtp': 'no_ktp',
        'tempatLahir': 'tempat_lahir',
        'tanggalLahir': 'tanggal_lahir',
        'jenisKelamin': 'jenis_kelamin',
        'teleponPribadi': 'telepon_pribadi',
        'teleponDarurat': 'telepon_darurat',
        'tanggalPenerimaanKaryawan': 'tanggal_penerimaan_karyawan',
        'masaBerlakuPermit': 'masa_berlaku_permit',
        'kompetensiPekerjaan': 'kompetensi_pekerjaan',
        'wargaNegara': 'warga_negara',
        'kotaKabupaten': 'kota_kabupaten',
        'alamatDomisili': 'alamat_domisili',
        'ktpUrl': 'ktp_url',
        'ktaUrl': 'kta_url',
        'fotoUrl': 'foto_url',
        'p3tdK3lhUrl': 'p3td_k3lh_url',
        'p3tdSecurityUrl': 'p3td_security_url',
        'pernyataanTidakMerokokUrl': 'pernyataan_tidak_merokok_url'
      },
    );

Map<String, dynamic> _$PersonnelModelToJson(PersonnelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nrp': instance.nrp,
      'name': instance.name,
      'email': instance.email,
      'photo_url': instance.photoUrl,
      'role': instance.role,
      'status': instance.status,
      'update_by': instance.updateBy,
      'update_date': instance.updateDate?.toIso8601String(),
      'no_ktp': instance.noKtp,
      'tempat_lahir': instance.tempatLahir,
      'tanggal_lahir': instance.tanggalLahir?.toIso8601String(),
      'jenis_kelamin': instance.jenisKelamin,
      'pendidikan': instance.pendidikan,
      'telepon_pribadi': instance.teleponPribadi,
      'telepon_darurat': instance.teleponDarurat,
      'site': instance.site,
      'jabatan': instance.jabatan,
      'atasan': instance.atasan,
      'tanggal_penerimaan_karyawan':
          instance.tanggalPenerimaanKaryawan?.toIso8601String(),
      'masa_berlaku_permit': instance.masaBerlakuPermit?.toIso8601String(),
      'kompetensi_pekerjaan': instance.kompetensiPekerjaan,
      'warga_negara': instance.wargaNegara,
      'provinsi': instance.provinsi,
      'kota_kabupaten': instance.kotaKabupaten,
      'kecamatan': instance.kecamatan,
      'kelurahan': instance.kelurahan,
      'alamat_domisili': instance.alamatDomisili,
      'ktp_url': instance.ktpUrl,
      'kta_url': instance.ktaUrl,
      'foto_url': instance.fotoUrl,
      'p3td_k3lh_url': instance.p3tdK3lhUrl,
      'p3td_security_url': instance.p3tdSecurityUrl,
      'pernyataan_tidak_merokok_url': instance.pernyataanTidakMerokokUrl,
    };
