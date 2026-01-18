import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_cuti_kuota.dart';
import '../../domain/usecases/get_daftar_cuti_saya.dart';
import '../../domain/usecases/get_daftar_cuti_anggota.dart';
import '../../domain/usecases/buat_ajuan_cuti.dart';
import '../../domain/usecases/update_status_cuti.dart';
import '../../domain/usecases/filter_cuti.dart';
import '../../domain/usecases/get_detail_cuti.dart';
import '../../domain/usecases/get_rekap_cuti.dart';
import '../../domain/usecases/get_leave_request_type_list.dart';
import '../../domain/usecases/edit_cuti.dart';
import '../../domain/usecases/delete_cuti.dart';
import 'cuti_event.dart';
import 'cuti_state.dart';

@injectable
class CutiBloc extends Bloc<CutiEvent, CutiState> {
  final GetCutiKuota getCutiKuota;
  final GetDaftarCutiSaya getDaftarCutiSaya;
  final GetDaftarCutiAnggota getDaftarCutiAnggota;
  final BuatAjuanCuti buatAjuanCuti;
  final UpdateStatusCuti updateStatusCuti;
  final FilterCuti filterCuti;
  final GetDetailCuti getDetailCuti;
  final GetRekapCuti getRekapCuti;
  final GetLeaveRequestTypeList getLeaveRequestTypeList;
  final EditCuti editCuti;
  final DeleteCuti deleteCuti;

  CutiBloc({
    required this.getCutiKuota,
    required this.getDaftarCutiSaya,
    required this.getDaftarCutiAnggota,
    required this.buatAjuanCuti,
    required this.updateStatusCuti,
    required this.filterCuti,
    required this.getDetailCuti,
    required this.getRekapCuti,
    required this.getLeaveRequestTypeList,
    required this.editCuti,
    required this.deleteCuti,
  }) : super(CutiInitial()) {
    on<GetCutiKuotaEvent>(_onGetCutiKuota);
    on<GetDaftarCutiSayaEvent>(_onGetDaftarCutiSaya);
    on<GetDaftarCutiAnggotaEvent>(_onGetDaftarCutiAnggota);
    on<BuatAjuanCutiEvent>(_onBuatAjuanCuti);
    on<UpdateStatusCutiEvent>(_onUpdateStatusCuti);
    on<FilterCutiEvent>(_onFilterCuti);
    on<GetDetailCutiEvent>(_onGetDetailCuti);
    on<GetRekapCutiEvent>(_onGetRekapCuti);
    on<GetLeaveRequestTypeListEvent>(_onGetLeaveRequestTypeList);
    on<EditCutiEvent>(_onEditCuti);
    on<DeleteCutiEvent>(_onDeleteCuti);
    on<ResetCutiStateEvent>(_onResetCutiState);
    on<ClearCutiErrorEvent>(_onClearCutiError);
  }

