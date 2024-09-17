// Blueprint for Job
// Holds Data
// What it is and what behaviors it will have

class JobEntity {
  // Job Class Properties
  final String id;
  final String name;
  final String location;
  final String jobType;
  final String status;

  JobEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.jobType,
    required this.status,
  });

  // Creates the Job Object using JSon
  factory JobEntity.fromJson(Map<String, dynamic> json) {
    return JobEntity(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        jobType: json['jobType'],
        status: json['status']);
  }
}
