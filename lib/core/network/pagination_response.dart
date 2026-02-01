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

  factory PaginationResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PaginationResponse();
    return PaginationResponse(
      limit: json['limit'] as int?,
      offset: json['offset'] as int?,
      total: json['total'] as int?,
    );
  }
}
