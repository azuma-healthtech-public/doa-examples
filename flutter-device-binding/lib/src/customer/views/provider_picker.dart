import 'package:flutter/material.dart';

import '../../core/health_id.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../notice.dart';
import '../widgets/widgets.dart';
import 'customer_view.dart';

/// H1 - choose the health insurer before the Health-ID hand-off.
///
/// Presented over the current screen and returns the chosen issuer; it is a
/// picker, not a state of the gate, because the same choice is made from
/// registration, from sign-in and from the account screen. Nothing is submitted
/// here and no session is involved: the list is the broker's public directory.
Future<HealthIdProvider?> pickHealthIdProvider(
  BuildContext context,
  HealthId healthId,
) => Navigator.of(context).push<HealthIdProvider>(
  MaterialPageRoute<HealthIdProvider>(
    fullscreenDialog: true,
    builder: (_) => _ProviderPicker(healthId: healthId),
  ),
);

/// Picks a provider, then runs [action] with it through the view's usual
/// busy-and-clear handling. Cancelling the picker does nothing at all.
Future<void> withHealthIdProvider(
  CustomerView v,
  BuildContext context,
  Future<void> Function(String provider) action,
) async {
  final provider = await pickHealthIdProvider(context, v.c.healthId);
  if (provider == null) return;
  v.refresh(() => v.c.handoffProvider = provider.name);
  try {
    await v.act(() => action(provider.issuer));
  } finally {
    if (v.mounted()) v.refresh(() => v.c.handoffProvider = null);
  }
}

class _ProviderPicker extends StatefulWidget {
  const _ProviderPicker({required this.healthId});
  final HealthId healthId;

  @override
  State<_ProviderPicker> createState() => _ProviderPickerState();
}

class _ProviderPickerState extends State<_ProviderPicker> {
  final _search = TextEditingController();
  List<HealthIdProvider>? _all;
  Object? _failure;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _failure = null;
      _all = null;
    });
    try {
      final providers = await widget.healthId.providers();
      if (mounted) setState(() => _all = providers);
    } catch (e) {
      if (mounted) setState(() => _failure = e);
    }
  }

  List<HealthIdProvider> get _visible {
    final all = _all ?? const <HealthIdProvider>[];
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your insurer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in through the health insurer that issued your '
                        'Health-ID. You confirm with their app or card.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _search,
                        autocorrect: false,
                        enabled: _all != null,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => setState(() => _query = value),
                        decoration: InputDecoration(
                          labelText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Clear',
                                  onPressed: () => setState(() {
                                    _search.clear();
                                    _query = '';
                                  }),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _body(theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(ThemeData theme) {
    if (_failure != null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          const NoticeBanner(
            Notice.error(
              'The list of insurers could not be loaded. Check your connection '
              'and try again.',
              title: "Couldn't reach the directory",
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: _load, child: const Text('Try again')),
        ],
      );
    }
    if (_all == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final visible = _visible;
    if (visible.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No insurer matches "${_search.text.trim()}".',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: visible.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final provider = visible[index];
        return ListTile(
          minVerticalPadding: 14,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.tileRadius),
          ),
          title: Text(
            provider.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: provider.privateInsurance
              ? const Text('Private health insurance')
              : null,
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.neutral400,
          ),
          onTap: () => Navigator.of(context).pop(provider),
        );
      },
    );
  }
}
