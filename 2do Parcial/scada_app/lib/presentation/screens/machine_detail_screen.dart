import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/providers/providers.dart';
import '../../data/models/machine_model.dart';
import '../utils/base_screen_state.dart';



class MachineDetailScreen extends ConsumerStatefulWidget {
  const MachineDetailScreen({super.key, required this.machineId});
  
  final int machineId;

  @override
  MachineDetailScreenState createState() => MachineDetailScreenState();
}

class MachineDetailScreenState extends ConsumerState<MachineDetailScreen> {
  
  final PageController _pageController = PageController();
  
  bool onRefresh = false;
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  


  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(machineDetailProvider.notifier).getMachineById(widget.machineId);
    });
  }

  @override
  void dispose() {
    
    _pageController.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine detail"),
        centerTitle: true,
      ),
      
      body: Builder(builder: (context) {
      
        final machinesProvider = ref.watch(machineDetailProvider);
      
        switch(machinesProvider.screenState) {
          case BaseScreenState.loading:
          
            if(onRefresh) {
              
              final machine = machinesProvider.machine!;
      
              return _GeneralDetail(machine: machine);
              
            }else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          case BaseScreenState.idle:
            onRefresh = false;
            final machine = machinesProvider.machine;
            final isAdminLvl = machinesProvider.isAdminLvl;
              
            return PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _GeneralDetail(machine: machine),
                _StatisticsDetail(machine: machine),
                _InformationDetail(machine: machine, enableLongPress: isAdminLvl, pageController: _pageController),
              ],
            );
              
          case BaseScreenState.error:
            return const Center(child: Text('Error loading data'));
         
          default:
            return const Center(child: Text('Nothing to show'));
        }
      
      }),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  /// Este es el navigation bar
  Widget _bottomNavigationBar() {

    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: isThemeLight ? Colors.white : Colors.grey.shade900,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomBarItem(Icons.home, "General", 0),
          _bottomBarItem(Icons.bar_chart, "Stats", 1),
          _bottomBarItem(Icons.info, "Info", 2),
        ],
      ),
    );
  }

  // Estos son los botones del navigation bar
  Widget _bottomBarItem(IconData icon, String label, int index) {

    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              icon,
              color: isSelected ? Colors.blue.shade600 : Colors.blueGrey.shade500,
              size: 34,
            ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: isThemeLight ? (isSelected ? Colors.black : Colors.grey.shade500) : 
                                    (isSelected ? Colors.white : Colors.grey.shade500),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}


class _GeneralDetail extends ConsumerWidget {
  const _GeneralDetail({
    required this.machine
  });

  final MachineModel? machine;
 

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [



            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: (machine?.maxProduce ?? 1).toDouble(),
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.2,
                    color: isThemeLight ? 
                      Colors.grey.shade300 : Colors.grey.shade800,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: (machine?.produced ?? 0).toDouble(),
                      width: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: isThemeLight ? 
                      Colors.blueAccent : Colors.greenAccent,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(machine?.produced ?? 0).toStringAsFixed(0)} units',
                            style: TextStyle(
                              fontSize: 40,
                              color: isThemeLight ? 
                              Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'produced',
                            style: TextStyle(
                              fontSize: 16,
                              color: isThemeLight ? 
                              Colors.grey.shade700 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      positionFactor: 0.1,
                      angle: 90,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _machineInfoCard(ref, 'Prod. per hour', "${(machine?.prodPerHour ?? 0).toStringAsFixed(1)} U/H", "Quantity produced per hour\n[Units per hour]"),
                _machineInfoCard(ref, 'Productivity', '${(machine?.productivity ?? 0).toStringAsFixed(1)} U/H', "Quantity produced per hour with machine active\n[Units per hour]"),
              ],
            ),
            const SizedBox(height: 30),

