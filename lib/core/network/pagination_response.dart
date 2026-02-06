/// Pagination response (API types.PaginationResponse).
class PaginationResponse {
  final int? limit;
  final int? offset;
  final int? total;

  const PaginationResponse({
    this.limit,
    this.offset,
    this.total,
  });

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  factory PaginationResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PaginationResponse();
    return PaginationResponse(
      limit: _parseInt(json['limit']),
      offset: _parseInt(json['offset']),
      total: _parseInt(json['total']),
    );
  }
}
