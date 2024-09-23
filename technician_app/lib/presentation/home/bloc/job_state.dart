// job_state.dart
import 'package:equatable/equatable.dart';
import 'package:technician_app/domain/entities/job_entity.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final List<JobEntity> jobs;

  const JobLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
}

class JobError extends JobState {
  final String message;

  const JobError(this.message);

  @override
  List<Object> get props => [message];
}