import 'package:flutter/material.dart';
import 'database_helper.dart'; 

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final dbHelper = DatabaseHelper();
  List<Estudiante> estudiantes = [];

  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController fechaIngresoController = TextEditingController();
  TextEditingController edadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarEstudiantes();
  }

  Future<void> cargarEstudiantes() async {
    estudiantes = await dbHelper.getEstudiantes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD SQLite',
      home: Scaffold(
        appBar: AppBar(title: Text('CRUD SQLite')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Agregar Estudiante'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: nombreController,
                                decoration: InputDecoration(labelText: 'Nombre'),
                              ),
                              TextField(
                                controller: correoController,
                                decoration: InputDecoration(labelText: 'Correo'),
                              ),
                              TextField(
                                controller: fechaIngresoController,
                                decoration: InputDecoration(labelText: 'Fecha de Ingreso'),
                              ),
                              TextField(
                                controller: edadController,
                                decoration: InputDecoration(labelText: 'Edad'),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await dbHelper.insertEstudiante(Estudiante(
                                nombre: nombreController.text,
                                correo: correoController.text,
                                fechaIngreso: fechaIngresoController.text,
                                edad: int.parse(edadController.text),
                              ));
                              nombreController.clear();
                              correoController.clear();
                              fechaIngresoController.clear();
                              edadController.clear();
                              cargarEstudiantes();
                              Navigator.of(context).pop();
                            },
                            child: Text('Guardar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Agregar Estudiante'),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: estudiantes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == estudiantes.length) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.add),
                          title: Text('Agregar Estudiante'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Agregar Estudiante'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: nombreController,
                                          decoration: InputDecoration(labelText: 'Nombre'),
                                        ),
                                        TextField(
                                          controller: correoController,
                                          decoration: InputDecoration(labelText: 'Correo'),
                                        ),
                                        TextField(
                                          controller: fechaIngresoController,
                                          decoration: InputDecoration(labelText: 'Fecha de Ingreso'),
                                        ),
                                        TextField(
                                          controller: edadController,
                                          decoration: InputDecoration(labelText: 'Edad'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await dbHelper.insertEstudiante(Estudiante(
                                          nombre: nombreController.text,
                                          correo: correoController.text,
                                          fechaIngreso: fechaIngresoController.text,
                                          edad: int.parse(edadController.text),
                                        ));
                                        nombreController.clear();
                                        correoController.clear();
                                        fechaIngresoController.clear();
                                        edadController.clear();
                                        cargarEstudiantes();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Guardar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    }

                    final estudiante = estudiantes[index];
                    return Card(
                      child: ListTile(
                        title: Text(estudiante.nombre),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Editar Estudiante'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: TextEditingController(text: estudiante.nombre),
                                              decoration: InputDecoration(labelText: 'Nombre'),
                                            ),
                                            TextField(
                                              controller: TextEditingController(text: estudiante.correo),
                                              decoration: InputDecoration(labelText: 'Correo'),
                                            ),
                                            TextField(
                                              controller: TextEditingController(text: estudiante.fechaIngreso),
                                              decoration: InputDecoration(labelText: 'Fecha de Ingreso'),
                                            ),
                                            TextField(
                                              controller: TextEditingController(text: estudiante.edad.toString()),
                                              decoration: InputDecoration(labelText: 'Edad'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await dbHelper.updateEstudiante(Estudiante(
                                              id: estudiante.id,
                                              nombre: nombreController.text,
                                              correo: correoController.text,
                                              fechaIngreso: fechaIngresoController.text,
                                              edad: int.parse(edadController.text),
                                            ));
                                            cargarEstudiantes();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Guardar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await dbHelper.deleteEstudiante(estudiante.id!);
                                cargarEstudiantes();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
