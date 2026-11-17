import 'package:flutter/material.dart';
import '../viewmodel/item_view_model.dart';
import 'item_card.dart';

class MuralWidget extends StatelessWidget {
  const MuralWidget({required this.viewModel, super.key});

  final ItemViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.isLoading && viewModel.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(viewModel.errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: viewModel.loadItems,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }
        if (viewModel.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: viewModel.loadItems,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 110),
                Center(child: Text('Nenhum objeto encontrado.')),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final columns = width >= 1100
                ? 4
                : width >= 760
                ? 3
                : width >= 490
                ? 2
                : 1;

            return RefreshIndicator(
              onRefresh: viewModel.loadItems,
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 28),
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 325,
                ),
                itemCount: viewModel.items.length,
                itemBuilder: (context, index) => ItemCard(
                  item: viewModel.items[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}