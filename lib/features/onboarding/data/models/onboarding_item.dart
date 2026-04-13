class OnboardingItem {
  final String title;
  final String description;
  final String image;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });

  static const List<OnboardingItem> items = [
    OnboardingItem(
      title: 'ANALYZE EVERY MOVE',
      description:
          'Turn your workouts into smart insights that help you train better and progress faster.',
      image: 'assets/images/onboarding1.jpg',
    ),
    OnboardingItem(
      title: 'TRAIN WITH PURPOSE',
      description:
          'Every rep, every set, tracked to help you reach peak performance.',
      image: 'assets/images/onboarding2.jpg',
    ),
    OnboardingItem(
      title: 'SMART TRAINING STARTS HERE',
      description: 'Data-powered tracking built for serious results.',
      image: 'assets/images/onboarding3.jpg',
    ),
  ];
}
