import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/job_entity.dart';

abstract class JobDataSource {
  // Job blueprint on how to fetch job data and new job data
  Future<List<JobEntity>> getJobs();
  Future<List<JobEntity>> getNewJobs();
}

// Blueprint for the HTTP to get data from the server
class JobDataSourceImpl implements JobDataSource {
  final http.Client client;

  JobDataSourceImpl(this.client);

  @override
  Future<List<JobEntity>> getJobs() async {
    final response =
        await client.get(Uri.parse('http://your-backend-url/jobs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => JobEntity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Future<List<JobEntity>> getNewJobs() async {
    final response =
        await client.get(Uri.parse('http://your-backend-url/jobs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => JobEntity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
