class Note {
  final String id;
  final String title;
  final String content;
  final bool isDone;
  final DateTime createdAt;

  // ✅ màu ghi chú (ARGB int)
  final int color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.isDone,
    required this.createdAt,
    this.color = 0xFFFFFFFF, // mặc định trắng
  });

  static int _parseColor(dynamic v) {
    if (v == null) return 0xFFFFFFFF;
    if (v is int) return v;

    final s = v.toString().trim();
    // hỗ trợ "0xFFAABBCC"
    if (s.startsWith('0x') || s.startsWith('0X')) {
      return int.tryParse(s.substring(2), radix: 16) ?? 0xFFFFFFFF;
    }
    // hỗ trợ "4294967295"
    return int.tryParse(s) ?? 0xFFFFFFFF;
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) {
      if (v is String && v.isNotEmpty) {
        try {
          return DateTime.parse(v);
        } catch (_) {}
      }
      return DateTime.now();
    }

    return Note(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      isDone: json['isDone'] == true,
      createdAt: parseDate(json['createdAt']),
      color: _parseColor(json['color']), // ✅ lấy color từ API
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
    'color': color, // ✅ gửi lên API
  };

  Map<String, dynamic> toCreateJson() => {
    'title': title,
    'content': content,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
    'color': color, // ✅ gửi lên API khi tạo mới
  };

  Note copyWith({
    String? id,
    String? title,
    String? content,
    bool? isDone,
    DateTime? createdAt,
    int? color, // ✅ thêm
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
    );
  }
}
