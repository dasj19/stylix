{ pkgs, config, lib, ... }:

with lib;

let
  themeFile = config.lib.stylix.colors {
    templateRepo = pkgs.fetchFromGitHub {
      owner = "chriskempson";
      repo = "base16-vim";
      rev = "6191622d5806d4448fa2285047936bdcee57a098";
      sha256 = "6FsT87qcl9GBxgxrPx2bPULIMA/O8TRxHaN49qMM4uM=";
    };
  };

  themePlugin = pkgs.vimUtils.buildVimPlugin {
    name = "stylix";
    pname = "stylix";

    src = themeFile;
    dontUnpack = true;

    buildPhase = ''
      install -D $src $out/colors/base16-stylix.vim
    '';
  };

  vimOptions = {
    plugins = [ themePlugin ];
    extraConfig = ''
      set termguicolors
      colorscheme base16-stylix
      set guifont=${escape [" "] config.stylix.fonts.monospace.name}:h10
    '';
  };

in {
  options.stylix.targets.vim.enable =
    config.lib.stylix.mkEnableTarget "Vim and/or Neovim" true;

  config = lib.mkIf config.stylix.targets.vim.enable {
    home-manager.sharedModules = [{
      programs.vim = vimOptions;
      programs.neovim = vimOptions;
    }];
  };
}
