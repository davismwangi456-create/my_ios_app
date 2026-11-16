import 'package:flutter/material.dart';

void main() {
  runApp(const StudentApp());
}

// Global Notifier for Theme Mode
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// Global Student Profile Model to store data dynamically across screens
class StudentProfileData extends ChangeNotifier {
  String name = "Davis Mwangi";
  String course = "Bachelor of Computer Science";
  String admissionNo = "CIT-227-045/2023";
  String institution = "Meru University of Science and Technology";
  String yearOfStudy = "Year 3 / Semester 2";
  String email = "davis.mwangi@students.must.ac.ke";

  void updateProfile({
    required String newName,
    required String newCourse,
    required String newAdmissionNo,
    required String newInstitution,
    required String newYear,
    required String newEmail,
  }) {
    name = newName;
    course = newCourse;
    admissionNo = newAdmissionNo;
    institution = newInstitution;
    yearOfStudy = newYear;
    email = newEmail;
    notifyListeners(); // Tells the app to update UI everywhere
  }
}

final studentProfile = StudentProfileData();

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Student Portal',
          themeMode: currentThemeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}

// --- Main Container with Bottom Navigation Bar ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CoursesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? 'Dashboard'
            : _currentIndex == 1
                ? 'My Courses'
                : 'Student Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value =
                  isDarkMode ? ThemeMode.light : ThemeMode.dark;
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// --- Tab 1: Dashboard ---
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: studentProfile,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school, size: 50, color: Colors.white),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back, ${studentProfile.name.split(' ').first}!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${studentProfile.institution} • ${studentProfile.yearOfStudy}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Semester Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Academic Year Completion'),
                          Text('75%', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: 0.75,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        color: Colors.green,
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Stats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(Icons.assignment_turned_in, 'Attendance', '94%'),
                  _buildStatCard(Icons.book_online, 'Units Enrolled', '6 Active'),
                  _buildStatCard(Icons.payment, 'Fee Balance', 'Cleared'),
                  _buildStatCard(Icons.notifications_active, 'Alerts', '2 New'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.green),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// --- Tab 2: Courses Screen ---
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  final List<Map<String, String>> courses = const [
    {'code': 'CIT 3300', 'name': 'Mobile Application Development', 'status': 'Ongoing'},
    {'code': 'CIT 3301', 'name': 'Advanced Database Systems', 'status': 'Ongoing'},
    {'code': 'CIT 3302', 'name': 'Software Engineering Principles', 'status': 'Completed'},
    {'code': 'CIT 3303', 'name': 'Computer Security & Cryptography', 'status': 'Ongoing'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Icon(Icons.code),
            ),
            title: Text(course['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Unit Code: ${course['code']}'),
            trailing: Chip(
              label: Text(course['status']!),
              backgroundColor: course['status'] == 'Ongoing'
                  ? Colors.green.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.2),
            ),
          ),
        );
      },
    );
  }
}

// --- Tab 3: Profile Screen with Edit Details & Logout ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: studentProfile,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                studentProfile.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                studentProfile.course,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Show confirmation dialog before logging out
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Log Out'),
                            content: const Text('Are you sure you want to log out of your student account?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Successfully logged out!')),
                                  );
                                },
                                child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Log Out', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const Divider(height: 40),
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge, color: Colors.green),
                      title: const Text('Admission Number'),
                      subtitle: Text(studentProfile.admissionNo),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.school_outlined, color: Colors.green),
                      title: const Text('Institution'),
                      subtitle: Text(studentProfile.institution),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.green),
                      title: const Text('Year / Semester'),
                      subtitle: Text(studentProfile.yearOfStudy),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email_outlined, color: Colors.green),
                      title: const Text('Student Email'),
                      subtitle: Text(studentProfile.email),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Edit Profile Form Screen ---
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _courseController;
  late TextEditingController _admissionController;
  late TextEditingController _institutionController;
  late TextEditingController _yearController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: studentProfile.name);
    _courseController = TextEditingController(text: studentProfile.course);
    _admissionController = TextEditingController(text: studentProfile.admissionNo);
    _institutionController = TextEditingController(text: studentProfile.institution);
    _yearController = TextEditingController(text: studentProfile.yearOfStudy);
    _emailController = TextEditingController(text: studentProfile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _admissionController.dispose();
    _institutionController.dispose();
    _yearController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account Details'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course / Program', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter your course' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _admissionController,
                decoration: const InputDecoration(labelText: 'Admission Number', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter admission number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _institutionController,
                decoration: const InputDecoration(labelText: 'Institution / School', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter institution name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year & Semester', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter year of study' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Student Email', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter email' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    studentProfile.updateProfile(
                      newName: _nameController.text,
                      newCourse: _courseController.text,
                      newAdmissionNo: _admissionController.text,
                      newInstitution: _institutionController.text,
                      newYear: _yearController.text,
                      newEmail: _emailController.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}