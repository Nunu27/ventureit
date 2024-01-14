class PaginatedOptions<T, E> {
  final T data;
  final E offset;

  PaginatedOptions({
    required this.data,
    required this.offset,
  });

  PaginatedOptions<T, E> copyWith({
    T? data,
    E? page,
  }) {
    return PaginatedOptions<T, E>(
      data: data ?? this.data,
      offset: page ?? this.offset,
    );
  }

  @override
  bool operator ==(covariant PaginatedOptions<T, E> other) {
    if (identical(this, other)) return true;

    return other.data == data && other.offset == offset;
  }

  @override
  int get hashCode => data.hashCode ^ offset.hashCode;
}
