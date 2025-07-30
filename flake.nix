{
  description = "Sachin's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util }:
  let
    configuration = { pkgs, config, ... }: {

    nixpkgs.config.allowUnfree = true; # Allows closed source software to be installed. Eg. obsidian

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
		pkgs.neovim
		pkgs.zellij
		pkgs.mkalias
		pkgs.obsidian
		pkgs.raycast
		pkgs.discord
		pkgs.postman
		pkgs.pgadmin4
		pkgs.zotero
		pkgs.alacritty
		pkgs.zoxide
		pkgs.atuin
		pkgs.amazon-q-cli
		pkgs.keycastr
		pkgs.gh
		pkgs.bun
		pkgs.cmake
		pkgs.cocoapods
		pkgs.vscode
		pkgs.terraform
		pkgs.postgresql
		pkgs.unixtools.watch
		pkgs.audacity
		pkgs.jujutsu
		pkgs.ripgrep
		pkgs.rustup
		pkgs.rustc
		pkgs.tree-sitter
		pkgs.awscli2
		pkgs.fira-code
		pkgs.yt-dlp
		pkgs.python313
		pkgs.glab
		pkgs.dotnetCorePackages.dotnet_8.sdk
		pkgs.git
		pkgs.docker-client
		pkgs.docker-compose
		pkgs.unnaturalscrollwheels
		pkgs.nerd-fonts.iosevka
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.services.sudo_local.touchIdAuth = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Sachins-MacBook-Pro
    darwinConfigurations."Sachins-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        mac-app-util.darwinModules.default
      ];
    };
  };
}
