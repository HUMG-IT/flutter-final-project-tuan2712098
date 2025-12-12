import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import 'note_form_screen.dart';

enum _MenuAction { toggleTheme, search, refresh, toggleEdit }

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NoteProvider>().loadNotes());
  }

  Future<void> _refresh() async {
    await context.read<NoteProvider>().loadNotes();
  }

  void _openCreateNote() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NoteFormScreen()));
  }

  void _openEditNote(Note note) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => NoteFormScreen(note: note)));
  }

  Future<void> _onMenuSelected(
    _MenuAction action,
    NoteProvider provider,
  ) async {
    if (action == _MenuAction.toggleTheme) {
      context.read<ThemeProvider>().toggle();
      return;
    }

    if (action == _MenuAction.refresh) {
      await provider.loadNotes();
      return;
    }

    if (action == _MenuAction.toggleEdit) {
      setState(() => _editMode = !_editMode);
      return;
    }

    if (action == _MenuAction.search) {
      final selected = await showSearch<Note?>(
        context: context,
        delegate: NoteSearchDelegate(provider.notes),
      );

      if (!mounted || selected == null) return;

      if (_editMode) {
        _openEditNote(selected);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bật “Chỉnh sửa” trong menu ⋮ để sửa ghi chú.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú cá nhân'),
        actions: [
          PopupMenuButton<_MenuAction>(
            onSelected: (v) => _onMenuSelected(v, provider),
            itemBuilder: (_) => [
              CheckedPopupMenuItem<_MenuAction>(
                value: _MenuAction.toggleTheme,
                checked: theme.isDark,
                child: const Text('Chế độ tối'),
              ),
              CheckedPopupMenuItem<_MenuAction>(
                value: _MenuAction.toggleEdit,
                checked: _editMode,
                child: const Text('Chỉnh sửa'),
              ),
              const PopupMenuItem<_MenuAction>(
                value: _MenuAction.search,
                child: Text('Tìm kiếm'),
              ),
              const PopupMenuItem<_MenuAction>(
                value: _MenuAction.refresh,
                child: Text('Làm mới'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(onRefresh: _refresh, child: _buildBody(provider)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateNote,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Thêm ghi chú"),
      ),
    );
  }

  Widget _buildBody(NoteProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(
            title: "Có lỗi khi tải dữ liệu",
            subtitle: provider.errorMessage!,
            icon: Icons.error_outline_rounded,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => provider.loadNotes(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Thử lại"),
          ),
        ],
      );
    }

    final notes = provider.notes;

    if (notes.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _InfoCard(
            title: "Chưa có ghi chú",
            subtitle: "Nhấn “Thêm ghi chú” để tạo mới.",
            icon: Icons.note_add_outlined,
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final note = notes[index];

        final tile = NoteTile(
          note: note,
          editMode: _editMode,
          onToggleDone: (_) => provider.toggleDone(note),
          onDelete: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Xóa ghi chú'),
                content: Text('Bạn có chắc muốn xóa “${note.title}” không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Hủy'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Xóa'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await provider.deleteNote(note);
            }
          },
          onOpen: () => _openEditNote(note),
        );

        if (!_editMode) return tile;

        return Dismissible(
          key: ValueKey(note.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Xóa ghi chú'),
                content: Text('Bạn có chắc muốn xóa “${note.title}” không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Hủy'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Xóa'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) async {
            await provider.deleteNote(note);
          },
          child: tile,
        );
      },
    );
  }
}

class NoteTile extends StatelessWidget {
  final Note note;
  final bool editMode;
  final ValueChanged<bool?> onToggleDone;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  const NoteTile({
    super.key,
    required this.note,
    required this.editMode,
    required this.onToggleDone,
    required this.onDelete,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Color(note.color); // ✅ hiện màu note
    final brightness = ThemeData.estimateBrightnessForColor(bg);
    final titleColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
    final subColor = brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Card(
      color: bg,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: editMode ? onOpen : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: note.isDone,
                onChanged: editMode ? onToggleDone : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: titleColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusPill(isDone: note.isDone),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: subColor),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 16, color: subColor),
                        const SizedBox(width: 4),
                        Text(
                          _prettyDate(note.createdAt),
                          style: TextStyle(color: subColor, fontSize: 12.5),
                        ),
                        const Spacer(),
                        if (editMode)
                          IconButton(
                            tooltip: "Xóa",
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _prettyDate(DateTime d) {
    String two(int x) => x.toString().padLeft(2, '0');
    return "${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}";
  }
}

class _StatusPill extends StatelessWidget {
  final bool isDone;
  const _StatusPill({required this.isDone});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = isDone
        ? Colors.green.withOpacity(0.12)
        : cs.primary.withOpacity(0.12);
    final fg = isDone ? Colors.green.shade700 : cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
      ),
      child: Text(
        isDone ? "Done" : "Todo",
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: fg),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate<Note?> {
  final List<Note> notes;
  NoteSearchDelegate(this.notes);

  @override
  String? get searchFieldLabel => 'Tìm theo tiêu đề / nội dung';

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  // ✅ query rỗng => TRỐNG (không show list sẵn)
  List<Note> _filtered() {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return notes.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final result = _filtered();

    if (query.trim().isEmpty) {
      return const Center(child: Text('Nhập từ khóa để tìm kiếm'));
    }

    if (result.isEmpty) {
      return const Center(child: Text('Không tìm thấy ghi chú'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: result.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final n = result[i];
        return Card(
          color: Color(n.color),
          child: ListTile(
            title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              n.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(n.isDone ? 'Done' : 'Todo'),
            onTap: () => close(context, n),
          ),
        );
      },
    );
  }
}
