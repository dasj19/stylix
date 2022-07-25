# Stylix

Stylix is a NixOS module which applies a standard colourscheme and font to every supported application, including:

- Everything which uses GTK: notably Firefox and the GNOME apps
- Text editors: Vim, NeoVim and Helix
- Terminals: Alacritty, Kitty and Foot
- The Linux console
- The Plymouth boot screen
- The GRUB bootloader

It also exports functions and values which make it easy to use the theme elsewhere within your NixOS configuration.

The colours used are generated from a background image, using a homemade [genetic algorithm](https://en.wikipedia.org/wiki/Genetic_algorithm).  
Fonts are selected by the user via a NixOS option, choosing from any of the font packages available in Nixpkgs.

Stylix builds upon [base16.nix](https://github.com/SenchoPens/base16.nix#base16nix) to manage the installation of themes into the appropriate location, as required by the application which is being themed.  
base16.nix uses templates from [Base16](http://chriskempson.com/projects/base16/).

## Installation

Stylix can be installed using the experimental
[flakes](https://nixos.wiki/wiki/Flakes) feature:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, stylix }: {
    nixosConfigurations."<hostname>" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
      ];
    };
  };
}
```

Stylix relies on [Home Manager](https://github.com/nix-community/home-manager)
to install a lot of its theming. This requires Home Manager to be installed as
a NixOS module; how to do this is shown in the example above.

## Configuration

```nix
{ pkgs, ... }:

{
  # A colorscheme will be chosen automatically based on your wallpaper.
  stylix.image = ./wallpaper.png;

  # Use this option to force a light or dark theme to be chosen.
  stylix.polarity = "light";

  # You can override parts of the scheme by hand:
  stylix.palette = {
    base00 = "eeeeee";
    base05 = "111111";
  };

  # Or replace it with a scheme from base16:
  stylix.base16Scheme = "${base16-schemes}/gruvbox-dark-hard.yaml";

  # Select your preferred fonts, or use these defaults:
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    monospace = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans Mono";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
}
```

### Enabling and disabling module

Each file in `modules/` corresponds to a single target, with the same name as
the file. A target is just something which can have styling applied to it. 

Each target has an option like `stylix.targets.«target».enable` to turn its
styling on or off. By default, styling is turned on automatically when the
target is installed.

You can set `stylix.autoEnable = false` to opt out of this behaviour, in which
case you'll need to manually enable each target you want to be styled.
