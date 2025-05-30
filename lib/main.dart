// main.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure to add intl: ^0.18.0 to your pubspec.yaml

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up App',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        // Modern Color Scheme - Using a teal-amber color palette
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.light(
          primary: Color(0xFF00897B), // Teal 600
          primaryContainer: Color(0xFFB2DFDB), // Teal 100
          secondary: Color(0xFFFFB300), // Amber 600
          secondaryContainer: Color(0xFFFFECB3), // Amber 100
          surface: Colors.white,
          background: Color(0xFFF5F5F6), // Very light gray
          error: Color(0xFFD32F2F), // Red 700
          onPrimary: Colors.white,
          onSecondary: Colors.black87,
          onSurface: Colors.black87,
          onBackground: Colors.black87,
          onError: Colors.white,
          brightness: Brightness.light,
        ),

        // Input Field Styling
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00897B), width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIconColor: Color(0xFF00897B),
          suffixIconColor: Colors.grey[600],
          // Add slight shadow to input fields
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),

        // Button Styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00897B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            elevation: 2,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00897B),
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        // AppBar Styling
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF00897B),
          foregroundColor: Colors.white,
          elevation: 0, // Flat design
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),

        // Card Styling
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        ),

        // Typography
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xFF00695C)),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
          labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),

        // Icon Theme
        iconTheme: IconThemeData(color: Color(0xFF00897B)),
        listTileTheme: ListTileThemeData(
          iconColor: Color(0xFF00897B),
        ),
        
        // Scaffold background
        scaffoldBackgroundColor: Color(0xFFF5F5F6),
      ),
      // Use routes with keys for each page to prevent GlobalKey issues
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpPage(key: UniqueKey()),
        '/welcome': (context) => WelcomePage(key: UniqueKey()),
        '/about': (context) => AboutUsPage(key: UniqueKey()),
      },
    );
  }
}


// --- Page 1: SignUpPage ---
class SignUpPage extends StatefulWidget {
  // Add the Key parameter to the constructor
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Using UniqueKey() instead of GlobalKey to avoid conflicts during hot reload
  final _formKey = GlobalKey<FormState>(debugLabel: 'signUpFormKey');
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _gender;
  DateTime? _dob;
  bool _acceptedTerms = false;
  bool _obscurePassword = true; // State for password visibility

  // Define valid users
  final Map<String, String> validUsers = {
    'test1@example.com': 'password123',
    'test2@example.com': 'securepass',
    'test3@example.com': 'flutterdev',
  };

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Your Date of Birth',
      builder: (context, child) {
        return Theme(
          // Use app's primary color scheme for consistency
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.indigo, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.grey[800], // body text color
                ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  // Function to handle form submission
  void _submitForm() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate DOB and Terms separately
    bool isDobValid = _dob != null;
    bool isTermsValid = _acceptedTerms;
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    // Show specific errors first
    if (!isDobValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your Date of Birth'), backgroundColor: Colors.redAccent),
      );
      return;
    }
    if (!isTermsValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must accept the Terms & Conditions'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Proceed if form fields are also valid
    if (isFormValid) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (validUsers.containsKey(email) && validUsers[email] == password) {
        Navigator.pushNamed(
          context,
          '/welcome',
          arguments: {
            'fullName': _fullNameController.text.trim(),
            'email': email,
            'gender': _gender,
            'dob': _dob!.toIso8601String(),
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password'), backgroundColor: Colors.redAccent),
        );
      }
    } else {
       // Optional: Indicate form validation errors if any field fails
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct the errors in the form'), backgroundColor: Colors.orangeAccent),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account')), // More engaging title
      body: SafeArea(
        child: SingleChildScrollView( // Use SingleChildScrollView for better flexibility
          padding: EdgeInsets.all(24.0), // Increased padding
          child: Form(
            key: _formKey,
            child: Column( // Use Column within SingleChildScrollView
              crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch
              children: [
                // Add app logo or icon at top for branding
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 24),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                // Full Name Field
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full Name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Full Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    // Basic email format check
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password Field with Visibility Toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.wc_outlined)),
                  value: _gender,
                  items: ['Male', 'Female', 'Other', 'Prefer not to say'] // Added option
                      .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  onChanged: (value) => setState(() => _gender = value),
                  validator: (value) => value == null ? 'Please select a gender' : null,
                ),
                SizedBox(height: 16),

                // Date of Birth Picker Tile - Improved Look
                InkWell( // Make the whole area tappable
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      // Display error state if DOB is not selected (visual cue)
                      // errorText: _dob == null && _formKey.currentState?.validate() == false ? 'Date of Birth is required' : null,
                    ),
                    child: Text(
                      _dob == null
                          ? 'Select Date'
                          : DateFormat('MMMM d, yyyy').format(_dob!),
                      style: TextStyle(
                        fontSize: 16,
                        color: _dob == null ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Terms & Conditions Checkbox - Improved Look
                FormField<bool>(
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: GestureDetector( // Allow tapping text to open terms (example)
                            onTap: () { /* TODO: Show terms dialog or page */ },
                            child: Text('I accept the Terms & Conditions', style: TextStyle(color: Colors.grey[700])),
                          ),
                          value: _acceptedTerms,
                          onChanged: (value) => setState(() {
                             _acceptedTerms = value!;
                             state.didChange(value); // Update FormField state
                          }),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.indigo,
                          dense: true,
                          // Show error directly below checkbox if needed
                          // subtitle: state.hasError ? Text(state.errorText!, style: TextStyle(color: Colors.redAccent, fontSize: 12)) : null,
                        ),
                      ],
                    );
                  },
                  // Validator for the FormField wrapper if needed, though manual check is done in _submitForm
                  // validator: (value) {
                  //   if (_acceptedTerms == false) {
                  //     return 'You must accept the terms';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 32), // More space before buttons

                // Add gradient to Sign Up button for more visual appeal
                Container(
                  margin: EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF00695C)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00897B).withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                // About Us Button - Centered
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/about'),
                    child: Text('About Us'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Page 2: WelcomePage ---
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? userData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (userData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Could not load user data.')),
      );
    }

