// job_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technician_app/core/configs/usecases/usecases.dart';
import 'package:technician_app/presentation/home/bloc/job_event.dart';
import 'package:technician_app/presentation/home/bloc/job_state.dart';
import '../../../domain/usecases/gets_job.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobs getJobs;

  JobBloc(this.getJobs) : super(JobInitial());

  Stream<JobState> mapEventToState(JobEvent event) async* {
    if (event is LoadJobs) {
      yield JobLoading();
      try {
        final jobs = await getJobs(NoParams()); // Fetch jobs using the use case
        yield JobLoaded(jobs);
      } catch (e) {
        yield const JobError('Failed to fetch jobs');
      }
    }
  }
}
