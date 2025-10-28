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
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "sudo"
      ];
    };

  };

  # Set this as default shell. What other user is going to complain? It's just me
  users.defaultUserShell = pkgs.zsh;
}
