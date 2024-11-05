import 'package:flutter/material.dart';

class ManagementPersonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Personal',
      home: const EmployeeList(),
    );
  }
}

class Employee {
  String id;
  String name;
  String position;

  Employee({required this.id, required this.name, required this.position});
}

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> employees = [];

  void navigateToAddEmployee() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EmployeeForm(onSave: (employee) {
                setState(() {
                  employees.add(employee);
                });
              })),
    );
  }

  void navigateToEditEmployee(Employee employee) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EmployeeForm(
                onSave: (updatedEmployee) {
                  setState(() {
                    int index =
                        employees.indexWhere((e) => e.id == employee.id);
                    employees[index] = updatedEmployee;
                  });
                },
                employee: employee,
              )),
    );
  }

  void navigateToDetails(Employee employee) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EmployeeDetails(employee: employee)),
    );
  }

  void deleteEmployee(String id) {
    setState(() {
      employees.removeWhere((e) => e.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Empleados'),
        backgroundColor: Colors.blue, // Color de fondo de la AppBar

        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddEmployee,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(employees[index].name),
            subtitle: Text(employees[index].position),
            onTap: () => navigateToDetails(employees[index]),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => navigateToEditEmployee(employees[index]),
            ),
          );
        },
      ),
    );
  }
}

class EmployeeForm extends StatelessWidget {
  final Function(Employee) onSave;
  final Employee? employee;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  EmployeeForm({required this.onSave, this.employee}) {
    if (employee != null) {
      nameController.text = employee!.name;
      positionController.text = employee!.position;
    }
  }

  void saveEmployee(BuildContext context) {
    final String id = employee?.id ?? DateTime.now().toString();
    final String name = nameController.text;
    final String position = positionController.text;

    if (name.isNotEmpty && position.isNotEmpty) {
      onSave(Employee(id: id, name: name, position: position));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employee == null ? 'Agregar Empleado' : 'Editar Empleado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: positionController,
              decoration: InputDecoration(labelText: 'Posición'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => saveEmployee(context),
              child: Text(employee == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeDetails extends StatelessWidget {
  final Employee employee;

  EmployeeDetails({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Empleado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${employee.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Posición: ${employee.position}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Confirmar eliminación
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Eliminar Empleado'),
                      content: Text(
                          '¿Estás seguro de que deseas eliminar a ${employee.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Aquí deberías llamar a la función para eliminar
                            (context.findAncestorStateOfType<
                                    _EmployeeListState>()!)
                                .deleteEmployee(employee.id);
                            Navigator.of(context).pop();
                          },
                          child: Text('Eliminar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Eliminar Empleado'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
