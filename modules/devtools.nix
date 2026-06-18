# A module to manage my dev tools, not finished yet.

{ config, pkgs, inputs, lib, ... }:
let
	cfg = config.programs.devtools;
in
{
	options.programs.devtools = {
		enable = lib.mkEnableOption "Enable Devtools.";
		dotnet = {
			enable6 = lib.mkEnableOption "Enable .NET SDK 6.";
			enable7 = lib.mkEnableOption "Enable .NET SDK 7.";
			enable8 = lib.mkEnableOption "Enable .NET SDK 8.";
			enable9 = lib.mkEnableOption "Enable .NET SDK 9.";
			enable10 = lib.mkEnableOption "Enable .NET SDK 10.";
			enable11 = lib.mkEnableOption "Enable .NET SDK 11.";
		};
		java = {
			enableLts = lib.mkEnableOption "Enable most recent Java Development Kit LTS.";
			enable8 = lib.mkEnableOption "Enable JDK 8.";
			enable11 = lib.mkEnableOption "Enable JDK 11.";
			enable17 = lib.mkEnableOption "Enable JDK 17.";
			enable21 = lib.mkEnableOption "Enable JDK 21.";
			enable25 = lib.mkEnableOption "Enable JDK 25.";
		};
		javascript = {
			nodejs = {
				enableLatest = lib.mkEnableOption "Enable latest release of NodeJS.";
				enableLts = lib.mkEnableOption "Enable latest LTS release of NodeJS.";
				enable20 = lib.mkEnableOption "Enable NodeJS 20.";
				enable22 = lib.mkEnableOption "Enable NodeJS 22.";
				enable24 = lib.mkEnableOption "Enable NodeJS 24.";
				enable26 = lib.mkEnableOption "Enable NodeJS 26.";
			};
		};
		c = {
			clang = {
				enable = lib.mkEnableOption "Enable Clang.";
				tools = lib.mkEnableOption "Enable Clang Tools.";
			};
			cmake = lib.mkEnableOption "Enable CMake.";
			ninja = lib.mkEnableOption "Enable Ninja.";
		};
		rust = {
			enable = lib.mkEnableOption "Enable Rust Compiler.";
			cargo = lib.mkEnableOption "Enable Cargo.";
		};
		godot = {
			v4_6 = lib.mkEnableOption "Enable Godot v4.6";
			v4_7 = lib.mkEnableOption "Enable Godot v4.7";
		};
		zig = {
			enableLatest = lib.mkEnableOption "Enable latest release of Zig";
		};

		packaging = {
			dpkg = lib.mkEnableOption "Enable debian package manager.";
		};
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			pkg-config

			# .NET (dotnet)
			(lib.mkIf cfg.dotnet.enable6 dotnet-sdk_6)
			(lib.mkIf cfg.dotnet.enable7 dotnet-sdk_7)
			(lib.mkIf cfg.dotnet.enable8 dotnet-sdk)
			(lib.mkIf cfg.dotnet.enable9 dotnet-sdk_9)
			(lib.mkIf cfg.dotnet.enable10 dotnet-sdk_10)
			(lib.mkIf cfg.dotnet.enable11 dotnet-sdk_11)

			# Java Development Kit (JDK)
			(lib.mkIf cfg.java.enableLts jdk)
			(lib.mkIf cfg.java.enable8 jdk8)
			(lib.mkIf cfg.java.enable11 jdk11)
			(lib.mkIf cfg.java.enable17 jdk17)
			(lib.mkIf cfg.java.enable21 jdk21)
			(lib.mkIf cfg.java.enable25 jdk25)

			# Javascript
			(lib.mkIf cfg.javascript.nodejs.enableLatest nodejs_latest)
			(lib.mkIf cfg.javascript.nodejs.enableLts nodejs)
			(lib.mkIf cfg.javascript.nodejs.enable20 nodejs_20)
			(lib.mkIf cfg.javascript.nodejs.enable22 nodejs_22)
			(lib.mkIf cfg.javascript.nodejs.enable24 nodejs_24)
			(lib.mkIf cfg.javascript.nodejs.enable26 nodejs_26)

			# C / C++
			(lib.mkIf cfg.c.clang.enable clang)
			(lib.mkIf cfg.c.clang.tools clang-tools)
			(lib.mkIf cfg.c.cmake cmake)
			(lib.mkIf cfg.c.ninja ninja)

			# Rust
			(lib.mkIf cfg.rust.enable rustc)
			(lib.mkIf (cfg.rust.enable && cfg.rust.cargo) cargo)

			# Godot
			(lib.mkIf cfg.godot.v4_6 godotPackages_4_6.godot)
			(lib.mkIf cfg.godot.v4_7 godotPackages_4_7.godot)

			# Zig
			(lib.mkIf cfg.zig.enableLatest zig)

			# Packaging
			(lib.mkIf cfg.packaging.dpkg dpkg)
		];
	};
}
