// get_jobs.dart
import 'package:technician_app/core/configs/usecases/usecases.dart';
import 'package:technician_app/domain/entities/job_entity.dart';
import 'package:technician_app/domain/repositories/job_repo_domain.dart';

class GetJobs implements UseCase<List<JobEntity>, NoParams> {
  final JobRepoDomain repository;

  GetJobs(this.repository);

  @override
  Future<List<JobEntity>> call(NoParams params) async {
    return await repository.getJobs();
  }
}
