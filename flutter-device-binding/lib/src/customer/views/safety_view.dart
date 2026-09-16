import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'customer_view.dart';

/// S3 · Keep your phone safe. The guidance TR-03161-1 asks the app to give the
/// user on secure use (O.Resi_1, O.Plat_13): what keeps the protection intact,
/// and what the app never does. Reachable from the welcome screen and from the
/// account screen, and static - nothing here reads or writes anything.
List<Widget> safetyView(CustomerView v, {required VoidCallback back}) => [
  v.headline('Keep your phone safe'),
  v.body(
    'azuma protects your data with keys that only this phone can use, behind '
    'your fingerprint or face. A few habits keep that protection intact.',
  ),
  const SizedBox(height: 8),
  const ProofLine(
    'Keep a screen lock, and keep your fingerprint or face enrolled. Without '
    'them the app cannot sign you in.',
  ),
  const ProofLine(
    'Only you should be enrolled. Anyone whose fingerprint or face this phone '
    'accepts can open azuma.',
  ),
  const ProofLine('Install system and app updates when they are offered.'),
  const ProofLine(
    'Do not root or jailbreak this phone. azuma refuses to sign you in on a '
    'modified phone, because other apps could read your data there.',
  ),
  const ProofLine('Install apps from Google Play or the App Store only.'),
  const ProofLine(
    'azuma never asks for your password by email, message or phone call.',
  ),
  const SizedBox(height: 8),
  const InfoBanner(
    'If this phone is lost: sign in on another phone with your passkey or '
    'Health-ID, then contact support to have this one removed from your account.',
  ),
  const SizedBox(height: 16),
  v.outlined('Back', back),
];
