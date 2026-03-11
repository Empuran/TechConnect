import 'package:flutter/material.dart';
import 'package:nila/core/theme/app_theme.dart';
import 'package:nila/features/home/presentation/home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 state
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedGender;
  final _jobRoleController = TextEditingController();
  final _companyController = TextEditingController();

  // Step 2 state
  final _bioController = TextEditingController();
  final List<String> _selectedInterests = [];
  final List<String> _selectedTechInterests = [];

  final _interests = ['Music', 'Travel', 'Fitness', 'Food', 'Cinema', 'Reading', 'Gaming', 'Photography', 'Art', 'Cricket', 'Cooking', 'Yoga'];
  final _techInterests = ['Python', 'AI/ML', 'DevOps', 'Cloud', 'Flutter', 'React', 'Data Engineering', 'Blockchain', 'Open Source', 'Startup', 'Cybersecurity', 'Web3'];

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: List.generate(3, (i) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: i <= _currentStep ? AppColors.primary : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )),
              ),
            ),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text('Step ${_currentStep + 1} of 3', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Step1(
                    nameController: _nameController,
                    dobController: _dobController,
                    jobRoleController: _jobRoleController,
                    companyController: _companyController,
                    selectedGender: _selectedGender,
                    onGenderChanged: (g) => setState(() => _selectedGender = g),
                    onNext: _nextStep,
                  ),
                  _Step2(
                    bioController: _bioController,
                    interests: _interests,
                    techInterests: _techInterests,
                    selectedInterests: _selectedInterests,
                    selectedTechInterests: _selectedTechInterests,
                    onToggleInterest: (val) => setState(() => _selectedInterests.contains(val) ? _selectedInterests.remove(val) : _selectedInterests.add(val)),
                    onToggleTech: (val) => setState(() => _selectedTechInterests.contains(val) ? _selectedTechInterests.remove(val) : _selectedTechInterests.add(val)),
                    onNext: _nextStep,
                  ),
                  _Step3(onNext: _nextStep),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  final TextEditingController nameController, dobController, jobRoleController, companyController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final VoidCallback onNext;

  const _Step1({required this.nameController, required this.dobController, required this.jobRoleController, required this.companyController, required this.selectedGender, required this.onGenderChanged, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tell us about yourself', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 6),
          Text('This helps us find the right matches for you', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          _buildLabel(context, 'Your Name'),
          const SizedBox(height: 8),
          TextField(controller: nameController, decoration: const InputDecoration(hintText: 'e.g. Arjun Nair'), style: const TextStyle(color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          _buildLabel(context, 'Date of Birth'),
          const SizedBox(height: 8),
          TextField(controller: dobController, decoration: const InputDecoration(hintText: 'DD / MM / YYYY', prefixIcon: Icon(Icons.cake_outlined, color: AppColors.primary)), style: const TextStyle(color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          _buildLabel(context, 'I am a...'),
          const SizedBox(height: 8),
          Row(
            children: ['Male', 'Female', 'Non-Binary'].map((g) => Expanded(
              child: GestureDetector(
                onTap: () => onGenderChanged(g),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedGender == g ? AppColors.primary : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(g, textAlign: TextAlign.center, style: TextStyle(color: selectedGender == g ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 20),
          _buildLabel(context, 'Job Role'),
          const SizedBox(height: 8),
          TextField(controller: jobRoleController, decoration: const InputDecoration(hintText: 'e.g. Software Engineer'), style: const TextStyle(color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          _buildLabel(context, 'Company'),
          const SizedBox(height: 8),
          TextField(controller: companyController, decoration: const InputDecoration(hintText: 'e.g. UST Global'), style: const TextStyle(color: AppColors.textPrimary)),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: onNext, child: const Text('Continue')),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) =>
    Text(label, style: Theme.of(context).textTheme.labelLarge);
}

class _Step2 extends StatelessWidget {
  final TextEditingController bioController;
  final List<String> interests, techInterests, selectedInterests, selectedTechInterests;
  final ValueChanged<String> onToggleInterest, onToggleTech;
  final VoidCallback onNext;

  const _Step2({required this.bioController, required this.interests, required this.techInterests, required this.selectedInterests, required this.selectedTechInterests, required this.onToggleInterest, required this.onToggleTech, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your interests', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 6),
          Text('Help others know you better', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          Text('Bio', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: bioController, maxLines: 3,
            decoration: const InputDecoration(hintText: 'Tell your story in a few lines...'),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          Text('Interests', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: interests.map((i) {
              final selected = selectedInterests.contains(i);
              return _Chip(label: i, selected: selected, onTap: () => onToggleInterest(i));
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Tech Interests', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: techInterests.map((t) {
              final selected = selectedTechInterests.contains(t);
              return _Chip(label: t, selected: selected, onTap: () => onToggleTech(t), isAccent: true);
            }).toList(),
          ),
          const SizedBox(height: 40),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onNext, child: const Text('Continue'))),
        ],
      ),
    );
  }
}

class _Step3 extends StatelessWidget {
  final VoidCallback onNext;
  const _Step3({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add your photos', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 6),
          Text('Upload at least 3 photos to continue. Profiles with photos get 10x more matches!', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),

          GridView.count(
            crossAxisCount: 3, shrinkWrap: true,
            crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.75,
            children: List.generate(5, (i) => Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: i == 0
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                    Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 32),
                    SizedBox(height: 8),
                    Text('Main Photo', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                  ])
                : const Icon(Icons.add, color: AppColors.textMuted),
            )),
          ),
          const Spacer(),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onNext, child: const Text("Let's Go! 🌙"))),
          const SizedBox(height: 12),
          Center(child: TextButton(onPressed: onNext, child: const Text('Skip for now', style: TextStyle(color: AppColors.textMuted)))),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isAccent;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap, this.isAccent = false});

  @override
  Widget build(BuildContext context) {
    final color = isAccent ? AppColors.accent : AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.transparent),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, fontSize: 13)),
      ),
    );
  }
}
