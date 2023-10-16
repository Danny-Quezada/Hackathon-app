import 'package:hackathon_app/domain/interfaces/imodel.dart';
import 'package:hackathon_app/domain/models/Entities/physical_problem.dart';

abstract class IPhysicalProblemServices extends IModel<PhysicalProblem> {
  Future<List<PhysicalProblem>> getPhysicalProblemByCattle(String IdCattle);
}