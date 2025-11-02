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
    shellInit = 
      ''
        PROMPT='$(kube_ps1)'$PROMPT
      '';
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "sudo"
        "kube-ps1"
      ];
    };

  };

  # Set this as default shell. What other user is going to complain? It's just me
  users.defaultUserShell = pkgs.zsh;
}
