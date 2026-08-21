// ignore_for_file: use_build_context_synchronously

import 'package:chordkita/features/auth/presentation/bloc/auth_event.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chordkita/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chordkita/features/auth/presentation/bloc/auth_state.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // Pesan status yang ditampilkan di bawah loading indicator
  String _statusMessage = 'Memuat...';

  @override
  void initState() {
    super.initState();
    _startInitialChecks();
  }

  void _updateStatus(String message) {
    if (!mounted) return;
    setState(() {
      _statusMessage = message;
    });
  }

  Future<void> _startInitialChecks() async {
    // Memberikan jeda singkat untuk menampilkan splash screen/branding
    _updateStatus('Memuat...');
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 1. Cek Koneksi Internet
    _updateStatus('Memeriksa koneksi internet...');
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasNoInternet = connectivityResult.contains(ConnectivityResult.none);
    await Future.delayed(const Duration(seconds: 2));
    if (hasNoInternet) {
      if (!mounted) return;
      _showNoInternetDialog();
      return;
    }

    // 2. Cek Sesi Tersimpan via BLoC
    _updateStatus('Memeriksa sesi akun...');
    await Future.delayed(const Duration(seconds: 2));
    context.read<AuthBloc>().add(AppStarted());
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Tidak Ada Koneksi'),
          ],
        ),
        content: const Text(
          'Periksa koneksi internet Anda dan coba lagi untuk melanjutkan.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _startInitialChecks(); // Re-check
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Pass data user terautentikasi ke HomeLayout
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: state.user,
          );
        } else if (state is AuthUnauthenticated || state is AuthGuest) {
          // Masuk ke HomeLayout sebagai Guest jika tidak ada sesi tersimpan
          Navigator.pushReplacementNamed(context, '/home', arguments: null);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Branding/Logo App
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  size: 64,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'ChordKita',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              // Pesan status loading (berubah sesuai tahap pengecekan)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _statusMessage,
                  key: ValueKey<String>(_statusMessage),
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
