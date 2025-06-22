import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_assignment/presentation/dashboard/bloc/dashboard_cubit.dart';
import 'package:ui_assignment/utils/app_colors.dart';
import 'package:ui_assignment/widgets/box.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Interactive Box Display')),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => DashboardCubit(),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                // Dismiss keyboard on tap
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: state.controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                          // Limit to 2 digits
                        ],
                        decoration: InputDecoration(
                          labelText: 'Enter a number',
                          hintText: 'Enter a number between 5 and 25',
                          errorText: state.error,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => context
                                  .read<DashboardCubit>()
                                  .generateBoxes(),
                              child: Text('Generate Boxes'),
                            ),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<DashboardCubit>()
                                  .generateBoxes(),
                              child: Text('Generate Boxes in C Shape'),
                            ),
                          ],
                        ),
                      ),
                      _buildBoxDisplay(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBoxDisplay() {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.numberOfBoxes == 0 && state.error == null) {
          return const Center(
            heightFactor: 5,
            child: Text('Generate boxes to see them here.'),
          );
        }

        if (state.numberOfBoxes == 0 && state.error != null) {
          return Container(); // Don't show anything if there's an error and no boxes
        }

        // Generate the box widgets based on the current state
        // make a Grid of the boxes
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 50,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: state.numberOfBoxes,
          itemBuilder: (context, index) {
            Color color = state.clickOrder.contains(index)
                ? AppColors.greenColor
                : AppColors.redColor;
            return CustomBox(
              onTap: () => context.read<DashboardCubit>().boxClicked(index),
              id: index,
              color: color,
            );
          },
        );
      },
    );
  }
}
