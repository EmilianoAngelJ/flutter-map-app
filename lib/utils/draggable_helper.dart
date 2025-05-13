import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/providers/providers.dart';

/// Helper class to control the draggable sheet animation based on the selected address.
class DraggableHelper {
  
  /// Animates the DraggableScrollableSheet based on the selected address.
  static void draggableAnimation(WidgetRef ref, DraggableScrollableController controller) {
    
    // Waits for the frame to be rendered before proceeding
    WidgetsBinding.instance.addPostFrameCallback((_) { 

      // Listens to changes in the selected address provider
      ref.listenManual<AddressModel?>(
        selectedAdddressProvider, 
        (previous, current) async {
  
          // Exits early if the controller is not attached to the widget
          if (!controller.isAttached) return;   

          // small delay to ensure proper attachment
          await Future.delayed(const Duration(milliseconds: 50));  
          
          // Sets the target position based on whether an address is selected
          final target = current != null ? 0.18 : 0.085;

          // Animates the sheet to the target position with a smooth transition
          controller.animateTo(
            target,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      );
    });
  }
}

