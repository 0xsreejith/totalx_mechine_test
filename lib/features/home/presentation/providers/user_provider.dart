import 'package:flutter/material.dart';
import 'package:totalx/features/home/data/datasources/user_local_data_sources.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserLocalDatasource datasource;

  UserProvider(this.datasource);

  List<UserEntity> users = [];
  List<UserEntity> _allUsers = []; // Keep original list for search/filter
  int limit = 10;
  String _currentSearchQuery = '';
  String? _currentFilter; // 'older', 'younger', or null

  /// Add a new user
  Future<void> addUser(
    String name,
    String phone,
    int age,
    String image,
  ) async {
    final user = UserEntity(
      id: const Uuid().v4(),
      name: name,
      phone: phone,
      age: age,
      imagePath: image,
    );

    await datasource.addUser(UserModel.fromEntity(user));
    await loadUsers();
  }

  /// Load users from database
  Future<void> loadUsers() async {
    final result = await datasource.getUsers(limit);
    _allUsers = result.map((e) => e.toEntity()).toList();
    
    // Reset filter and search
    _currentFilter = null;
    _currentSearchQuery = '';
    users = List.from(_allUsers);
    
    notifyListeners();
  }

  /// Lazy loading - load more users
  Future<void> loadMore() async {
    limit += 10;
    await loadUsers();
  }

  /// Search users by name or phone
  Future<void> search(String query) async {
    _currentSearchQuery = query;
    
    if (query.isEmpty) {
      // If search is empty, restore based on current filter
      _applyCurrentFilter();
      return;
    }

    final result = await datasource.search(query);
    final searchResults = result.map((e) => e.toEntity()).toList();
    
    // Apply filter if active
    if (_currentFilter == 'older') {
      users = searchResults.where((u) => u.age >= 60).toList();
    } else if (_currentFilter == 'younger') {
      users = searchResults.where((u) => u.age < 60).toList();
    } else {
      users = searchResults;
    }
    
    notifyListeners();
  }

  /// Sort by age category
  void sortByAgeCategory(bool older) {
    _currentFilter = older ? 'older' : 'younger';
    
    // If there's an active search, apply filter to search results
    // Otherwise apply to all users
    if (_currentSearchQuery.isNotEmpty) {
      search(_currentSearchQuery);
    } else {
      _applyCurrentFilter();
    }
  }

  /// Apply the current filter to all users
  void _applyCurrentFilter() {
    if (_currentFilter == 'older') {
      users = _allUsers.where((u) => u.age >= 60).toList();
    } else if (_currentFilter == 'younger') {
      users = _allUsers.where((u) => u.age < 60).toList();
    } else {
      users = List.from(_allUsers);
    }
    notifyListeners();
  }

  /// Clear all filters and show all users
  void clearFilters() {
    _currentFilter = null;
    _currentSearchQuery = '';
    users = List.from(_allUsers);
    notifyListeners();
  }

  /// Get current filter status
  String get currentFilterStatus {
    if (_currentFilter == 'older') return 'Older (60+)';
    if (_currentFilter == 'younger') return 'Younger (<60)';
    return 'All Users';
  }
}