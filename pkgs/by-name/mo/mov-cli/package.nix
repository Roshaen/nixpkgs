{ lib
, fetchFromGitHub
, ffmpeg
, fzf
, mpv
, python3
}:

let
  pname = "mov-cli";
  version = "4.3.14";
in
python3.pkgs.buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli";
    rev = version;
    hash = "sha256-o876rPVjGw1eOgOAV2+vNi3oE9ZQOQvzJzl7PplnE24=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    click
    colorama
    httpx
    krfzf-py
    lxml
    poetry-core
    pycrypto
    setuptools
    six
    tldextract
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "httpx"
    "tldextract"
  ];

  makeWrapperArgs = let
    binPath = lib.makeBinPath [
      ffmpeg
      fzf
      mpv
    ];
  in [
    "--prefix PATH : ${binPath}"
  ];

  meta = with lib; {
    homepage = "https://github.com/mov-cli/mov-cli";
    description = "A cli tool to browse and watch movies";
    license = with lib.licenses; [ gpl3Only ];
    mainProgram = "mov-cli";
    maintainers = with lib.maintainers; [ baitinq ];
  };
}