            _machineStatusCard(ref, machine?.getStateE() ?? MachineStatusE.detachState, machine?.stateTime ?? 0),


          ],
        ),
      ),
    );
  }



  Widget _machineInfoCard(WidgetRef ref, String title, String subtitle, String msjTooltip) {

    final appTheme = ref.watch(themeNotifierProvider);

    return Tooltip(
      message: msjTooltip,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: (appTheme.isLigthMode()) ? 
            Colors.grey.shade300 : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: (appTheme.isLigthMode()) ? 
                  Colors.black : Colors.grey,
                  ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                softWrap: true,
                style: TextStyle(
                  color: (appTheme.isLigthMode()) ? 
                  Colors.black : Colors.white,
                  fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _machineStatusCard(WidgetRef ref, MachineStatusE status, int time) {
    final appTheme = ref.watch(themeNotifierProvider);

    Color iconColor;
    IconData icon;
    String statusText;

    switch (status) {
      case MachineStatusE.activeState:
        icon = Icons.flash_on;
        iconColor = Colors.green;
        statusText = 'Online';
        break;
      case MachineStatusE.onState:
        icon = Icons.play_circle_fill;
        iconColor = Colors.blue;
        statusText = 'Active';
        break;
      case MachineStatusE.offState:
        icon = Icons.power_off;
        iconColor = Colors.red;
        statusText = 'Offline';
        break;
      case MachineStatusE.detachState:
        icon = Icons.link_off;
        iconColor = Colors.orange;
        statusText = 'Detach';
        break;
      default:
        icon = Icons.info;
        iconColor = Colors.grey;
        statusText = 'Desconocido';
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: appTheme.isLigthMode() ? Colors.grey.shade300 : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                statusText,
                style: TextStyle(
                  color: appTheme.isLigthMode() ? Colors.black : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'till ${time}h',
                style: TextStyle(
                  color: appTheme.isLigthMode() ? Colors.grey.shade800 : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40),

          Icon(
            icon,
            color: iconColor,
            size: 35,
          ),
        ],
      ),
    );
  }
}




final touchedIndexProvider = StateProvider<int>((ref) => -1);

class _StatisticsDetail extends ConsumerWidget {
  const _StatisticsDetail({
    required this.machine,
  });

  final MachineModel? machine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final touchedIndex = ref.watch(touchedIndexProvider);

    List<FlSpot> points = List.generate(
      (machine?.prodOverTimeX.length) ?? 0,
      (index) => FlSpot(machine?.prodOverTimeX[index] ?? 0, machine?.prodOverTimeY[index] ?? 0),
    );

    List<FlSpot> tempPoints = List.generate(
      (machine?.tempOverTimeX.length) ?? 0,
      (index) => FlSpot(machine?.tempOverTimeX[index] ?? 0, machine?.tempOverTimeY[index] ?? 0),
    );
    

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            const Text(
        "Graph of production over time",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),


            const SizedBox(height: 20),


            Center(
              child: SizedBox(

                width: 300,
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: points,
                        isCurved: false,
                        preventCurveOverShooting: true,
                        color:Colors.blue,
                        barWidth: 4,
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 20),

            const Text(
              "Pi chart of machine status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            Center(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                if (!event.isInterestedForInteractions || pieTouchResponse?.touchedSection == null) {
                                  ref.read(touchedIndexProvider.notifier).state = -1;
                                } else {
                                  ref.read(touchedIndexProvider.notifier).state =
                                      pieTouchResponse!.touchedSection!.touchedSectionIndex;
                                }
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(ref, touchedIndex, machine?.porcOnline ?? 0, machine?.porcOffline ?? 0, machine?.porcActive ?? 0),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        indicator(Colors.greenAccent, 'Online', true, 4),
                        SizedBox(height: 4),
                        indicator(Colors.redAccent, 'Offline', true, 4),
                        SizedBox(height: 4),
                        indicator(Colors.orangeAccent, 'Active', true, 4),
                      ],
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
              ),
            ),
          
            buildLabel(touchedIndex, machine?.timeOnline ?? 0, machine?.timeOffline ?? 0, machine?.timeActive ?? 0),

            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 20),

            const Text(
              "Graph of temperature over time",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            
            const SizedBox(height: 20),

            Center(
              child: SizedBox(

                width: 300,
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: tempPoints,
                        isCurved: false,
                        preventCurveOverShooting: true,
                        color:Colors.blue,
                        barWidth: 4,
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<PieChartSectionData> showingSections(WidgetRef ref, int touchedIndex, double porcOnline, double porcOffline, double porcActive) {
    
    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();
    const shadows = [Shadow(color: Colors.white, blurRadius: 1)];
    
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: porcOnline,
            title: '${porcOnline.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
              color: isThemeLight ? Colors.black : Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orangeAccent,
            value: porcActive,
            title: '${porcActive.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
              color: isThemeLight ? Colors.black : Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.redAccent,
            value: porcOffline,
            title: '${porcOffline.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
              color: isThemeLight ? Colors.black : Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  Widget indicator(Color color, String text, bool isSquare, double size) {
  
  return Row(
    children: <Widget>[
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          color: color,
        ),
      ),
      const SizedBox(
        width: 4,
      ),
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
  }

  Widget buildLabel(int touchedIndex, double timeOnline, double timeOffline, double timeActive) {
  
    String labelText;
    
    switch (touchedIndex) {
      case 0:
        labelText = 'Status: Online\n Online time: ${timeOnline.toStringAsFixed(1)}h \n(machine ON but not producing)';
        break;
      case 1:
        labelText = 'Status: Active\n Active time: ${timeActive.toStringAsFixed(1)}h \n(machine ON and producing)';
        break;
      case 2:
        labelText = 'Status: Offline\n Offline time: ${timeOffline.toStringAsFixed(1)}h \n(machine OFF)';
        break;
      default:
        labelText = 'Select a slice \n \n';
    }

    return Text(
      labelText,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

}





class _InformationDetail extends ConsumerWidget {
  const _InformationDetail({
    required this.machine,
    required this.enableLongPress,
    required this.pageController,
  });

  final MachineModel? machine;
  final bool enableLongPress;
  final PageController pageController;


  Future<XFile?> selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> takePictureWithCamera() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.camera);
  }
 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    return SingleChildScrollView(

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            
            // Imagen de la máquina
            Center(
              child: Container(

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15),
                  // Le vamos a generar una sombra a la imagen
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onLongPress: enableLongPress ? () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Wrap(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a picture'),
                                onTap: () async {

                                  final image = await takePictureWithCamera();
                                  await ref.read(machineDetailProvider.notifier).setImageToMachineId(machine!.id, image);

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.of(context).pop();

                                    pageController.animateToPage(
                                    3,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo),
                                title: Text('Select from gallery'),
                                onTap: () async {
                                  
                                  final image = await selectImageFromGallery();

                                  if(image != null) {
                                    await ref.read(machineDetailProvider.notifier).setImageToMachineId(machine!.id, image);
                                  }

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.of(context).pop();

                                    pageController.animateToPage(
                                      3,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } : null,
                  
                  
                  
                    child: Builder(builder: (context) {

                      // Si no le cargamos una posterURL al crearla nos muestra la
                      // siguiente imagen

                      if(machine == null || machine?.imageUrl == null) {
                        return Image.asset(
                          "assets/images/Type_NoImage.png",
                          height: 200,
                        );
                      }else {
                        return Image.network(
                          machine!.imageUrl!,
                          height: 200,
                          fit: BoxFit.cover,

                          // Si lo cargamos pero no lo encuentra entre los datos

                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {  
                            return Image.asset(
                              "assets/images/Type_NotFound.webp",
                              height: 200,
                            );
                          },
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
      
            // Separador
            const Divider(thickness: 2),

            const SizedBox(height: 20),
      
            // Tipo de maquina
            Text(
              'Machine type: ${machine?.getType() ?? "Unknown"}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),

             // nombre de maquina
            Text(
              'Machine name: ${machine?.name ?? "Unknown"}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
      
            // Marca
            Text(
              'Brand: ${machine?.brand}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
      
            // Descripcion
            Text(
              'Description: ${machine?.description}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 60),


          ],
        ),
      ),
    );
  }
}