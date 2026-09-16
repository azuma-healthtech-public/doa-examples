import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_config.dart';
import '../customer_controller.dart';
import 'dev_config.dart';

/// Developer affordances the customer UI deliberately lacks: a state
/// inspector, a local reset, force-expire, the raw profile, per-credential
/// unlink, and a runtime backend override. Reached only from a `kDebugMode`
/// button, so none of it exists in a release build. What it does *not* offer:
/// stored passwords, refresh tokens, or any way past the biometric gate.
class DevToolsScreen extends ConsumerStatefulWidget {
  const DevToolsScreen({super.key});
  @override
  ConsumerState<DevToolsScreen> createState() => _DevToolsScreenState();
}

class _DevToolsScreenState extends ConsumerState<DevToolsScreen> {
  late final TextEditingController baseUrl;
  late final TextEditingController applicationId;
  String? note;

  CustomerController get c => ref.read(customerProvider);
  RuntimeConfig get config => ref.read(runtimeConfigProvider);

  @override
  void initState() {
    super.initState();
    baseUrl = TextEditingController(text: config.baseUrl);
    applicationId = TextEditingController(text: config.applicationId);
  }

  @override
  void dispose() {
    baseUrl.dispose();
    applicationId.dispose();
    super.dispose();
  }

  Future<void> _guard(Future<void> Function() action, String done) async {
    try {
      await action();
      if (mounted) setState(() => note = done);
    } catch (e) {
      if (mounted) setState(() => note = 'Failed: ${e.runtimeType}');
    }
  }

  Future<bool> _confirm(String title, String body) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      ) ??
      false;

  Widget _row(String label, Object? value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 150, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: SelectableText('${value ?? '-'}')),
      ],
    ),
  );

  Widget _section(String title, List<Widget> children) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ref.watch(customerProvider),
    builder: (context, _) {
      final d = c.device;
      final s = c.session;
      final profile = c.profile;
      final passkeys = profile?['passkeyCredentials'] as List? ?? [];
      final biometrics = profile?['biometricCredentials'] as List? ?? [];
      final methods = profile?['linkedAuthenticationMethods'] as List? ?? [];
      return Scaffold(
        appBar: AppBar(title: const Text('DevTools (debug build)')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section('Backend', [
              _row('Base URL', config.baseUrl),
              _row('Application id', config.applicationId),
              _row('Override active', config.isOverride),
              _row('Play Integrity project', AppConfig.playIntegrityCloudProjectNumber),
              _row('Health-ID configured', c.healthId.configured),
              const SizedBox(height: 8),
              TextField(
                controller: baseUrl,
                decoration: const InputDecoration(labelText: 'Override base URL', border: OutlineInputBorder()),
                autocorrect: false,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: applicationId,
                decoration: const InputDecoration(labelText: 'Override application id', border: OutlineInputBorder()),
                autocorrect: false,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed: () => _guard(
                      () => DevConfig.save(
                        RuntimeConfig(
                          baseUrl: baseUrl.text.trim(),
                          applicationId: applicationId.text.trim(),
                        ),
                      ),
                      'Override saved. Restart the app to use it.',
                    ),
                    child: const Text('Save override'),
                  ),
                  OutlinedButton(
                    onPressed: () => _guard(
                      DevConfig.clear,
                      'Override cleared. Restart the app to use the compiled defaults.',
                    ),
                    child: const Text('Clear override'),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Applies at the next start. Release builds ignore it.'),
              ),
            ]),
            _section('Device record', [
              _row('Scenario / storage slot', c.storage.slot),
              _row('Storage ready', c.ready),
              _row('Storage failed', c.storageFailed),
              _row('Device key alias', d?.alias),
              _row('Account id', d?.id),
              _row('Email', d?.email),
              _row('Biometric key alias', d?.biometricAlias),
              _row('Verification flow', d?.verificationFlow),
            ]),
            _section('Session', [
              _row('Signed in', c.signedIn),
              _row('Account id', s?.id),
              _row('Seconds remaining', c.secondsRemaining),
              _row('Deadline', s?.deadline.toIso8601String()),
              _row('Post-login actions', s?.actions.join(', ')),
              _row('Re-auth required', c.reauthenticationRequired),
              _row('Last message', c.message),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: s == null ? null : () => setState(c.expireSessionNow),
                    child: const Text('Force-expire session'),
                  ),
                  OutlinedButton(
                    onPressed: c.busy || !c.canEnter ? null : c.loadProfile,
                    child: const Text('Reload profile'),
                  ),
                ],
              ),
            ]),
            _section('Profile (raw)', [
              if (profile == null)
                const Text('Not loaded. Requires a full session (canEnter).')
              else ...[
                _row('Methods', methods.join(', ')),
                if (methods.contains('Mimoto'))
                  OutlinedButton(
                    onPressed: c.busy ? null : c.unlinkHealthId,
                    child: const Text('Unlink Health-ID'),
                  ),
                for (final p in passkeys.cast<Map<String, dynamic>>())
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.key),
                    title: SelectableText('${p['credentialId'] ?? p['id']}'),
                    trailing: TextButton(
                      onPressed: c.busy ? null : () => c.unlinkPasskey('${p['id']}'),
                      child: const Text('Unlink'),
                    ),
                  ),
                for (final b in biometrics.cast<Map<String, dynamic>>())
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.fingerprint),
                    title: SelectableText('${b['id']}'),
                    subtitle: Text('${b['deviceData'] ?? ''}'),
                    trailing: TextButton(
                      onPressed: c.busy ? null : () => c.unlinkBiometric('${b['id']}'),
                      child: const Text('Unlink'),
                    ),
                  ),
                const SizedBox(height: 8),
                SelectableText(const JsonEncoder.withIndent('  ').convert(profile)),
              ],
            ]),
            _section('Local reset', [
              const Text(
                'Forgets this installation: device record, session, profile. Keys stay orphaned in the keystore; the server keeps the binding.',
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: c.busy
                    ? null
                    : () async {
                        if (await _confirm('Reset local state?', 'This installation becomes a fresh device. The account is unchanged on the server.')) {
                          await c.resetLocalState();
                          if (mounted) setState(() => note = c.message);
                        }
                      },
                child: const Text('Reset local state'),
              ),
            ]),
            if (note != null) Text(note!),
          ],
        ),
      );
    },
  );
}
