{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  programs.vscodium = {
    enable = true;
    package = unstablePkgs.vscodium;
    mutableExtensionsDir = false;
    profiles.default = {
      userSettings =
        {
          # keep-sorted start block=yes
          "[astro]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[bats]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };
          "[css]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
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
          "[dockerfile]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };
          "[github-actions-workflow]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "[hosts]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };
          "[html]" = {
            "editor.defaultFormatter" = "vscode.html-language-features";
          };
          "[ignore]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
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
          "[jvmoptions]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };
          "[markdown]" = {
            "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
          };
          "[properties]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };
          "[python]" = {
            "editor.defaultFormatter" = "ms-python.black-formatter";
            "editor.tabSize" = 4;
          };
          "[shellscript]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
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
          "[xml]" = {
            "editor.defaultFormatter" = "redhat.vscode-xml";
          };
          "[yaml]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "claudeCode.disableLoginPrompt" = true;
          "claudeCode.preferredLocation" = "panel";
          "database-client.telemetry.usesOnlineServices" = false;
          "debug.javascript.autoAttachFilter" = "disabled";
          "diffEditor.ignoreTrimWhitespace" = false;
          "docker.extension.enableComposeLanguageServer" = true;
          "editor.acceptSuggestionOnEnter" = "smart";
          "editor.accessibilitySupport" = "off";
          "editor.bracketPairColorization.enabled" = true;
          "editor.guides.bracketPairs" = "active";
          "editor.inlineSuggest.enabled" = true;
          "editor.smoothScrolling" = false;
          "editor.stickyScroll.enabled" = true;
          "explorer.confirmDelete" = false;
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
          "files.associations" = {
            "LICENSE" = "plaintext";
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
          "json.schemaDownload.trustedDomains" = {
            "https://schemastore.azurewebsites.net/" = true;
            "https://raw.githubusercontent.com/microsoft/vscode/" = true;
            "https://raw.githubusercontent.com/devcontainers/spec/" = true;
            "https://www.schemastore.org/" = true;
            "https://json.schemastore.org/" = true;
            "https://json-schema.org/" = true;
            "https://developer.microsoft.com/json-schemas/" = true;
            "https://raw.githubusercontent.com" = true;
          };
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
              "nixpkgs" = {
                "expr" = "import (builtins.getFlake \"${config.home.homeDirectory}/flake\").inputs.nixpkgs {}";
              };
              "formatting" = {
                "command" = ["alejandra"];
              };
            };
          };
          "prettier.tabWidth" = 2;
          "python.languageServer" = "Pylance";
          "redhat.telemetry.enabled" = false;
          "search.smartCase" = true;
          "security.workspace.trust.untrustedFiles" = "open";
          "svelte.enable-ts-plugin" = true;
          "terminal.integrated.initialHint" = false;
          "typescript.locale" = "en";
          "typescript.preferences.importModuleSpecifier" = "non-relative";
          "typescript.suggest.autoImports" = true;
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "update.mode" = "none";
          "workbench.colorCustomizations" = {
            "terminal.background" = "#00000000";
          };
          "workbench.productIconTheme" = "fluent-icons";
          "workbench.startupEditor" = "none";
          "workbench.tree.enableStickyScroll" = true;
          "yaml.disableSchemaDetection" = [
            "**/docker-compose.yml"
            "**/docker-compose.yaml"
            "**/docker-compose.*.yml"
            "**/docker-compose.*.yaml"
            "**/compose.yml"
            "**/compose.yaml"
            "**/compose.*.yml"
            "**/compose.*.yaml"
            "**/.github/workflows/*.yml"
            "**/.github/workflows/*.yaml"
            "**/.gitea/workflows/*.yml"
            "**/.gitea/workflows/*.yaml"
            "**/.forgejo/workflows/*.yml"
            "**/.forgejo/workflows/*.yaml"
          ];
          "yaml.schemas" = {
            "https://raw.githubusercontent.com/docker/vscode-extension/6a88caada42b57090df7ce91ec2a6561b422afe1/misc/empty.json" = [
              "compose*y*ml"
              "docker-compose*y*ml"
            ];
          };
          # keep-sorted end
        }
        // import ./fonts.nix config.stylix.fonts;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = pkgs.nix4vscode.forVscodeVersion config.programs.vscodium.package.version [
        # keep-sorted start case=no
        "13xforever.language-x86-64-assembly"
        "aaron-bond.better-comments"
        "astro-build.astro-vscode"
        "bradlc.vscode-tailwindcss"
        "christian-kohler.path-intellisense"
        "clinyong.vscode-css-modules"
        "csstools.postcss"
        "cweijan.vscode-database-client2"
        "cweijan.vscode-office"
        "Dart-Code.dart-code"
        "Dart-Code.flutter"
        "datakurre.devenv"
        "davidanson.vscode-markdownlint"
        "dbaeumer.vscode-eslint"
        "dnicolson.binary-plist"
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
        "matthewpi.caddyfile-support"
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
        "Vue.volar"
        "WakaTime.vscode-wakatime"
        "wayou.vscode-todo-highlight"
        "xlthu.pangu-markdown"
        "xshrim.txt-syntax"
        "yzhang.markdown-all-in-one"
        "zignd.html-css-class-completion"
        # keep-sorted end
      ];
    };
  };

  stylix.targets.vscodium.enable = false;
  catppuccin.vscodium.profiles.default.enable = true;

  home.sessionVariables = {
    EDITOR = "codium -wn";
  };
}
