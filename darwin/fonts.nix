{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    fira-code
    fira-code-symbols
    maple-mono.Normal-NF-CN-unhinted
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    flakePackages.misans
    flakePackages.misans-l3
  ];
}
