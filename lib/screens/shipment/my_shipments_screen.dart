import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shipment_provider.dart';

class MyShipmentsScreen extends StatefulWidget {
  const MyShipmentsScreen({super.key});

  @override
  State<MyShipmentsScreen> createState() => _MyShipmentsScreenState();
}

class _MyShipmentsScreenState extends State<MyShipmentsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadShipments();
  }

  Future<void> _loadShipments() async {
    setState(() => _isLoading = true);
    try {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        await Provider.of<ShipmentProvider>(context, listen: false)
            .fetchMyShipments(userId);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Expéditions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ShipmentProvider>(
              builder: (context, shipmentProvider, child) {
                final shipments = shipmentProvider.shipments;
                if (shipments.isEmpty) {
                  return const Center(
                    child: Text('Aucune expédition trouvée'),
                  );
                }
                return ListView.builder(
                  itemCount: shipments.length,
                  itemBuilder: (context, index) {
                    final shipment = shipments[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(shipment['description'] ?? ''),
                        subtitle: Text(
                          'De: ${shipment['origin']}\nVers: ${shipment['destination']}',
                        ),
                        trailing: Text(
                          shipment['status'] ?? 'En attente',
                          style: TextStyle(
                            color: _getStatusColor(shipment['status']),
                          ),
                        ),
                        onTap: () {
                          // Navigate to shipment details
                        },
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/new-shipment'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'en cours':
        return Colors.blue;
      case 'terminé':
        return Colors.green;
      case 'annulé':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
