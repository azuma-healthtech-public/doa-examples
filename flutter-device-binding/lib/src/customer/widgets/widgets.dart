import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../notice.dart';

/// The handful of components the customer screens are built from, all on
/// top of Material 3 widgets - see the token sheet on the design canvas.

/// 12/600 upper-case label above a group of tiles.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 4),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall,
    ),
  );
}

/// A sign-in / registration method: tonal leading circle, title, optional
/// subtitle, chevron or custom trailing. 64-72 high, radius 12.
class MethodTile extends StatelessWidget {
  const MethodTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.emphasised = false,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool emphasised;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = enabled && onTap != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: emphasised ? AppColors.primary100 : AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppTheme.tileRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.tileRadius),
          onTap: active ? onTap : null,
          child: Opacity(
            opacity: enabled ? 1 : 0.55,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: emphasised ? AppColors.white : AppColors.primary100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 22, color: AppColors.primary700),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.titleMedium),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.neutral500,
                                height: 20 / 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  trailing ??
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.neutral400,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum BannerKind { info, warning }

/// Radius-12 note with a leading icon: primary-50 for information, warning-50
/// for something the user should weigh before continuing. Static copy that is
/// part of a screen; outcomes of actions are a [NoticeBanner].
class InfoBanner extends StatelessWidget {
  const InfoBanner(this.text, {super.key, this.kind = BannerKind.info});
  final String text;
  final BannerKind kind;

  @override
  Widget build(BuildContext context) => NoticeBanner(
    Notice(kind == BannerKind.info ? NoticeTone.info : NoticeTone.warning, text),
  );
}

/// The message banner: one component, four tones (design canvas, "Errors and
/// messages"). 20 px icon top-aligned, optional 15/600 title, 14/20 body, an
/// optional "Try again" action. No close button: it clears when the next
/// action starts or the screen changes. Announced as a live region.
class NoticeBanner extends StatelessWidget {
  const NoticeBanner(this.notice, {super.key, this.onRetry});
  final Notice notice;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, body, icon) = switch (notice.tone) {
      NoticeTone.error || NoticeTone.snack => (
        AppColors.error50,
        AppColors.errorText,
        const Color(0xFF8A0F2B),
        Icons.error_outline,
      ),
      NoticeTone.warning => (
        AppColors.warning50,
        AppColors.warningText,
        AppColors.warningText,
        Icons.warning_amber_rounded,
      ),
      NoticeTone.info => (
        AppColors.primary50,
        AppColors.primary700,
        AppColors.primary700,
        Icons.info_outline,
      ),
      NoticeTone.success => (
        AppColors.success50,
        AppColors.successText,
        AppColors.successText,
        Icons.check_circle_outline,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppTheme.tileRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(icon, size: 20, color: fg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notice.title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        notice.title!,
                        style: TextStyle(
                          fontSize: 15,
                          height: 20 / 15,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                    ),
                  Text(
                    notice.body,
                    style: TextStyle(fontSize: 14, height: 20 / 14, color: body),
                  ),
                  if (notice.retry && onRetry != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: InkWell(
                        onTap: onRetry,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Try again',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: fg,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The explicit consent line (BSI O.Purp_3). Unchecked by default; the caller
/// keeps the value and disables its primary action until it is true.
class ConsentRow extends StatelessWidget {
  const ConsentRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.text =
        'I have read the privacy notice and agree to the processing of my '
        'health data as described there.',
  });
  final bool value;
  final ValueChanged<bool> onChanged;
  final String text;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () => onChanged(!value),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Four-segment strength meter (BSI O.Pass_2: shown, never stored). The score
/// is a local heuristic - length and character classes - and lives only in the
/// widget tree for as long as the field has text.
class StrengthMeter extends StatelessWidget {
  const StrengthMeter(this.password, {super.key});
  final String password;

  static int score(String p) {
    if (p.isEmpty) return 0;
    var s = 0;
    if (p.length >= 8) s++;
    if (p.length >= 12) s++;
    final classes = [
      RegExp(r'[a-z]'),
      RegExp(r'[A-Z]'),
      RegExp(r'[0-9]'),
      RegExp(r'[^A-Za-z0-9]'),
    ].where((r) => r.hasMatch(p)).length;
    if (classes >= 2) s++;
    if (classes >= 3 && p.length >= 10) s++;
    return s.clamp(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    final s = score(password);
    final (label, color) = switch (s) {
      0 || 1 => ('Weak. Use a longer passphrase.', AppColors.error),
      2 => ('Fair. A longer passphrase is stronger than symbols.', AppColors.warning),
      3 => ('Good.', AppColors.success),
      _ => ("Strong. Use a passphrase you don't use anywhere else.", AppColors.success),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i < s ? color : AppColors.neutral100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                if (i < 3) const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// The large tonal circle with an icon on the setup and lock screens.
class HeroCircle extends StatelessWidget {
  const HeroCircle(
    this.icon, {
    super.key,
    this.size = 112,
    this.background = AppColors.primary100,
    this.foreground = AppColors.primary500,
  });
  final IconData icon;
  final double size;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: size / 2, color: foreground),
    ),
  );
}

/// One check-marked line of the welcome or setup explainer.
class ProofLine extends StatelessWidget {
  const ProofLine(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.check, size: 20, color: AppColors.success),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 22 / 15,
              color: AppColors.neutral700,
            ),
          ),
        ),
      ],
    ),
  );
}

/// `maria.berger@example.org` -> `m•••••@example.org`.
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 0) return email;
  return '${email[0]}•••••${email.substring(at)}';
}