    String formattedDob = 'N/A';
    if (userData['dob'] != null) {
      try {
        final DateTime dob = DateTime.parse(userData['dob']);
        formattedDob = DateFormat('MMMM d, yyyy').format(dob);
      } catch (e) {
        formattedDob = userData['dob']; // Fallback
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'), // Changed title
        automaticallyImplyLeading: false, // Remove back arrow if desired
        actions: [
          // Add a settings icon for visual appeal
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              // Could navigate to settings in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings (Example)'), duration: Duration(seconds: 1)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0), // Consistent padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Greeting Message
            Text(
              'Welcome,',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.normal, color: Colors.grey[700]),
            ),
            Text(
              '${userData['fullName'] ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 32), // Larger name
            ),
            SizedBox(height: 32), // More space

            // Enhanced user card with gradient header
            Card(
              clipBehavior: Clip.antiAlias, // Clip the gradient to card borders
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add gradient header
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00897B), Color(0xFF009688)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: Text(
                      'User Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // User Details Card - Improved Styling
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0), // Inner padding
                    child: Column(
                      children: [
                        _buildUserInfoTile(Icons.email_outlined, 'Email', userData['email'] ?? 'N/A'),
                        Divider(indent: 16, endIndent: 16, height: 20), // Styled divider
                        _buildUserInfoTile(Icons.wc_outlined, 'Gender', userData['gender'] ?? 'N/A'),
                        Divider(indent: 16, endIndent: 16, height: 20),
                        _buildUserInfoTile(Icons.cake_outlined, 'Date of Birth', formattedDob),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(), // Pushes the buttons to the bottom

            // Sign out button with icon
            Center(
              child: TextButton.icon(
                icon: Icon(Icons.logout),
                label: Text('Sign Out'),
                onPressed: () => Navigator.pop(context), // Go back to SignUp page
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper widget for consistent user info display - Refined
  Widget _buildUserInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 28), // Slightly larger icon
      title: Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)), // Subdued title
      subtitle: Text(subtitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87)), // Emphasized subtitle
      dense: false, // Less dense for more spacing
    );
  }
}


