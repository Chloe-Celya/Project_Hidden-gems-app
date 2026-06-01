import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/spot.dart';

class SpotService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String collection = 'spots';

  Future<void> addSpot(Spot spot) async {
    await _db.collection(collection).add(
      spot.toFirestore(),
    );
  }

  Stream<List<Spot>> getSpots() {
    return _db.collection(collection).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Spot.fromFirestore(
            doc.data(),
            doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> deleteSpot(String id) async {
    await _db.collection(collection).doc(id).delete();
  }
}