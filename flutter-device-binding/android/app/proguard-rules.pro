# R8 is on for Flutter release builds. Rules exist only for libraries that load
# classes reflectively, where a rename fails silently and only in release.

# --- androidx.credentials ---------------------------------------------------
#
# Credential Manager resolves provider implementations reflectively; without
# this passkey registration and assertion fail only in release builds.
-keep class androidx.credentials.** { *; }
-dontwarn androidx.credentials.**

# --- Play Integrity ---------------------------------------------------------
#
# Ships its own consumer rules; nothing to add. Listed so the next reader does
# not go looking.
