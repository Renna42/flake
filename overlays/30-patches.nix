_: final: prev: {
  wireshark = prev.wireshark.overrideAttrs (new: old: {
    src = prev.fetchFromGitLab {
      repo = "wireshark";
      owner = "wireshark";
      tag = "v${new.version}";
      hash = "sha256-Zvrwxjp4LK2J3QnxmPxKKrU01YHQvPyp54UWzeGNCjA=";
    };
  });

  openldap = prev.openldap.overrideAttrs {
    doCheck = false;
  };
}
