import 'package:technician_app/domain/entities/job_entity.dart';

abstract class JobRepoDomain {
  Future<List<JobEntity>> getJobs();
  Future<List<JobEntity>> getNewJobs();
}
