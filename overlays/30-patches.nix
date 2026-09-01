_: final: prev: {
  ddcci-driver = prev.ddcci-driver.overrideAttrs (new: old: {
    src = prev.fetchFromGitLab {
      # https://gitlab.com/dkadioglu/ddcci-driver-linux/-/tree/replace-strncpy-strscpy
      owner = "dkadioglu";
      repo = "ddcci-driver-linux";
      rev = "db5d6b87b2c85ff91a4470c50a4da99534d9917c";
      hash = "sha256-l8e9J2ZVtH5rJ47toi+A1K0mneQu1W/ik2cQHz7QRwY=";
    };
  });
}
