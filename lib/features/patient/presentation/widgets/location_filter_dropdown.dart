import 'package:flutter/material.dart';

class LocationFilterDropdown extends StatelessWidget {
  final List<String> locations;
  final String selectedLocation;
  final ValueChanged<String> onLocationSelected;

  const LocationFilterDropdown({
    super.key,
    required this.locations,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: selectedLocation,
        decoration: InputDecoration(
          hintText: 'Select Location',
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: primary,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        elevation: 0,
        dropdownColor: Colors.white,
        items: [
          const DropdownMenuItem(
            value: 'All',
            child: Text('All Locations', overflow: TextOverflow.ellipsis),
          ),
          ...locations.map(
            (loc) => DropdownMenuItem(
              value: loc,
              child: Text(loc, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
        onChanged: (val) => onLocationSelected(val ?? 'All'),
      ),
    );
  }
}
