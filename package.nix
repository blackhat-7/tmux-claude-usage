{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  curl,
  findutils,
  gawk,
  gnugrep,
  gnused,
  jq,
  tmuxPlugins,
}:

let
  pluginName = "tmux-claude-usage";
  runtimePath = lib.makeBinPath [
    bash
    coreutils
    curl
    findutils
    gawk
    gnugrep
    gnused
    jq
  ];
in
tmuxPlugins.mkTmuxPlugin {
  inherit pluginName;
  version = "0.1.0";
  rtpFilePath = "claude-usage.tmux";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    chmod +x "$target/claude-usage.tmux" "$target/bin/tmux-claude-usage"

    wrapProgram "$target/bin/tmux-claude-usage" \
      --suffix PATH : "${runtimePath}" \
      ${lib.optionalString stdenv.hostPlatform.isDarwin ''--suffix PATH : /usr/bin''}

    mkdir -p "$out/bin" "$out/share/doc/${pluginName}"
    ln -s "$target/bin/tmux-claude-usage" "$out/bin/tmux-claude-usage"
    ln -s "$target/README.md" "$out/share/doc/${pluginName}/README.md"
  '';

  meta = {
    description = "Claude Code 5-hour and weekly usage limits in the tmux status bar";
    homepage = "https://github.com/blackhat-7/tmux-claude-usage";
    license = lib.licenses.mit;
    mainProgram = "tmux-claude-usage";
    platforms = lib.platforms.unix;
  };
}
