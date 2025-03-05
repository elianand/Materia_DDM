import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:scada_app/presentation/utils/base_screen_state.dart';

import '../../data/models/company_model.dart';
import '../../core/providers/providers.dart';
import '../widgets/minimap.dart';


class CompanyDetailsScreen extends ConsumerStatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  CompanyDetailsScreenState createState() => CompanyDetailsScreenState();
}

class CompanyDetailsScreenState extends ConsumerState<CompanyDetailsScreen> {
  

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyProvider.notifier).getCompany();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {

        final provider = ref.watch(companyProvider);
        

        switch(provider.screenState) {
          case BaseScreenState.loading:
            return SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            );
          case BaseScreenState.idle:

            return CompanyDetail(company: provider.company);
            
            
          case BaseScreenState.error:

            return const Text(
              'Error',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            );
        }
      }),
    );  
  }
}


class CompanyDetail extends ConsumerWidget {
  final CompanyModel? company;

  const CompanyDetail({super.key, required this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Perfil
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  company?.name[0].toUpperCase() ?? "N",
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 10),
              Text(
                company?.name ?? "NaN",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                "Company Id: #${company?.idComp.toString() ?? "NaN"}",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),

              SizedBox(height: 20),
              // Información del usuario
              _buildInfoTile(
                context,
                ref,
                icon: Icons.person,
                label: 'Name',
                value: company?.name ?? "NaN",
              ),
              _buildInfoTile(
                context,
                ref,
                icon: Icons.email,
                label: 'Email',
                value: company?.email ?? "NaN",
              ),
              _buildInfoTile(
                context,
                ref,
                icon: Icons.flag,
                label: 'Country',
                value: company?.country ?? "NaN",
              ),
              _buildInfoTile(
                context,
                ref,
                icon: Icons.location_city,
                label: 'City',
                value: company?.city ?? "NaN",
              ),
              
              _buildInfoTile(
                context,
                ref,
                icon: Icons.phone,
                label: 'Phone number',
                value: company?.phoneNum ?? "NaN",
              ),
      
              _buildInfoTile(
                context,
                ref,
                icon: Icons.location_on,
                label: 'Street address',
                value: company?.streetAddress ?? "NaN",
              ),

              SizedBox(height: 20),

              // Minimapa
              Text(
                'Company Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              _miniMap(double.parse(company?.locationLat ?? "0"), double.parse(company?.locationLong ?? "0")),
              
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, WidgetRef ref, {required IconData icon, required String label, required String value, bool isDropdown = false}) {
    
    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(label),
        subtitle: Text(value),
        trailing: isDropdown ? Icon(Icons.arrow_drop_down) : null,
        tileColor: isThemeLight? Colors.grey.shade300 : Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }


  Widget _miniMap(double locationLat, double locationLong) {

    if(locationLat == 0 || locationLong == 0) {
      return SizedBox(height: 200);
    }else {
      return SizedBox(
        height: 200,
        child: OpenMinimap(
          height: 200,
          zoom: 16,
          centerLocation: LatLng(locationLat, locationLong),
          marker: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ),
      );
    }
  }
}