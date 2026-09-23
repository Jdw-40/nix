{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  playerctl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lyse";
  version = "unstable-2026-08-08"; # bump/pin as you like

  src = fetchFromGitHub {
    owner = "snoowfall";
    repo = "lyse";
    rev = "main"; # better: pin to a commit hash for reproducibility
    hash = lib.fakeHash; # replace after first build attempt gives you the real hash
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 lyse.py $out/bin/lyse
    wrapProgram $out/bin/lyse \
      --prefix PATH : ${
        lib.makeBinPath [
          python3
          playerctl
        ]
      }
    runHook postInstall
  '';

  meta = with lib; {
    description = "Realtime TUI lyrics for your favorite songs, directly in the terminal";
    homepage = "https://github.com/snoowfall/lyse";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    mainProgram = "lyse";
  };
}
