import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/food_listing_model.dart';
import '../constants/app_colors.dart';

class FoodListingCard extends StatelessWidget {
  final FoodListing listing;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FoodListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.trailing,
  });

  Color _statusColor(FoodStatus status) {
    switch (status) {
      case FoodStatus.reserved:
        return AppColors.statusPending;
      case FoodStatus.expired:
        return AppColors.error;
      case FoodStatus.completed:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expiry = listing.timeUntilExpiry;
    final expiresIn = expiry.isNegative
        ? 'Expired'
        : timeago.format(listing.expiryTime, allowFromNow: true);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 8),
              Text(
                listing.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text('${listing.servings} servings'),
                          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                        ),
                        Chip(
                          label: Text(listing.category.name.toUpperCase()),
                          backgroundColor: AppColors.secondaryLight.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        expiresIn,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(listing.status).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          listing.status.name.toUpperCase(),
                          style: TextStyle(
                            color: _statusColor(listing.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
