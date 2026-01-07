{pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  programs.vscode = {
    enable = true;
    # Simple workaround before next nixpkgs-unstable released
    package = pkgs.vscodium.overrideAttrs rec {
      plat =
        {
          x86_64-linux = "linux-x64";
          x86_64-darwin = "darwin-x64";
          aarch64-linux = "linux-arm64";
          aarch64-darwin = "darwin-arm64";
          armv7l-linux = "linux-armhf";
        }.${
          system
        };

      archive_fmt =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "zip"
        else "tar.gz";

      hash =
        {
          x86_64-linux = "sha256-gqBxdd6Ww1nIXovixgsuIivLXn1LoZXN5NhK4bLmSng=";
          x86_64-darwin = "sha256-al2RcKJ3KrNywnMYbhd493kyR6I0JUbCJHy1iTk4N4s=";
          aarch64-linux = "sha256-32WP74IJYVIKuhmsMi0EFqjTlWAO4DgC24ptm3BqSpg=";
          aarch64-darwin = "sha256-2hYTrkCNzVy6wXT+cGWkDEAy+g/KSkWsLltMSuSSBTk=";
          armv7l-linux = "sha256-bNjc91zjVXnQ763GHmlVTNDD5ynlJhrtGR7Xzciq7tA=";
        }.${
          system
        };

      version = "1.107.18627";
      src = pkgs.fetchurl {
        url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
        inherit hash;
      };
    };
    mutableExtensionsDir = false;
    profiles.default = {
      userSettings = {
        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[html]" = {
          "editor.defaultFormatter" = "vscode.html-language-features";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "[javascriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[json]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.tabSize" = 4;
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[vue]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "[xml]" = {
          "editor.defaultFormatter" = "DotJoshJohnson.xml";
        };
        "[dockercompose]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoIndent" = "advanced";
          "editor.quickSuggestions" = {
            "other" = true;
            "comments" = false;
            "strings" = true;
          };
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "[github-actions-workflow]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "debug.javascript.autoAttachFilter" = "disabled";
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.accessibilitySupport" = "off";
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.inlineSuggest.enabled" = true;
        "editor.smoothScrolling" = false;
        "editor.stickyScroll.enabled" = true;
        "explorer.fileNesting.patterns" = {
          "*.ts" = "\${capture}.js";
          "*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
          "*.jsx" = "\${capture}.js";
          "*.tsx" = "\${capture}.ts";
          "tsconfig.json" = "tsconfig.*.json";
          "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb, bun.lock";
          "Cargo.toml" = "Cargo.lock";
          "*.sqlite" = "\${capture}.\${extname}-*";
          "*.db" = "\${capture}.\${extname}-*";
          "*.sqlite3" = "\${capture}.\${extname}-*";
          "*.db3" = "\${capture}.\${extname}-*";
          "*.sdb" = "\${capture}.\${extname}-*";
          "*.s3db" = "\${capture}.\${extname}-*";
        };
        "files.autoGuessEncoding" = true;
        "files.autoSaveWhenNoErrors" = true;
        "files.exclude" = {
          "**/.classpath" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/.factorypath" = true;
          "**/.DS_Store" = true;
          "**/.direnv" = true;
        };
        "git.autoStash" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.replaceTagsWhenPull" = true;
        "markdown.preview.breaks" = true;
        "markdownlint.config" = {
          MD026 = false;
        };
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "alejandra";
        "nix.hiddenLanguageServerErrors" = [
          "textDocument/definition"
          "textDocument/codeAction"
          "textDocument/documentSymbol"
          "textDocument/inlayHint"
          "textDocument/documentLink"
        ];
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = ["alejandra"];
            };
          };
        };
        "prettier.tabWidth" = 2;
        "redhat.telemetry.enabled" = false;
        "search.smartCase" = true;
        "security.workspace.trust.untrustedFiles" = "open";
        "svelte.enable-ts-plugin" = true;
        "typescript.locale" = "en";
        "typescript.preferences.importModuleSpecifier" = "non-relative";
        "typescript.suggest.autoImports" = true;
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "update.mode" = "none";
        "vsicons.dontShowNewVersionMessage" = true;
        "workbench.colorCustomizations" = {
          "terminal.background" = "#00000000";
        };
        "workbench.iconTheme" = "vscode-icons";
        "workbench.productIconTheme" = "fluent-icons";
        "workbench.startupEditor" = "none";
        "workbench.tree.enableStickyScroll" = true;
      };
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = pkgs.nix4vscode.forVscode [
        "13xforever.language-x86-64-assembly"
        "aaron-bond.better-comments"
        "astro-build.astro-vscode"
        "bradlc.vscode-tailwindcss"
        "christian-kohler.path-intellisense"
        "clinyong.vscode-css-modules"
        "csstools.postcss"
        "csstools.postcss"
        "cweijan.vscode-office"
        "Dart-Code.dart-code"
        "Dart-Code.flutter"
        "davidanson.vscode-markdownlint"
        "dbaeumer.vscode-eslint"
        "docker.docker"
        "donjayamanne.python-environment-manager"
        "DrBlury.protobuf-vsc"
        "dustypomerleau.rust-syntax"
        "EditorConfig.EditorConfig"
        "esbenp.prettier-vscode"
        "firefox-devtools.vscode-firefox-debug"
        "foxundermoon.shell-format"
        "fwcd.kotlin"
        "GitHub.vscode-github-actions"
        "GitHub.vscode-pull-request-github"
        "golang.go"
        "IBM.output-colorizer"
        "JHeilingbrunner.vscode-gnupg-tool"
        "jnoortheen.nix-ide"
        "k--kato.intellij-idea-keybindings"
        "keroc.hex-fmt"
        "KevinRose.vsc-python-indent"
        "llvm-vs-code-extensions.vscode-clangd"
        "mathiasfrohlich.Kotlin"
        "mechatroner.rainbow-csv"
        "miguelsolorio.fluent-icons"
        "mikestead.dotenv"
        "mkhl.direnv"
        "ms-azuretools.vscode-containers"
        "ms-ceintl.vscode-language-pack-zh-hans"
        "ms-python.black-formatter"
        "ms-python.debugpy"
        "ms-python.isort"
        "ms-python.python"
        "ms-python.vscode-pylance"
        "ms-python.vscode-python-envs"
        "ms-vscode-remote.remote-containers"
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-ssh-edit"
        "ms-vscode.cmake-tools"
        "ms-vscode.hexeditor"
        "ms-vscode.makefile-tools"
        "ms-vscode.remote-explorer"
        "ms-vscode.remote-repositories"
        "ms-vscode.remote-server"
        "ms-vscode.vscode-js-profile-flame"
        "ms-vscode.vscode-typescript-next"
        "ms-vsliveshare.vsliveshare"
        "naumovs.color-highlight"
        "nefrob.vscode-just-syntax"
        "oderwat.indent-rainbow"
        "qwtel.sqlite-viewer"
        "redhat.java"
        "redhat.vscode-xml"
        "redhat.vscode-yaml"
        "richardwillis.vscode-gradle-extension-pack"
        "rubbersheep.gi"
        "rust-lang.rust-analyzer"
        "sibiraj-s.vscode-scss-formatter"
        "signageos.signageos-vscode-sops"
        "skellock.just"
        "sumneko.lua"
        "surajbarkale.ninja"
        "svelte.svelte-vscode"
        "syler.sass-indented"
        "tamasfe.even-better-toml"
        "timonwong.shellcheck"
        "unifiedjs.vscode-mdx"
        "voldemortensen.rainbow-tags"
        "vscjava.vscode-maven"
        "vscode-icons-team.vscode-icons"
        "Vue.volar"
        "WakaTime.vscode-wakatime"
        "wayou.vscode-todo-highlight"
        "xlthu.pangu-markdown"
        "xshrim.txt-syntax"
        "yzhang.markdown-all-in-one"
        "zamerick.vscode-caddyfile-syntax"
        "zignd.html-css-class-completion"
      ];
    };
  };
}
