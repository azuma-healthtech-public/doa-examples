/// What the app tells the user about the outcome of an action. One shape,
/// four tones, and the screen decides where it goes: a banner at the top of
/// the content (or above the primary action on hero screens), or a snackbar
/// for a confirmation nobody has to read. See the "Errors and messages" page
/// of the design canvas and specifications/customer-app.md section 3.5.
enum NoticeTone {
  /// An action did not happen. Says what did not change and what to do next.
  error,

  /// A decision with a cost, before the user continues.
  warning,

  /// The user cancelled, or needs context. Never red.
  info,

  /// Something the user must read, e.g. "check your email".
  success,

  /// A confirmation nobody has to read; shown as a snackbar, four seconds.
  snack,
}

class Notice {
  const Notice(this.tone, this.body, {this.title, this.retry = false});

  const Notice.error(this.body, {this.title, this.retry = false})
    : tone = NoticeTone.error;
  const Notice.warning(this.body, {this.title})
    : tone = NoticeTone.warning,
      retry = false;
  const Notice.info(this.body, {this.title})
    : tone = NoticeTone.info,
      retry = false;
  const Notice.success(this.body, {this.title})
    : tone = NoticeTone.success,
      retry = false;
  const Notice.snack(this.body)
    : tone = NoticeTone.snack,
      title = null,
      retry = false;

  final NoticeTone tone;
  final String? title;
  final String body;

  /// Offer "Try again", which re-runs the action that produced this notice.
  final bool retry;
}

/// The device-integrity check did not pass. A full-screen state (S2), not a
/// banner: nothing on this phone can continue until "Check again".
enum DeviceCheckFailure {
  /// Google Play answered that the phone or app is modified.
  rejected,

  /// Google Play could not be asked (no Play services, offline, ...).
  unavailable,
}