// --- Page 3: AboutUsPage ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);
  
  final List<TeamMember> teamMembers = const [
    TeamMember(
      name: 'Md. Akram Khan',
      photoUrl: 'https://scontent.fdac31-1.fna.fbcdn.net/v/t39.30808-1/455867519_122158386374098604_5084878240073979027_n.jpg?stp=cp0_dst-jpg_p60x60_tt6&_nc_cat=109&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeHpacOiqeA_edOKYMTV64O5f-adtDDmpdl_5p20MOal2bNkrRGU8NUFhvl_8L-08uKyj4DWQC3W0LATWSAH3up-&_nc_ohc=HxTyff4dbGQQ7kNvwFeE9iI&_nc_oc=Adk-VlW_oR0FGD84Q30RYskhL2qX3ueaL3djKO8Ez1lcJion_kIfR14J9pDA8mcOVnM&_nc_zt=24&_nc_ht=scontent.fdac31-1.fna&_nc_gid=5IKQkmPH3F2mHBOZz5tCnA&oh=00_AfE7-YmRfYq5HInFLctnsuFHBI0mzb9eyKxxAZDHeHOpFA&oe=681832FC',
    ),
    TeamMember(
      name: 'Dibbajothy Sarker',
      photoUrl: 'https://scontent.fdac31-1.fna.fbcdn.net/v/t39.30808-1/486641204_2156516244786476_238357396822176633_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=105&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeEk0neVa9vXFulyMwtfSnwOFCugTrbvYi4UK6BOtu9iLjkYzDjGa3ZXmSmegOgsD63MtJr__54jjjZG_OUDY4jH&_nc_ohc=oDAF3VrZhdgQ7kNvwFpmvvf&_nc_oc=AdkJnQ9fAV9HPyLMJn1W5FbTOH2z-3Ejd6viuuSZVbt6gP4YnSKSFlpC9rkX4gmQ9Yc&_nc_zt=24&_nc_ht=scontent.fdac31-1.fna&_nc_gid=vY1mgmaoNWCsFdggoWI1Xg&oh=00_AfGMnGwtZR22kygNwSIe-Ge145wmQk28pzVYvYFqYETXow&oe=68181BA9',
    ),
    TeamMember(
      name: 'Istiak Ahammed Rhyme',
      photoUrl: 'https://scontent.fdac31-2.fna.fbcdn.net/v/t39.30808-1/467490710_1759197604837381_8608898828610552358_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeFb78iSIzTOvVy-vUWsnmhLdOVXzNis_Al05VfM2Kz8CWGSPODtLAmrOTQFYlecpncccPI6zAyqnYiSbXNf5H96&_nc_ohc=-Ix5rN3OduoQ7kNvwHLn0BO&_nc_oc=AdmkI7D7KL3LGAqcQlTPmHtgHJIlo2PI0et29UTEbySDFnglzMfbpR_cmgunv6DRmTM&_nc_zt=24&_nc_ht=scontent.fdac31-2.fna&_nc_gid=Y1ryrWR8xb83KSlUqRVNmA&oh=00_AfFIm1BL_oWkhhM6JfgJAElTB-lGAXby7saHmRJnQ9hhDA&oe=68182EDA',
    ),
    TeamMember(
      name: 'Jubayer Ahmed Sojib',
      photoUrl: 'https://scontent.fdac31-1.fna.fbcdn.net/v/t39.30808-1/489955293_1152567056352774_3842940229140587167_n.jpg?stp=c0.214.960.960a_dst-jpg_s160x160_tt6&_nc_cat=102&ccb=1-7&_nc_sid=1d2534&_nc_eui2=AeEbEngjM6JQY9aIdUylmBzQ4K4a18z9AivgrhrXzP0CKyCeEMiNwjavXYPEN5xaag9wBjOC4f37tlxrgFdRfnR4&_nc_ohc=BXrMPRYutv8Q7kNvwH6vsab&_nc_oc=AdnUKxGO0jdUxqg6h3D1ycHaJiwo8aDnueem6pu9xZcXoyiFjXrE3zlxoRLqZX8nIy0&_nc_zt=24&_nc_ht=scontent.fdac31-1.fna&_nc_gid=yyoxY-cf0qGOMY2RS26VFQ&oh=00_AfHz6D41L-Z2bliwU56Po1qeFR5ZjhSp3wApm8waxgTdUw&oe=6818315E',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.0),
            color: const Color.fromARGB(255, 51, 33, 243),
            child: Column(
              children: [
                Text(
                  'Flutter Sign Up Page App',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Building amazing mobile experiences',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Our Team',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(teamMembers[index].photoUrl),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle image loading errors silently
                      },
                    ),
                    title: Text(teamMembers[index].name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String photoUrl;

  const TeamMember({
    required this.name,
    required this.photoUrl,
  });
}