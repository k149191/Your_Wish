import 'package:flutter/material.dart';
import 'package:yourwish/models/wish.dart';

const pinkPrimary = Color.fromARGB(255, 232, 135, 166);

class ListPage extends StatefulWidget {
  final List<Wish> wishes;
  final Function(String) onHapus;
  final Function(Wish) onEdit;

  const ListPage({
    super.key,
    required this.wishes,
    required this.onHapus,
    required this.onEdit,
  });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<Wish> filteredWishes;
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredWishes = List.from(widget.wishes);
  }

  @override
  void didUpdateWidget(covariant ListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    filteredWishes = List.from(widget.wishes);
    applyFilter();
  }

  void applyFilter() {
    setState(() {
      filteredWishes = widget.wishes.where((wish) {
        final matchSearch =
            wish.title.toLowerCase().contains(searchQuery.toLowerCase());

        final matchCategory =
            selectedCategory == 'All' || wish.category == selectedCategory;

        return matchSearch && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search wishlist...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFFF0F6),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: pinkPrimary.withOpacity(0.35),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: pinkPrimary,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              searchQuery = value;
              applyFilter();
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFFFF0F6),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: pinkPrimary.withOpacity(0.35),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: pinkPrimary,
                  width: 2,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'All', child: Text('All')),
              DropdownMenuItem(value: 'Skincare', child: Text('Skincare')),
              DropdownMenuItem(value: 'Makeup', child: Text('Makeup')),
              DropdownMenuItem(value: 'Fashion', child: Text('Fashion')),
              DropdownMenuItem(value: 'Buku', child: Text('Buku')),
              DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
              DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
            ],
            onChanged: (value) {
              selectedCategory = value!;
              applyFilter();
            },
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: filteredWishes.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 80,
                        color: Color(0xFFFFB3D1),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No matching wish found.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredWishes.length,
                  itemBuilder: (context, index) {
                    final wish = filteredWishes[index];
                    return _KartuWish(
                      wish: wish,
                      onHapus: () => _konfirmasiHapus(context, wish),
                      onEdit: () => widget.onEdit(wish),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _konfirmasiHapus(BuildContext context, Wish wish) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Delete Your Wish?'),
        content: Text('Sure Deleting ${wish.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('No', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onHapus(wish.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 232, 135, 166),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _KartuWish extends StatelessWidget {
  final Wish wish;
  final VoidCallback onHapus;
  final VoidCallback onEdit;

  const _KartuWish({
    required this.wish,
    required this.onHapus,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE0EE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8185A).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🩷', style: TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wish.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A1A22),
                    ),
                  ),
                  if (wish.price.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${wish.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE8185A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (wish.category.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F6),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: const Color(0xFFFFE0EE)),
                      ),
                      child: Text(
                        wish.category,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9B7A8A),
                        ),
                      ),
                    ),
                  ],
                  if (wish.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      wish.notes,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded),
                  color: const Color.fromARGB(255, 232, 135, 166),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF0F6),
                  ),
                ),
                IconButton(
                  onPressed: onHapus,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: const Color.fromARGB(255, 232, 135, 166),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF0F0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}