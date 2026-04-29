import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/di/injection_container.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/tide_card_widget.dart';
import '../../domain/entities/location.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) {
        final viewModel = sl<HomeViewModel>();
        if (viewModel.availableLocations.isNotEmpty) {
          // Future.microtask prevents state update during build
          Future.microtask(() => viewModel.selectLocation(viewModel.availableLocations.first));
        }
        return viewModel;
      },
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Mareas', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.loadTidesForDate(DateTime.now()),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLocationSelector(context, viewModel),
              const SizedBox(height: 24),
              Expanded(
                child: _buildBody(viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelector(BuildContext context, HomeViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Location>(
          value: viewModel.selectedLocation,
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: colorScheme.primary),
          items: viewModel.availableLocations.map((Location loc) {
            return DropdownMenuItem<Location>(
              value: loc,
              child: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            );
          }).toList(),
          onChanged: (Location? newValue) {
            if (newValue != null) {
              viewModel.selectLocation(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(HomeViewModel viewModel) {
    if (viewModel.state == HomeState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.state == HomeState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(viewModel.errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadTidesForDate(DateTime.now()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (viewModel.tides.isEmpty) {
      return const Center(child: Text('No hay datos de mareas para esta ubicación.'));
    }

    return ListView.builder(
      itemCount: viewModel.tides.length,
      itemBuilder: (context, index) {
        final tide = viewModel.tides[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TideCardWidget(tideEvent: tide),
        );
      },
    );
  }
}
