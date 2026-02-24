import 'package:flutter/material.dart';
import 'package:yourwish/models/wish.dart';

class AddPage extends StatefulWidget {
  final Wish? wishYangDiedit; 
  final Function(Wish) onSimpan;

  const AddPage({
    super.key,
    this.wishYangDiedit,
    required this.onSimpan,
  });

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  String _kategoriDipilih = 'Skincare';
  final List<String> _daftarKategori = [
    'Makeup',
    'Skincare',
    'Fashion',
    'Buku',
    'Makanan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.wishYangDiedit != null) {
      _titleController.text = widget.wishYangDiedit!.title;
      _priceController.text = widget.wishYangDiedit!.price;
      _notesController.text = widget.wishYangDiedit!.notes;
      _kategoriDipilih = widget.wishYangDiedit!.category.isEmpty
          ? 'Skincare'
          : widget.wishYangDiedit!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title is required'),
          backgroundColor: Color.fromARGB(255, 232, 135, 166),
        ),
      );
      return;
    }

    final wishBaru = Wish(
      id: widget.wishYangDiedit?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      price: _priceController.text.trim(),
      category: _kategoriDipilih,
      notes: _notesController.text.trim(),
    );

    widget.onSimpan(wishBaru);

    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelField('Title *'),
          TextField(
            controller: _titleController,
            decoration: _inputDecor('e.g. Wardah Acnederm Facewash'),
          ),
          const SizedBox(height: 16),

          _labelField('Price'),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: _inputDecor('e.g. 35000')
          ),
          const SizedBox(height: 16),

          _labelField('Category'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE0EE), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _kategoriDipilih,
                isExpanded: true,
                onChanged: (nilai) {
                  if (nilai != null) {
                    setState(() => _kategoriDipilih = nilai);
                  }
                },
                items: _daftarKategori
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _labelField('Notes'),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: _inputDecor('Add notes (e.g. why you want this, where to buy)'),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _simpan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 232, 135, 166),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
               child: Text( 'Add to your wish list.',
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelField(String teks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF9B7A8A),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFE0EE), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFE0EE), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF80B3), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}