import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/theme/colors.dart';
import 'package:maps_app/providers/providers.dart';
import 'package:maps_app/utils/draggable_helper.dart';
import 'package:maps_app/widgets/widgets.dart';

/// Main widget that creates a draggable sheet overlaying the map.
class DraggableSheet extends ConsumerStatefulWidget {
  const DraggableSheet({super.key});

  @override
  ConsumerState<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends ConsumerState<DraggableSheet> {
  final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    // Set up the animation behavior of the draggable sheet
    DraggableHelper.draggableAnimation(ref, _controller);
  }

  @override
  Widget build(BuildContext context) { 
    final address = ref.watch(selectedAdddressProvider);

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.085,
      minChildSize: 0.085,
      maxChildSize: 0.26,
      snap: true,
      snapSizes: const [0.18],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            // Disable scrolling if no address is selected
            physics: address == null
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
            child: const DraggableContent(),
          ),
        );
      },
    );
  }
}

/// Main content of the draggable sheet
class DraggableContent extends StatelessWidget {
  const DraggableContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DragHandle(), // Gray drag indicator
        DraggableSheetHeader(), // Shows brief address or instructions
        DraggableSheetContent(), // Shows full address details
        SaveAddressButton(), // Save address to local DB
      ],
    );
  }
}

/// Displays brief address info at top of sheet
class DraggableSheetHeader extends ConsumerWidget {
  const DraggableSheetHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(selectedAdddressProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: address != null 
        ? Text(
            '${address.street}, ${address.subAdministrativeArea}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          )
        : Text(
            'To select an address, press on the map.',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.black54,
            ),
          ),
    );
  }
}

/// Displays full address details conditionally with animation
class DraggableSheetContent extends ConsumerWidget {
  const DraggableSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(selectedAdddressProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10, 
        children: [
          AnimatedText(
            address: address,
            text: Text(
              '${address?.thoroughfare}, ${address?.subAdministrativeArea}, ${address?.administrativeArea}, ${address?.country}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          AnimatedText(
            address: address,
            text: Text(
              'Postal code: ${address?.postalCode}    Country ISO code: ${address?.isoCountryCode}',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Visual drag handle that appears only when address is selected
class DragHandle extends ConsumerWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(selectedAdddressProvider);
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: address != null 
          ? Container(
              height: 5,
              width: 50,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            )
          : const SizedBox(height: 14),
      ),
    );
  }
}

/// Save button appears only when address is selected.
/// It saves the address to local database and clears selection.
class SaveAddressButton extends ConsumerWidget {
  const SaveAddressButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(selectedAdddressProvider);

    return address != null 
      ? Center(
          child: ElevatedButton(
            onPressed: () {
              ref.read(addressesProvider.notifier).addAddress(address);
              ref.read(selectedAdddressProvider.notifier).state = null;
            },
            child: Text(
              'Save Address',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      : const SizedBox.shrink(); // Empty widget when no address is selected
  }
}
