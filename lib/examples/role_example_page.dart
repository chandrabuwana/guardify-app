import 'package:flutter/material.dart';
import 'package:guardify_app/core/constants/enums.dart';
import 'package:guardify_app/core/utils/user_role_helper.dart';

/// Example page yang menunjukkan cara menggunakan role system
class RoleExamplePage extends StatefulWidget {
  const RoleExamplePage({super.key});

  @override
  State<RoleExamplePage> createState() => _RoleExamplePageState();
}

class _RoleExamplePageState extends State<RoleExamplePage> {
  String? _roleId;
  String? _roleName;
  UserRole? _userRole;
  String? _username;
  String? _fullName;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final roleId = await UserRoleHelper.getUserRoleId();
    final roleName = await UserRoleHelper.getUserRoleName();
    final userRole = await UserRoleHelper.getUserRole();
    final username = await UserRoleHelper.getUsername();
    final fullName = await UserRoleHelper.getFullName();
    final isLoggedIn = await UserRoleHelper.isUserLoggedIn();

    setState(() {
      _roleId = roleId;
      _roleName = roleName;
      _userRole = userRole;
      _username = username;
      _fullName = fullName;
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role System Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Logged In', _isLoggedIn ? 'Yes' : 'No'),
            _buildInfoRow('Username', _username ?? 'Not set'),
            _buildInfoRow('Full Name', _fullName ?? 'Not set'),
            _buildInfoRow('Role ID', _roleId ?? 'Not set'),
            _buildInfoRow('Role Name', _roleName ?? 'Not set'),
            _buildInfoRow('UserRole Enum', _userRole?.displayName ?? 'Not set'),
            const SizedBox(height: 24),
            Text(
              'Role Capabilities',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (_userRole != null) ...[
              _buildCapabilityRow(
                'Is Anggota',
                _userRole!.isAnggota,
              ),
              _buildCapabilityRow(
                'Has High Access',
                _userRole!.isHighAccess,
              ),
              _buildCapabilityRow(
                'Can Manage Team',
                _userRole == UserRole.pjo ||
                    _userRole == UserRole.deputy ||
                    _userRole == UserRole.admin,
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Role Mapping Reference',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildRoleMapping('ADM', 'Admin', UserRole.admin),
            _buildRoleMapping('AGT', 'Anggota', UserRole.anggota),
            _buildRoleMapping('DPT', 'Deputy', UserRole.deputy),
            _buildRoleMapping('PGW', 'Pengawas', UserRole.pengawas),
            _buildRoleMapping('PJO', 'PJO', UserRole.pjo),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUserData,
              child: const Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(value ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _buildRoleMapping(String id, String name, UserRole role) {
    final isCurrentRole = _userRole == role;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: isCurrentRole ? Colors.blue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentRole ? Colors.blue : Colors.grey.shade300,
          width: isCurrentRole ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              id,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentRole ? Colors.blue : Colors.black87,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(name),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              role.displayName,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          if (isCurrentRole)
            const Icon(Icons.star, color: Colors.blue, size: 20),
        ],
      ),
    );
  }
}
