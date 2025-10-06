import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/profile_user.dart';

/// Widget untuk menampilkan header profil dengan foto dan info dasar
class ProfileHeader extends StatelessWidget {
  final ProfileUser profile;
  final VoidCallback? onPhotoTap;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          // Foto profil
          GestureDetector(
            onTap: onPhotoTap,
            child: Stack(
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 3.w,
                    ),
                  ),
                  child: ClipOval(
                    child: profile.profileImageUrl != null
                        ? Image.network(
                            profile.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar();
                            },
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
                
                // Edit icon
                if (onPhotoTap != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor,
                          width: 2.w,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: primaryColor,
                        size: 16.w,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Nama
          Text(
            profile.name,
            style: TS.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 4.h),
          
          // NRP dan jabatan
          Text(
            '${profile.nrp} - ${profile.jabatan}',
            style: TS.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build default avatar jika tidak ada foto profil
  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.white.withOpacity(0.2),
      child: Icon(
        Icons.person,
        size: 60.w,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }
}