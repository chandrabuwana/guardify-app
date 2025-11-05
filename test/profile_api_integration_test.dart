import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/core/constants/app_constants.dart';
import 'package:guardify_app/features/profile/data/models/user_api_response_model.dart';

void main() {
  group('Profile API Integration Tests', () {
    test('UserApiResponseModel should parse JSON correctly', () {
      // Arrange
      final json = {
        'Data': {
          'Id': '491874ce-92c0-4cfd-83b7-f916df7c219b',
          'Username': 'Admin',
          'Fullname': 'Administrator',
          'Mail': 'admin@mail.com',
          'Token': '4ff97d36-52fb-47e2-b6b3-8ae6bd644705',
          'PhoneNumber': '0000000',
          'Status': 'Active',
          'IsLockout': false,
          'AccessFailedCount': 0,
          'Active': true,
          'Roles': [
            {'Id': 'ADM', 'Nama': 'Admin'}
          ],
          'CreateBy': 'SYSTEM',
          'CreateDate': '2025-09-23T13:58:34.967',
          'UpdateBy': '491874ce-92c0-4cfd-83b7-f916df7c219b|Administrator',
          'UpdateDate': '2025-10-09T14:12:15.497',
        },
        'Code': 200,
        'Succeeded': true,
        'Message': 'All OK',
        'Description': '',
      };

      // Act
      final response = UserApiResponseModel.fromJson(json);

      // Assert
      expect(response.succeeded, true);
      expect(response.code, 200);
      expect(response.data, isNotNull);
      expect(response.data!.id, '491874ce-92c0-4cfd-83b7-f916df7c219b');
      expect(response.data!.username, 'Admin');
      expect(response.data!.fullname, 'Administrator');
      expect(response.data!.mail, 'admin@mail.com');
      expect(response.data!.phoneNumber, '0000000');
      expect(response.data!.status, 'Active');
      expect(response.data!.isLockout, false);
      expect(response.data!.active, true);
      expect(response.data!.roles.length, 1);
      expect(response.data!.roles.first.id, 'ADM');
      expect(response.data!.roles.first.nama, 'Admin');
    });

    test('UserApiDataModel should convert to ProfileUserModel correctly', () {
      // Arrange
      final userApiData = UserApiDataModel(
        id: '491874ce-92c0-4cfd-83b7-f916df7c219b',
        username: 'Admin',
        fullname: 'Administrator',
        mail: 'admin@mail.com',
        token: '4ff97d36-52fb-47e2-b6b3-8ae6bd644705',
        phoneNumber: '0000000',
        status: 'Active',
        isLockout: false,
        accessFailedCount: 0,
        active: true,
        roles: [RoleApiModel(id: 'ADM', nama: 'Admin')],
        createBy: 'SYSTEM',
        createDate: '2025-09-23T13:58:34.967',
        updateBy: '491874ce-92c0-4cfd-83b7-f916df7c219b|Administrator',
        updateDate: '2025-10-09T14:12:15.497',
      );

      // Act
      final profileUser = userApiData.toProfileUserModel();

      // Assert
      expect(profileUser.id, '491874ce-92c0-4cfd-83b7-f916df7c219b');
      expect(profileUser.nrp, 'Admin');
      expect(profileUser.name, 'Administrator');
      expect(profileUser.teleponPribadi, '0000000');
      expect(profileUser.jabatan, 'Admin');
    });

    test('AppConstants should have userIdKey', () {
      // Assert
      expect(AppConstants.userIdKey, 'user_id');
    });
  });
}
