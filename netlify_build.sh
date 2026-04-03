#!/usr/bin/env bash
set -e

if ! command -v flutter >/dev/null 2>&1; then
  git clone -b stable --depth 1 https://github.com/flutter/flutter.git "$HOME/flutter"
  export PATH="$HOME/flutter/bin:$PATH"
  flutter config --enable-web
  flutter precache --web
fi

export PATH="$HOME/flutter/bin:$PATH"
flutter --version
flutter pub get
flutter build web --release