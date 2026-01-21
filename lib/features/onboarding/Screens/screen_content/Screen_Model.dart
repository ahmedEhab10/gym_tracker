class ScreenModel {
  final String title;
  final String description;
  final String image;
  ScreenModel({
    required this.title,
    required this.description,
    required this.image,
  });

  static List<ScreenModel> screens = [
    ScreenModel(
      title: 'ANALYZE EVERY MOVE',
      description:
          'Turn your workouts into smart insights that help you train better and progress faster.',
      image: 'assets/images/onboard1.jpg',
    ),
    ScreenModel(
      title: 'TRAIN WITH PURPOSE',
      description:
          'Every rep, every set, tracked to help you reach peak performance.',
      image: 'assets/images/onboard2.jpg',
    ),
    ScreenModel(
      title: 'SMART TRAINING STARTS HERE',
      description: 'Data-powered tracking built for serious results.',
      image: 'assets/images/onboard3.jpg',
    ),
  ];
}
