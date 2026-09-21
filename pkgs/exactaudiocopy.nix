# based on https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ex/exactaudiocopy/package.nix
{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  p7zip,
  wine,
  winetricks,
  writeShellScriptBin,
  symlinkJoin,
}: let
  pname = "exact-audio-copy";
  version = "1.8.3";

  eac_exe = fetchurl {
    url = "http://www.exactaudiocopy.de/eac-${lib.versions.majorMinor version}.exe";
    hash = "sha256-IFUwz7/f+CNDhY84sOcJ5YYFH7iQDs1RPXmSo8HvAxs=";
  };

  cygwin_dll = fetchurl {
    url = "https://web.archive.org/web/20240925225100if_/https://cygwin.com/snapshots/x86/cygwin1-20220301.dll.xz";
    hash = "sha256-PXz/SdVa+Wms8Y2HSbAenncYZIf05gp8ZNAlg0sGtn8=";
  };

  patched_eac = stdenv.mkDerivation {
    pname = "patched_eac";
    inherit version;

    nativeBuildInputs = [
      p7zip
    ];

    buildCommand = ''
      mkdir -p $out
      _tmp=$(mktemp -d)
      cd $_tmp
      7z x -aoa ${eac_exe}
      chmod -R 755 .
      cp ${cygwin_dll} cygwin1.dll.xz
      xz --decompress cygwin1.dll.xz
      mv cygwin1.dll CDRDAO/
      cp -r * $out
      7z x EAC.exe
      cp .rsrc/1033/ICON/28 $out/eac.ico.256.png
    '';
  };

  wrapper = writeShellScriptBin pname ''
    export WINE="${wine}/bin/wine"
    export WINEPREFIX="''${EXACT_AUDIO_COPY_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/exact-audio-copy"}/wine"
    export WINEARCH=win32
    export WINEDEBUG=-all
    if [ ! -d "$WINEPREFIX" ] ; then
      WINEDLLOVERRIDES="mscoree=" ${winetricks}/bin/winetricks -q win7 cjkfonts dotnet48
    fi

    exec ${wine}/bin/wine ${patched_eac}/EAC.exe "$@"
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    comment = "Audio Grabber for CDs";
    desktopName = "Exact Audio Copy";
    categories = [
      "Audio"
      "AudioVideo"
    ];
    icon = "${patched_eac}/eac.ico.256.png";
  };
in
  symlinkJoin {
    inherit pname version;

    paths = [
      wrapper
      desktopItem
    ];

    meta = {
      description = "Precise CD audio grabber for creating perfect quality rips using CD and DVD drives";
      homepage = "https://www.exactaudiocopy.de/";
      changelog = "https://www.exactaudiocopy.de/en/index.php/resources/whats-new/whats-new/";
      license = lib.licenses.unfree;
      platforms = wine.meta.platforms;
    };
  }
