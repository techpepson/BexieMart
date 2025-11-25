import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<_NotificationItem> _notifications = const [
    _NotificationItem(
      title: 'New Product Alerts',
      body:
          'Discover the latest arrivals in beauty. Don’t miss out on the newest trends and must-have products.',
      time: 'Just now',
    ),
    _NotificationItem(
      title: 'Exclusive Offers',
      body:
          'You’ve unlocked a special offer! Tap to reveal your discount and save on your next purchase.',
      time: '2m ago',
    ),
    _NotificationItem(
      title: 'Order Updates',
      body:
          'Your order has been shipped! Track your delivery and stay updated.',
      time: '1h ago',
    ),
    _NotificationItem(
      title: 'Restock Notifications',
      body:
          'Good news! The product you loved is back in stock. Grab it before it’s gone again.',
      time: '2h ago',
    ),
    _NotificationItem(
      title: 'Cart Reminders',
      body:
          'You’ve left something behind! Complete your purchase and enjoy a seamless checkout experience.',
      time: 'Yesterday',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppConstants.backgroundColor,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppConstants.textColor,
            ),
            const SizedBox(width: 4),
            Text(
              'Notification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
                fontFamily: AppConstants.fontFamilyNunito,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return _NotificationTile(
            item: item,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NotificationDetailScreen(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});

  final _NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppConstants.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppConstants.primaryColor.withOpacity(0.4),
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.textColor,
                                fontFamily: AppConstants.fontFamilyNunito,
                              ),
                            ),
                          ),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.body,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: AppConstants.textColor.withAlpha(150),
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.textColor.withAlpha(120),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppConstants.textColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: AppConstants.textColor,
            fontFamily: AppConstants.fontFamilyNunito,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
                fontFamily: AppConstants.fontFamilyNunito,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.time,
              style: TextStyle(
                fontSize: 13,
                color: AppConstants.textColor.withAlpha(140),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.body,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppConstants.textColor.withAlpha(200),
                fontFamily: AppConstants.fontFamilyNunito,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.body,
    required this.time,
  });

  final String title;
  final String body;
  final String time;
}
