import 'package:flutter/material.dart';
import 'package:project/approval/approval_cuti_khusus.dart';
import 'package:project/approval/approval_perjalanan_dinas.dart';
import 'package:project/detail/laporan/pilih_perusahaan/perusahaan_izin_3_jam.dart';
import 'package:project/detail/laporan/pilih_perusahaan/perusahaan_izin_sakit.dart';
import 'package:project/home/dashboard/dashboard.dart';
import 'package:project/pengajuan/pengajuan_perjalanan_dinas.dart';
import 'package:project/pengajuan_hr/pengajuan_cuti_tahunan_hr.dart';
import 'package:project/pengajuan_hr/pengajuan_izin_sakit_hr.dart';

import '../approval/approval_cuti_tahunan.dart';
import '../approval/approval_izin_3_jam.dart';
import '../approval/approval_izin_sakit.dart';
import '../color.dart';
import '../detail/laporan/pilih_perusahaan/perusahaan_cuti_khusus.dart';
import '../detail/laporan/pilih_perusahaan/perusahaan_cuti_tahunan.dart';
import '../detail/laporan/pilih_perusahaan/perusahaan_perjalanan_dinas.dart';
import '../home/master/master_approver/master_approver.dart';
import '../home/master/master_company/master_company.dart';
import '../home/master/master_jumlah_cuti_tahunan/jumlah_cuti_tahunan.dart';
import '../home/master/master_karyawan/master_karyawan.dart';
import '../pengajuan_hr/hr_pengajuan_cuti_khusus.dart';
import '../pengajuan_hr/hr_pengajuan_pembatalan_izin_3jam.dart';
import '../pengajuan_hr/hr_pengajuan_perjalanan_dinas.dart';
import '../pengajuan/pengajuan_cuti_khusus.dart';

class NavHr extends StatefulWidget {
  const NavHr({super.key});

  @override
  State<NavHr> createState() => _NavHrState();
}

class _NavHrState extends State<NavHr> {
  // ignore: unused_local_variable
  String pilihLaporan = 'Laporan';
  // ignore: unused_local_variable
  String pilihLeaves = 'Leaves';
  // ignore: unused_local_variable
  String pilihApproval = 'Approval';
  // ignore: unused_local_variable
  String pilihSetting = 'Setting';

  void laporan(String laporan) {
    setState(() {
      pilihLaporan = laporan;
    });
  }

  void leaves(String leaves) {
    setState(() {
      pilihLeaves = leaves;
    });
  }

  void approval(String approval) {
    setState(() {
      pilihApproval = approval;
    });
  }

  void setting(String setting) {
    setState(() {
      pilihSetting = setting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: darkblue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'HR System',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ///////////////////////////// untuk laporan
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ListTile(
                leading: const Icon(Icons.castle),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.next_week_rounded),
                title: const Text('Laporan'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Izin Sakit'),
                      onTap: () {
                        laporan('Izin Sakit');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanIzinSakit(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.assignment),
                      title: const Text('Izin 3 Jam'),
                      onTap: () {
                        laporan('Izin 3 Jam');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanIzin3Jam(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Tahunan'),
                      onTap: () {
                        laporan('Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanCutiTahunan(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Khusus'),
                      onTap: () {
                        laporan('Cuti Khusus');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanCutiKhusus(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Perjalanan Dinas'),
                      onTap: () {
                        laporan('Perjalanan Dinas');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PerusahaanPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            //////////////////////////////////////////////// untuk Leaves
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.next_week_rounded),
                title: const Text('Leaves'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Izin Sakit'),
                      onTap: () {
                        leaves('Izin Sakit');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PengajuanIzinSakitHR(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.assignment),
                      title: const Text('Izin 3 Jam'),
                      onTap: () {
                        leaves('Izin 3 Jam');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HRPengajuanIzin3Jam(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Tahunan'),
                      onTap: () {
                        leaves('Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PengajuanCutiTahunanHR(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Khusus'),
                      onTap: () {
                        leaves('Cuti Khusus');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HRPengajuanCutiKhusus(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Perjalanan Dinas'),
                      onTap: () {
                        leaves('Perjalanan Dinas');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HRPengajuanPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // ////////////////////////////////////////////untuk approval
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.next_week_rounded),
                title: const Text('Approval'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Izin Sakit'),
                      onTap: () {
                        approval('Izin Sakit');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApprovalIzinSakit(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.assignment),
                      title: const Text('Izin 3 Jam'),
                      onTap: () {
                        approval('Izin 3 Jam');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApprovalIzin3Jam(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Tahunan'),
                      onTap: () {
                        approval('Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApprovalCutiTahunan(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Khusus'),
                      onTap: () {
                        approval('Cuti Khusus');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApprovalCutiKhusus(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Perjalanan Dinas'),
                      onTap: () {
                        approval('Perjalanan Dinas');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ApprovalPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            // ///////////////////////////untuk setting
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.build_circle),
                title: const Text('Setting'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text('Master Company'),
                      onTap: () {
                        setting('Master Company');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MasterCompany(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Master Karyawan'),
                      onTap: () {
                        setting('Master Karyawan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MasterKaryawan(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.event_available),
                      title: const Text('Master Approver'),
                      onTap: () {
                        setting('Master Approver');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MasterApprover(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.date_range),
                      title: const Text('Master Jumlah Cuti Tahunan'),
                      onTap: () {
                        setting('Master Jumlah Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JumlahCutiTahunan(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
