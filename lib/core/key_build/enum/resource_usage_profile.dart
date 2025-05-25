enum ResourceUsageProfile {
  minimal(0, 47104, 3, 1),
  balanced(1, 65536, 3, 4),
  high(2, 131072, 3, 4),
  ultra(3, 262144, 3, 4);

  final int id;
  final int memory;
  final int iteration;
  final int parallelism;

  const ResourceUsageProfile(
    this.id,
    this.memory,
    this.iteration,
    this.parallelism,
  );

  static ResourceUsageProfile fromId(int id) {
    return ResourceUsageProfile.values.firstWhere(
      (element) => element.id == id,
      orElse: () => ResourceUsageProfile.balanced,
    );
  }
}
