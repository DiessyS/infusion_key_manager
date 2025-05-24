class ArgonParams {
  late final int memory;
  late final int parallelism;
  late final int iterations;

  ArgonParams({
    required this.memory,
    required this.parallelism,
    required this.iterations,
  });

  ArgonParams.fromJson(Map<String, dynamic> map) {
    memory = map['m'];
    parallelism = map['p'];
    iterations = map['i'];
  }

  Map<String, dynamic> toJson() {
    return {
      'm': memory,
      'p': parallelism,
      'i': iterations,
    };
  }
}
