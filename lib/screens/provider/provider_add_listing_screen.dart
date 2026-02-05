import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/food_listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/food_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ProviderAddListingScreen extends StatefulWidget {
  const ProviderAddListingScreen({super.key});

  @override
  State<ProviderAddListingScreen> createState() => _ProviderAddListingScreenState();
}

class _ProviderAddListingScreenState extends State<ProviderAddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _servingsController = TextEditingController(text: '1');
  final _addressController = TextEditingController();

  FoodCategory _selectedCategory = FoodCategory.vegetables;
  FoodType _selectedType = FoodType.fresh;
  DateTime? _expiryTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _servingsController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiry(AppLocalizations strings) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 7)),
      helpText: strings.selectDateTime,
    );
    if (pickedDate == null) return;

    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 2))),
      helpText: strings.selectDateTime,
    );

    if (!mounted) return;

    if (pickedTime != null) {
      setState(() {
        _expiryTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final strings = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final foodProvider = context.read<FoodProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.errorOccurred)),
      );
      return;
    }

    final success = await foodProvider.createListing({
      'providerId': user.id,
      'providerName': user.fullName,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'quantity': _quantityController.text.trim(),
      'servings': int.tryParse(_servingsController.text.trim()) ?? 0,
      'category': _selectedCategory.name,
      'foodType': _selectedType.name,
      'expiryTime': (_expiryTime ?? DateTime.now().add(const Duration(hours: 4))).toIso8601String(),
      'address': _addressController.text.trim(),
      'latitude': 0,
      'longitude': 0,
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.listingCreated)),
      );
      Navigator.of(context).pop();
    } else {
      final error = foodProvider.error ?? strings.errorOccurred;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final isLoading = context.watch<FoodProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(strings.addListing)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                strings.providerDashboardSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                label: strings.foodTitle,
                validator: (value) =>
                    value == null || value.isEmpty ? strings.requiredField : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: strings.description,
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? strings.requiredField : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _quantityController,
                label: strings.quantity,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _servingsController,
                label: strings.servings,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return strings.requiredField;
                  final servings = int.tryParse(value);
                  if (servings == null || servings <= 0) {
                    return strings.invalidCredentials;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<FoodCategory>(
                key: ValueKey(_selectedCategory),
                initialValue: _selectedCategory,
                decoration: InputDecoration(labelText: strings.category),
                items: FoodCategory.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(_categoryLabel(category, strings)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<FoodType>(
                key: ValueKey(_selectedType),
                initialValue: _selectedType,
                decoration: InputDecoration(labelText: strings.foodType),
                items: FoodType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_foodTypeLabel(type, strings)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.expiryTime),
                subtitle: Text(
                  _expiryTime == null
                      ? strings.selectDateTime
                      : DateFormat.yMMMd().add_Hm().format(_expiryTime!),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.event),
                  onPressed: () => _pickExpiry(strings),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _addressController,
                label: strings.address,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: strings.addListing,
                onPressed: isLoading
                    ? null
                    : () {
                        _submit();
                      },
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(FoodCategory category, AppLocalizations strings) {
    switch (category) {
      case FoodCategory.vegetables:
        return strings.vegetables;
      case FoodCategory.fruits:
        return strings.fruits;
      case FoodCategory.grains:
        return strings.grains;
      case FoodCategory.dairy:
        return strings.dairy;
      case FoodCategory.meat:
        return strings.meat;
      case FoodCategory.prepared:
        return strings.prepared;
      case FoodCategory.other:
        return strings.other;
    }
  }

  String _foodTypeLabel(FoodType type, AppLocalizations strings) {
    switch (type) {
      case FoodType.fresh:
        return strings.fresh;
      case FoodType.cooked:
        return strings.cooked;
      case FoodType.packaged:
        return strings.packaged;
    }
  }
}