  Future<void> _onGetCutiKuota(
    GetCutiKuotaEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final kuota = await getCutiKuota(event.userId);
      emit(CutiKuotaLoaded(kuota));
    } catch (e) {
      emit(CutiError('Gagal memuat kuota cuti: ${e.toString()}'));
    }
  }

  Future<void> _onGetDaftarCutiSaya(
    GetDaftarCutiSayaEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final daftarCuti = await getDaftarCutiSaya(event.userId);
      emit(DaftarCutiSayaLoaded(daftarCuti));
    } catch (e) {
      emit(CutiError('Gagal memuat daftar cuti saya: ${e.toString()}'));
    }
  }

  Future<void> _onGetDaftarCutiAnggota(
    GetDaftarCutiAnggotaEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final params = GetDaftarCutiAnggotaParams(
        status: event.status,
        tipeCuti: event.tipeCuti,
        tanggalMulai: event.tanggalMulai,
        tanggalSelesai: event.tanggalSelesai,
      );
      final daftarCuti = await getDaftarCutiAnggota(params);
      emit(DaftarCutiAnggotaLoaded(daftarCuti));
    } catch (e) {
      emit(CutiError('Gagal memuat daftar cuti anggota: ${e.toString()}'));
    }
  }

  Future<void> _onBuatAjuanCuti(
    BuatAjuanCutiEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final params = BuatAjuanCutiParams(
        userId: event.userId,
        nama: event.nama,
        tipeCuti: event.tipeCuti,
        leaveRequestTypeId: event.leaveRequestTypeId,
        tanggalMulai: event.tanggalMulai,
        tanggalSelesai: event.tanggalSelesai,
        alasan: event.alasan,
        jumlahHari: event.jumlahHari,
      );
      final cuti = await buatAjuanCuti(params);
      emit(AjuanCutiCreated(cuti));
    } catch (e) {
      emit(CutiError('Gagal membuat ajuan cuti: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateStatusCuti(
    UpdateStatusCutiEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final params = UpdateStatusCutiParams(
        cutiId: event.cutiId,
        status: event.status,
        reviewerId: event.reviewerId,
        reviewerName: event.reviewerName,
        umpanBalik: event.umpanBalik,
      );
      final cuti = await updateStatusCuti(params);
      emit(StatusCutiUpdated(cuti));
    } catch (e) {
      emit(CutiError('Gagal memperbarui status cuti: ${e.toString()}'));
    }
  }

  Future<void> _onFilterCuti(
    FilterCutiEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final params = FilterCutiParams(
        status: event.status,
        tipeCuti: event.tipeCuti,
        tanggalMulai: event.tanggalMulai,
        tanggalSelesai: event.tanggalSelesai,
        userId: event.userId,
      );
      final daftarCuti = await filterCuti(params);
      emit(CutiFiltered(daftarCuti));
    } catch (e) {
      emit(CutiError('Gagal memfilter cuti: ${e.toString()}'));
    }
  }

  Future<void> _onGetDetailCuti(
    GetDetailCutiEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final cuti = await getDetailCuti(event.cutiId);
      emit(DetailCutiLoaded(cuti));
    } catch (e) {
      emit(CutiError('Gagal memuat detail cuti: ${e.toString()}'));
    }
  }

  Future<void> _onGetRekapCuti(
    GetRekapCutiEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final params = GetRekapCutiParams(
        tanggalMulai: event.tanggalMulai,
        tanggalSelesai: event.tanggalSelesai,
        status: event.status,
        tipeCuti: event.tipeCuti,
      );
      final rekapCuti = await getRekapCuti(params);
      emit(RekapCutiLoaded(rekapCuti));
    } catch (e) {
      emit(CutiError('Gagal memuat rekap cuti: ${e.toString()}'));
    }
  }

  void _onResetCutiState(
    ResetCutiStateEvent event,
    Emitter<CutiState> emit,
  ) {
    emit(CutiInitial());
  }

  Future<void> _onGetLeaveRequestTypeList(
    GetLeaveRequestTypeListEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final leaveRequestTypes = await getLeaveRequestTypeList();
      emit(LeaveRequestTypeListLoaded(leaveRequestTypes));
    } catch (e) {
      emit(CutiError('Gagal memuat jenis cuti: ${e.toString()}'));
    }
  }

  void _onClearCutiError(
    ClearCutiErrorEvent event,
    Emitter<CutiState> emit,
  ) {
    if (state is CutiError) {
      emit(CutiInitial());
    }
  }

  Future<void> _onEditCuti(
    EditCutiEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      final params = EditCutiParams(
        cutiId: event.cutiId,
        startDate: event.startDate,
        endDate: event.endDate,
        idLeaveRequestType: event.idLeaveRequestType,
        notes: event.notes,
        userId: event.userId,
        createBy: event.createBy,
        createDate: event.createDate,
        approveBy: event.approveBy,
        approveDate: event.approveDate,
        notesApproval: event.notesApproval,
        status: event.status,
      );
      final cuti = await editCuti(params);
      emit(CutiEdited(cuti));
    } catch (e) {
      emit(CutiError('Gagal mengedit cuti: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCuti(
    DeleteCutiEvent event,
    Emitter<CutiState> emit,
  ) async {
    try {
      emit(CutiLoading());
      await deleteCuti(event.cutiId);
      emit(CutiDeleted());
    } catch (e) {
      emit(CutiError('Gagal menghapus cuti: ${e.toString()}'));
    }
  }
}
