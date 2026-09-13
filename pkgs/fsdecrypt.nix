{
  lib,
  fetchFromGitea,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fsdecrypt";
  version = "0.1.9";

  src = fetchFromGitea {
    domain = "gitea.tendokyu.moe";
    owner = "beerpsi";
    repo = "fsdecrypt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GNtn2o02t3pK4O/LbKxRr1887rCE4LhBH6HD273anAc=";
  };

  cargoHash = "sha256-4hP1iLjcCi51EYTvztVIMFrrPCa7AC9VqIW5VJ5u1Ek=";

  meta = {
    description = "Fast drag-and-drop decryption for SEGA's fscrypt containers";
    homepage = "https://gitea.tendokyu.moe/beerpsi/fsdecrypt";
    license = lib.licenses.bsd0;
    mainProgram = "fsdecrypt";
    maintainers = with lib.maintainers; [
      Renna42
    ];
    platforms = lib.platforms.unix;
  };
})
