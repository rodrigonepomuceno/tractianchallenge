import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractianchallenge/core/theme/app_typography.dart';
import 'package:tractianchallenge/src/presentation/assets_list/page/assets_list_page.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubits/company_list_cubit.dart';

class CompanyListPage extends StatelessWidget {
  const CompanyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Image.asset(
            'assets/logo.png',
            height: 16,
          ),
        ),
      ),
      body: BlocBuilder<CompanyCubit, CompanyState>(
        builder: (context, state) {
          if (state.status == CompanyStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CompanyStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppTheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.error ?? 'An error occurred',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CompanyCubit>().loadCompanies();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state.assets.isEmpty) {
            return const Center(
              child: Text('No assets found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CompanyCubit>().loadCompanies(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.assets.length,
              itemBuilder: (context, index) {
                final companie = state.assets[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AssetsListPage(companieId: companie.id)));
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        height: 76,
                        margin: EdgeInsets.only(top: index == 0 ? 30 : 0, bottom: 30),
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          spacing: 16,
                          children: [
                            Image.asset('assets/icon_companie.png', height: 24, width: 24),
                            Text('${companie.name} Unit', style: AppTypography.mediumLg),
                          ],
                        ),
                      )),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
