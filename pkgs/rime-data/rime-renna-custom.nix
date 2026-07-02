{
  lib,
  linkFarm,
  writeText,
  sansSerifFont ? "Noto Sans CJK SC",
  monospaceFont ? "Maple Mono Normal NF CN",
}: let
  makeDict = name: dicts: let
    body = builtins.toJSON {
      inherit name;
      version = "1.0";
      sort = "by_weight";
      use_preset_vocabulary = false;
      import_tables = dicts;
    };
  in ''
    # Rime dictionary
    # encoding: utf-8

    ---
    ${body}

    ...
  '';
in
  linkFarm "rime-renna-custom" (lib.mapAttrs writeText {
    "share/rime-data/default.custom.yaml" = builtins.toJSON {
      patch = {
        schema_list = [{schema = "rime_mint";}];
      };
    };

    "share/rime-data/rime_mint.custom.yaml" = builtins.toJSON {
      patch = {
        "grammar/language" = "wanxiang-lts-zh-hans";
        "grammar/collocation_max_length" = 8;
        "grammar/collocation_min_length" = 2;
        "grammar/collocation_penalty" = -16;
        "grammar/non_collocation_penalty" = -8;
        "grammar/weak_collocation_penalty" = -100;
        "grammar/rear_penalty" = -20;
        "speller/algebra/+" = [
          "abbrev/^([a-z]{2,}).+$/$1/"
          "derive/v/u/"
        ];
        "translator/dictionary" = "rime_mint.custom";
        "translator/contextual_suggestions" = true;
        "translator/max_homophones" = 7;
        "translator/max_homographs" = 7;
      };
    };

    "share/rime-data/rime_mint.custom.dict.yaml" = makeDict "rime_mint" [
      "dicts/custom_renna"
      "dicts/canton_places"
      "dicts/CustomPinyinDictionary"
      "dicts/tone_moe"
      "dicts/zhwiki"
      "dicts/rime_mint.chars"
      "dicts/rime_mint.base"
      "dicts/rime_mint.correlation"
      "dicts/rime_mint.compatible"
      "dicts/rime_mint.ext"
      "dicts/other_kaomoji"
      "dicts/rime_ice.others"
    ];

    "share/rime-data/dicts/custom_renna.dict.yaml" = builtins.readFile ./custom_renna.dict.yaml;

    "share/rime-data/dicts/canton_places.dict.yaml" = builtins.readFile ./canton_places.dict.yaml;

    "share/rime-data/squirrel.custom.yaml" = builtins.toJSON {
      patch = {
        style = {
          inline_preedit = true;
          color_scheme = "catppuccin_macchiato";
          color_scheme_dark = "catppuccin_macchiato";
          candidate_list_layout = "linear";

          candidate_format = "%c %@ ";
          corner_radius = 6;
          hilited_corner_radius = 5;
          line_spacing = 8;
          border_height = 1;
          border_width = 1;
          show_paging = true;
          font_face = sansSerifFont;
          font_point = 17;
          label_font_face = monospaceFont;
          label_font_point = 13;
          comment_font_face = sansSerifFont;
        };
        preset_color_schemes = {
          catppuccin_macchiato = {
            name = "Catppuccin Macchiato";

            back_color = "0x261918"; # 候选条背景色 Crust
            border_color = "0x30201E"; # 边框色 Mantle
            text_color = "0xE0C0B8"; # 拼音行文字颜色 Subtext1
            label_color = "0xCBADA5"; # 预选栏编号颜色 Subtext0
            candidate_text_color = "0xF5D3CA"; # 预选项文字颜色 Text
            hilited_back_color = "0xF6A0C6"; # 第一候选项背景背景色 Mauve
            hilited_candidate_text_color = "0x3A2724"; # 第一候选项文字颜色 Base
            hilited_candidate_label_color = "0x4F3A36"; # 第一候选项编号颜色 Surface0
            hilited_text_color = "0x70B558"; # 高亮拼音 (需要开启内嵌编码) Surface2
            hilited_comment_text_color = "0x4F3A36"; # 注解文字高亮 Surface2
            comment_text_color = "0x70B558"; # 拼音等提示文字颜色 Surface0
          };
        };
      };
    };

    "share/rime-data/weasel.custom.yaml" = builtins.toJSON {
      patch = {
        show_notifications = false;
        style = {
          color_scheme = "steam";
          color_scheme_dark = "steam";
          font_face = "MiSans, MiSans L3, Segoe UI Emoji:30:39, Segoe UI Emoji:23:23, Segoe UI Emoji:2a:2a, Segoe UI Emoji:fe0f:fe0f, Segoe UI Emoji:20e3:20e3, Microsoft YaHei, SF Pro, Segoe UI Emoji, Noto Color Emoji";
          label_font_face = "Fira Code";
          comment_font_face = "MiSans, MiSans L3";
          comment_font_point = 12;
          inline_preedit = true;
          horizontal = true;
          "layout/corner_radius" = 5;
        };
      };
    };
  })
