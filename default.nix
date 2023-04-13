{
  lib,
  python3Packages,
  qt5,
  libsForQt5,
  killall,
  freerdp,
  version ? "git",
}:
with python3Packages; buildPythonApplication rec {
  pname = "cassowary-py";
  inherit version;

  src = lib.cleanSourceWith {
    filter = name: type: let
      baseName = baseNameOf (toString name);
    in ! (
      builtins.match "build.sh" baseName != null
    );
    src = lib.cleanSource ./app-linux;
  };

  format = "pyproject";

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    setuptools
  ];

  propagatedBuildInputs = [
    pyqt5
    libvirt
    libsForQt5.qt5.qtwayland
  ] ++ [
    pkgs.killall
    pkgs.freerdp
  ];

  dontWrapQtApps = true;
  dontWrapGApps = true;

  preFixup = ''
      wrapQtApp "$out/bin/cassowary"
  '';

  meta = with lib; {
    homepage = "https://github.com/AtaraxiaSjel/cassowary";
    description = "Run Windows Applications on Linux as if they are native.";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}