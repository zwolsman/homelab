{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    figlet
  ];

  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    autosuggestions.enable = true;

    shellAliases = {
      nr = "sudo nixos-rebuild switch --flake '.#$(hostname)'";
    };

    ohMyZsh = {
      enable = true;
      theme = "kafeitu";
      plugins = [
        "sudo"
      ];
    };

  };

  # Set this as default shell. What other user is going to complain? It's just me
  users.defaultUserShell = pkgs.zsh;
}
