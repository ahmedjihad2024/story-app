import 'package:flutter/material.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/shared/features/profile/domain/model/profile_model.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import 'widgets/update_profile_form_widget.dart';

class UpdateProfileScreen extends StatelessWidget {
  final ProfileModel? initialProfile;

  const UpdateProfileScreen({
    super.key,
    this.initialProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorM.surface,
      appBar: AppBar(
        backgroundColor: ColorM.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: ColorM.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 18,
            fontWeight: FontWeightM.bold,
            color: ColorM.textPrimary,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: ColorM.border,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: UpdateProfileFormWidget(
            initialProfile: initialProfile,
          ),
        ),
      ),
    );
  }
}

