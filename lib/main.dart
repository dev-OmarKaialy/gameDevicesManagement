import 'package:flutter/material.dart';
import 'package:flutter_application_1/device.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(DeviceTypeAdapter());
  await Hive.openBox<Device>('devices');
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Device> devices = [];
  @override
  void initState() {
    final x = Hive.box<Device>('devices').values;
    devices.addAll(x);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Devices',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(devices[index].name),
              closeOnScroll: true,
              endActionPane: ActionPane(
                  extentRatio: .2,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(12),
                      padding: EdgeInsets.zero,
                      autoClose: true,
                      flex: 1,
                      onPressed: (_) async {
                        devices[index].status = !devices[index].status;
                        await Hive.box<Device>('devices')
                            .putAt(index, devices[index]);
                        setState(() {});
                      },
                      backgroundColor: Colors.green[200]!,
                      foregroundColor: Colors.green,
                      icon: Icons.edit,
                    )
                  ]),
              startActionPane: ActionPane(
                  extentRatio: .2,
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(12),
                      padding: EdgeInsets.zero,
                      autoClose: true,
                      flex: 1,
                      onPressed: (_) async {
                        devices.removeAt(index);
                        await Hive.box<Device>('devices').deleteAt(index);
                        setState(() {});
                      },
                      backgroundColor: Colors.red[200]!,
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                    )
                  ]),
              child: Card(
                shadowColor: Colors.black,
                elevation: 2,
                child: ListTile(
                  leading: switch (devices[index].type) {
                    DeviceType.pc => const Icon(Icons.computer),
                    DeviceType.playstation => const Icon(Icons.abc_sharp),
                    DeviceType.xbox => const Icon(Icons.mobile_friendly),
                    _ => const Icon(Icons.remove)
                  },
                  title: Text(devices[index].name),
                  subtitle: Text('${devices[index].price} SYP / hr'),
                  trailing: Icon(
                    Icons.circle,
                    color: devices[index].status ? Colors.green : Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController deviceName = TextEditingController();
          TextEditingController pricePerHour = TextEditingController();
          DeviceType type = DeviceType.pc;
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheet(
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: deviceName,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            label: const Text('Device\'s Name'),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              label: const Text('Device Type'),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: DeviceType.playstation,
                                child: Text(DeviceType.playstation.name),
                              ),
                              DropdownMenuItem(
                                value: DeviceType.pc,
                                child: Text(DeviceType.pc.name),
                              ),
                              DropdownMenuItem(
                                value: DeviceType.xbox,
                                child: Text(DeviceType.xbox.name),
                              ),
                            ],
                            onChanged: (s) {
                              type = s!;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: pricePerHour,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            label: const Text('Price Per Hour'),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Device s = Device(
                                name: deviceName.text,
                                price: double.parse(pricePerHour.text),
                                status: true,
                                type: type,
                              );
                              await Hive.box<Device>('devices').add(s);
                              setState(() {
                                devices.add(s);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'))
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
