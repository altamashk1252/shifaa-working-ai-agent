import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/sosctrl.dart';

class SosButton extends StatefulWidget {
  final VoidCallback? onSosDispatched;
  final VoidCallback? onSosCancelled;

  const SosButton({super.key, this.onSosDispatched, this.onSosCancelled});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> {
  String _languageCode = 'en';

  static const Map<String, Map<String, String>> SOSlabels = {
    'en': {
      'sos': 'SOS',
      'sosActivation': 'SOS Activation',
      'sosSending': 'Sending SOS in {seconds} seconds...\nTap cancel to abort.',
      'sosHelpOnWay': '🚨 Help is on the way',
      'sosHelpMessage': 'Help is on the way. Please stay put.',
      'sosCancel': 'Cancel',
      'sosConfirmCancel': 'Confirm Cancellation',
      'sosConfirmMessage': 'Are you sure you want to cancel the SOS call?',
      'sosYesCancel': 'Yes, Cancel SOS',
      'sosNo': 'No',
      'ok': 'OK',
      'cancelSos': 'Cancel SOS',
    },
    'ar': {
      'sos': 'طوارئ',
      'sosActivation': 'تفعيل الطوارئ',
      'sosSending': 'إرسال الطوارئ خلال {seconds} ثوان...\nاضغط إلغاء للإيقاف.',
      'sosHelpOnWay': '🚨 المساعدة في الطريق',
      'sosHelpMessage': 'المساعدة في الطريق. يرجى البقاء في مكانك.',
      'sosCancel': 'إلغاء',
      'sosConfirmCancel': 'تأكيد الإلغاء',
      'sosConfirmMessage': 'هل أنت متأكد أنك تريد إلغاء نداء الطوارئ؟',
      'sosYesCancel': 'نعم، ألغِ الطوارئ',
      'sosNo': 'لا',
      'ok': 'حسناً',
      'cancelSos': 'إلغاء الطوارئ',
    }
  };

  @override
  void initState() {
    super.initState();
    _loadLanguageFromPrefs();
  }

  Future<void> _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final soslabelMap = SOSlabels[_languageCode]!;

    return Consumer<SosCtrl>(
      builder: (context, sosCtrl, _) {
        return
          ElevatedButton(
          onPressed: () {
            if (sosCtrl.isActive) {
              _showCancelConfirmDialog(soslabelMap, () {
                sosCtrl.deactivate();
                widget.onSosCancelled?.call();
              });
            } else {
              _showSosDialog(soslabelMap, sosCtrl);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Optional Lottie animation
              SizedBox(
                width: 50,
                height: 50,
                child: Lottie.asset(
                  'assets/animations/ambulancia.json',
                  repeat: true,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                sosCtrl.isActive ? soslabelMap['cancelSos']! : soslabelMap['sos']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 50,
                height: 50,
                child: Lottie.asset(
                  'assets/animations/ambulancia.json',
                  repeat: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSosDialog(Map<String, String> soslabelMap, SosCtrl sosCtrl) {
    int countdown = 5;
    bool isCancelled = false;
    bool helpDispatched = false;

    Timer? timer; // declare first

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Start the timer only once
            if (timer == null) {
              timer = Timer.periodic(const Duration(seconds: 1), (_) {
                if (isCancelled || helpDispatched) {
                  timer?.cancel();
                  return;
                }

                if (countdown == 1) {
                  timer?.cancel();
                  helpDispatched = true;
                  sosCtrl.activate();
                  widget.onSosDispatched?.call();
                } else {
                  countdown--;
                }

                setStateDialog(() {}); // rebuild dialog to update countdown
              });
            }

            return AlertDialog(
              title: Text(
                helpDispatched
                    ? soslabelMap['sosHelpOnWay']!
                    : soslabelMap['sosActivation']!,
              ),
              content: Text(
                helpDispatched
                    ? soslabelMap['sosHelpMessage']!
                    : soslabelMap['sosSending']!
                    .replaceFirst('{seconds}', countdown.toString()),
              ),
              actions: [
                if (!helpDispatched)
                  TextButton(
                    onPressed: () {
                      _showCancelConfirmDialog(soslabelMap, () {
                        isCancelled = true;
                        sosCtrl.deactivate();
                        widget.onSosCancelled?.call();
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      soslabelMap['sosCancel']!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (helpDispatched)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(soslabelMap['ok']!),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCancelConfirmDialog(
      Map<String, String> soslabelMap, VoidCallback onCancel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(soslabelMap['sosConfirmCancel']!),
        content: Text(soslabelMap['sosConfirmMessage']!),
        actions: [
          TextButton(
            onPressed: () {
              onCancel();
              Navigator.of(context).pop();
            },
            child: Text(
              soslabelMap['sosYesCancel']!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(soslabelMap['sosNo']!),
          ),
        ],
      ),
    );
  }
}
