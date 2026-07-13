import 'package:flutter/material.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';

/// Bireysel / Kurumsal seçimi.
///
/// Dropdown değil segmented button: iki seçenek var ve seçim formun şeklini
/// değiştiriyor — kullanıcı hangi moda olduğunu tek bakışta görmeli.
class CustomerTypeSelector extends StatelessWidget {
  const CustomerTypeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final CustomerType value;
  final ValueChanged<CustomerType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<CustomerType>(
      segments: const [
        ButtonSegment(
          value: CustomerType.individual,
          label: Text('Bireysel'),
          icon: Icon(Icons.person_outline),
        ),
        ButtonSegment(
          value: CustomerType.company,
          label: Text('Kurumsal'),
          icon: Icon(Icons.business_outlined),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
