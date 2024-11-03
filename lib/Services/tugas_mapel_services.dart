import '/Helper/repository.dart';
import '/pages/tugas_mapel.dart';

// class TugasService {
//   late Repository _repository;
//   TugasService() {
//     _repository = Repository();
//   }

//   SaveTugas(Tugas tugas) async {
//     return await _repository.insertData('user', tugas.tugasMap());
//   }

//   readAllTugas() async {
//     return await _repository.readData('tugas');
//   }

//   Updatetugas(Tugas tugas) async {
//     return await _repository.updateData('tugas', tugas.tugasMap());
//   }

//   deletetugas(tugasId) async {
//     return await _repository.deleteDataById('tugas', tugasId);
//   }
// }

class MapelService {
  late Repository _repository;
  MapelService() {
    _repository = Repository();
  }

  SaveMapel(Mapel mapel) async {
    return await _repository.insertData('mapel', mapel.mapelMap());
    // int id = await _repository.insertData('mapel', mapel.mapelMap());
    // mapel.id = id;
    // return mapel;
  }

  readAllMapel() async {
    return await _repository.readData('mapel');
  }

  updateMapel(Mapel mapel) async {
    return await _repository.updateData('mapel', mapel.mapelMap());
  }

  deleteMapel(mapelId) async {
    return await _repository.deleteDataById('mapel', mapelId);
  }
}
