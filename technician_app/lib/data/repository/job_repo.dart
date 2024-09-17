import 'package:technician_app/data/sources/job_data_source.dart';
import 'package:technician_app/domain/entities/job_entity.dart';
import 'package:technician_app/domain/repositories/job_repo_domain.dart';

class JobRepoImpl implements JobRepoDomain {
  final JobDataSource remoteDataSource;

  JobRepoImpl(this.remoteDataSource);

  @override
  Future<List<JobEntity>> getJobs() async {
    return await remoteDataSource.getJobs();
  }

  @override
  Future<List<JobEntity>> getNewJobs() async {
    return await remoteDataSource.getNewJobs();
  }
}
