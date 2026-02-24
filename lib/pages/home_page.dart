import 'package:flutter/material.dart';
import 'package:yourwish/models/wish.dart';
import 'add_page.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Wish> wishes = [];
  @override
  void initState() {
    super.initState();

    wishes = [
      Wish(
        id: '1',
        title: 'Wardah Acnederm Facewash',
        price: '35000',
        category: 'Skincare',
        notes: 'Buy at Shopee',
      ),
      Wish(
        id: '2',
        title: 'Pink Tote Bag',
        price: '75000',
        category: 'Fashion',
        notes: 'For campus',
      ),
      Wish(
        id: '3',
        title: 'Implora Lip Cream',
        price: '18000',
        category: 'Makeup',
        notes: 'Shade favorite No.2',
      ),
      Wish(
        id: '4',
        title: 'Novel Dilan 1990 by Pidi Baiq',
        price: '89000',
        category: 'Buku',
        notes: 'Weekend reading, yeyy',
      ),
      Wish(
        id: '5',
        title: 'Skintific Sunscreen',
        price: '65000',
        category: 'Skincare',
        notes: 'Sunscreen serum 5X Ceramide',
      ),
      Wish(
        id: '6',
        title: 'Cute Cardigan',
        price: '120000',
        category: 'Fashion',
        notes: 'Pink aesthetic',
      ),
      Wish(
        id: '7',
        title: 'Matcha Powder',
        price: '55000',
        category: 'Makanan',
        notes: 'For homemade matcha',
      ),
      Wish(
        id: '8',
        title: 'Bluetooth Earbuds',
        price: '199000',
        category: 'Lainnya',
        notes: 'For study',
      ),
      Wish(
        id: '9',
        title: 'Desk Organizer',
        price: '45000',
        category: 'Lainnya',
        notes: 'Keep desk tidy',
      ),
      Wish(
        id: '10',
        title: 'Body Mist',
        category: 'Skincare',
        notes: 'Daily fragrance',
      ),
  ];
}
  int currentPage = 0;

  void tambahWish(Wish wish) {
    setState(() {
      wishes.add(wish); 
      currentPage = 2; 
    });
  }

  void hapusWish(String id) {
    setState(() {
      wishes.removeWhere((w) => w.id == id);
    });
  }

  void editWish(Wish wishBaru) {
    setState(() {
      final index = wishes.indexWhere((w) => w.id == wishBaru.id);
      if (index != -1) {
        wishes[index] = wishBaru;
      }
      currentPage = 2; 
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget halamanAktif;

    if (currentPage == 0) {
      halamanAktif = _HalamanHome(
        jumlahWish: wishes.length,
        onMulai: () => setState(() => currentPage = 1),
      );
    } else if (currentPage == 1) {
      halamanAktif = AddPage(
        onSimpan: tambahWish,
      );
    } else {
      halamanAktif = ListPage(
        wishes: wishes,
        onHapus: hapusWish,
        onEdit: (wish) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => AddPage(
              wishYangDiedit: wish,
              onSimpan: editWish,
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      appBar: currentPage != 0
          ? AppBar(
              backgroundColor: const Color(0xFFFFF8FB),
              elevation: 0,
              centerTitle: true,
              title: Padding(padding: const EdgeInsets.only(top: 10),
              child: Text(
                currentPage == 1 ? 'Add Your Wish' : 'Your Wish List',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A1A22),
                ),
              ),
            )
          )
          : null,

      body: halamanAktif,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage == 0 ? 0 : currentPage,
        onTap: (index) => setState(() => currentPage = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 232, 135, 166),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Wishlist',
          ),
        ],
      ),
    );
  }
}

class _HalamanHome extends StatelessWidget {
  final int jumlahWish;
  final VoidCallback onMulai;

  const _HalamanHome({
    required this.jumlahWish,
    required this.onMulai,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF0F6), Color(0xFFFFF8FB)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon besar
          const Icon(
            Icons.favorite_rounded,
            size: 100,
            color: Color.fromARGB(255, 232, 135, 166),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Wish',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A1A22),
            ),
          ),
          ElevatedButton(
            onPressed: onMulai,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 232, 135, 166),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Start adding your dream items.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}