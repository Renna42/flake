{
  lib,
  ida-free,
  requireFile,
  libxtst,
  hexPatches ? [],
}:
(ida-free.override
  {
    inherit hexPatches;
  }).overrideAttrs (new: old: {
  pname = "ida-pro";
  version = "9.5.261026";

  src = requireFile {
    name = "ida-pro_95_x64linux.run";
    url = "https://my.hex-rays.com/";
    sha256 = "f8bbc7904ab7ab1b864bbaa698374396d52afacd3c39403db6dff2d0cf355075";
  };

  buildInputs =
    old.buildInputs
    ++ [
      libxtst
    ];

  meta = {
    description = "The world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-pro/";
    changelog = "https://hex-rays.com/products/ida/news/";
    license = lib.licenses.unfree;
    mainProgram = "ida";
    platforms = ["x86_64-linux"];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
    ];
  };
})
