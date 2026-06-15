{ lib
, stdenv
, fetchFromGitHub
, kernel
, kmod
}:

stdenv.mkDerivation rec {
  pname = "sc0710";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Nakildias";
    repo = "sc0710";
    rev = "main";
    sha256 = "sha256-7qt5hpGDE4iFfuLRA3S7xyoSGLYAlQY4cWJpkDDWsVA=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildPhase = ''
    runHook preBuild
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$PWD \
      EXTRA_CFLAGS="-DSC0710_DRV_VERSION=\"${version}\"" \
      modules
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    cp *.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = with lib; {
    description = "SC0710 driver for Elgato 4K60 Pro Mk2";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}