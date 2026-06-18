{
	lib,
	stdenv,
	fetchFromGitHub,
	makeWrapper,
	patchelf,

	# Build Deps
	godot_4_5,
	godot_4_5-export-templates-bin,

	# Runtime Deps
	libx11,
	libxcursor,

	wayland,
	libxkbcommon,

	libGL,
	vulkan-loader,
}: stdenv.mkDerivation rec {
	pname = "godots";
	version = "1.4.2.stable";

	src = fetchFromGitHub {
		owner = "MakovWait";
		repo = "godots";
		rev = "v${version}";
		hash = "sha256-5BtphiR6mYutQCySufwnh0llLWowd6jinvbzN6hWbDA=";
	};

	nativeBuildInputs = [
		godot_4_5
		godot_4_5-export-templates-bin
		patchelf
		makeWrapper
	];

	buildInputs = [
		libx11
		libxcursor

		wayland
		libxkbcommon

		libGL
		vulkan-loader
	];

	buildPhase = ''
		export HOME="$TMPDIR/home"
		mkdir -p "$HOME/.local/share/godot/export_templates/4.5.1.stable"
		cp "${godot_4_5-export-templates-bin}/share/godot/export_templates/4.5.1.stable/linux_release.x86_64" "$HOME/.local/share/godot/export_templates/4.5.1.stable/"

		cp -r "${src}" .
		godot --headless --quiet --export-release "Linux/X11" "${pname}"
	'';

	installPhase = ''
		echo $out
		mkdir -p $out/bin
		cp ${pname} "$out/bin/${pname}"

		mkdir -p $out/share/applications
		cat > $out/share/applications/${pname}.desktop << 'EOF'
[Desktop Entry]
Name=Godots
Comment=Lightweight hub for managing Godot Engine versions and projects
Exec=${pname} %F
Icon=godots
Terminal=false
Type=Application
Categories=Development;IDE;Game;
MimeType=x-scheme-handler/godotproject;
Keywords=Godot;Engine;Game Development;IDE;Project Manager;
StartupNotify=true
EOF

		mkdir -p $out/share/icons/hicolor/scalable/apps
		cp icon.svg $out/share/icons/hicolor/scalable/apps/godots.svg
	'';

	fixupPhase = ''
		patchelf \
			--set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
			--set-rpath "${lib.makeLibraryPath buildInputs}" \
			"$out/bin/${pname}"
	'';

	meta = {
		description = "A lightweight hub for managing Godot Engine versions and projects";
		mainProgram = "godots";
		homepage = "https://github.com/MakovWait/godots";
		license = lib.licenses.mit;
		platforms = lib.platforms.linux;
	};
}
