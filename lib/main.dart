// CampusConnect - College Notice Board
// Developed by Bhanu Nidikonda
// Tech: Dart + Flutter Architecture

import 'dart:convert';

enum UserRole { student, faculty, admin }
enum Priority { low, medium, high }

class Notice {
  final String id;
  final String title;
  final String description;
  final String department;
  final String category;
  final Priority priority;
  final String author;
  final DateTime date;
  final UserRole role;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.department,
    required this.category,
    required this.priority,
    required this.author,
    required this.date,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'department': department,
        'category': category,
        'priority': priority.name,
        'author': author,
        'date': date.toIso8601String(),
        'role': role.name,
      };

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      department: json['department'],
      category: json['category'],
      priority: Priority.values.byName(json['priority']),
      author: json['author'],
      date: DateTime.parse(json['date']),
      role: UserRole.values.byName(json['role']),
    );
  }
}

class CampusConnectApp {
  List<Notice> notices = [];
  UserRole currentRole = UserRole.student;
  String selectedDepartment = 'All';
  String searchQuery = '';

  void addNotice(Notice notice) {
    notices.add(notice);
    print('Notice Added: ${notice.title}');
  }

  void deleteNotice(String id) {
    notices.removeWhere((n) => n.id == id);
    print('Notice Deleted: $id');
  }

  List<Notice> getFilteredNotices() {
    return notices.where((n) {
      bool matchDept = selectedDepartment == 'All' || n.department == selectedDepartment;
      bool matchSearch = searchQuery.isEmpty ||
          n.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchDept && matchSearch;
    }).toList();
  }

  Map<String, int> getDashboardStats() {
    return {
      'total': notices.length,
      'highPriority': notices.where((n) => n.priority == Priority.high).length,
      'cse': notices.where((n) => n.department == 'CSE').length,
      'ece': notices.where((n) => n.department == 'ECE').length,
    };
  }

  String toJsonString() {
    return jsonEncode(notices.map((n) => n.toJson()).toList());
  }
}

void main() {
  final app = CampusConnectApp();

  app.addNotice(Notice(
    id: '1',
    title: 'Mid Exams Schedule Released',
    description: 'Mid exams will start from next Monday. Check timetable.',
    department: 'CSE',
    category: 'Exams',
    priority: Priority.high,
    author: 'Admin',
    date: DateTime.now(),
    role: UserRole.admin,
  ));

  app.addNotice(Notice(
    id: '2',
    title: 'Tech Fest 2026 Registrations Open',
    description: 'Register for Hackathon, Paper Presentation and more.',
    department: 'All',
    category: 'Events',
    priority: Priority.medium,
    author: 'Faculty',
    date: DateTime.now(),
    role: UserRole.faculty,
  ));

  print('CampusConnect Started');
  print('Stats: ${app.getDashboardStats()}');
  print('Filtered: ${app.getFilteredNotices().length} notices');
}
