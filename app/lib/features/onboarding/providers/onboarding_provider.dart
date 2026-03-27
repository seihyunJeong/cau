import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/database/daos/baby_dao.dart';
import '../../../data/models/baby.dart';
import '../../../providers/core_providers.dart';

/// 온보딩 입력 상태를 보관하는 Notifier.
/// 이름, 생년월일, 프로필 사진 경로를 관리하며,
/// 등록 시 Baby 객체를 생성하여 DB에 INSERT한다.
class OnboardingState {
  final String name;
  final DateTime? birthDate;
  final String? profileImagePath;
  final bool isSubmitting;

  const OnboardingState({
    this.name = '',
    this.birthDate,
    this.profileImagePath,
    this.isSubmitting = false,
  });

  /// 이름과 생년월일이 모두 입력되었는지 확인한다.
  bool get isValid => name.trim().isNotEmpty && birthDate != null;

  OnboardingState copyWith({
    String? name,
    DateTime? birthDate,
    String? profileImagePath,
    bool? isSubmitting,
  }) =>
      OnboardingState(
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        profileImagePath: profileImagePath ?? this.profileImagePath,
        isSubmitting: isSubmitting ?? this.isSubmitting,
      );
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  BabyDao get _babyDao => ref.read(babyDaoProvider);

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setBirthDate(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void setProfileImagePath(String? path) {
    state = state.copyWith(profileImagePath: path);
  }

  /// 아기를 등록하고 생성된 Baby의 id를 반환한다.
  Future<int> registerBaby() async {
    state = state.copyWith(isSubmitting: true);
    try {
      final baby = Baby(
        name: state.name.trim(),
        birthDate: state.birthDate!,
        profileImagePath: state.profileImagePath,
        createdAt: nowKST(),
        isActive: true,
      );
      final id = await _babyDao.insert(baby);
      return id;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

/// 온보딩 상태 관리 Provider.
final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
