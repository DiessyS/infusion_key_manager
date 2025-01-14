class ArgonParams {
  static const int _defaultMemory = 1024 * 64; // 64MB
  static const int _defaultHighMemory = 1024 * 512; // 512MB
  static const int _defaultParallelism = 4;
  static const int _defaultIterations = 3;

  late final int memory;
  late final int parallelism;
  late final int iterations;

  ArgonParams({
    this.memory = _defaultMemory,
    this.parallelism = _defaultParallelism,
    this.iterations = _defaultIterations,
  });

  static ArgonParams getForDerive() {
    return ArgonParams(
      iterations: _defaultIterations,
      memory: _defaultMemory,
      parallelism: _defaultParallelism,
    );
  }

  static ArgonParams getForHashing() {
    return ArgonParams(
      iterations: _defaultIterations,
      memory: _defaultHighMemory,
      parallelism: _defaultParallelism,
    );
  }

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
