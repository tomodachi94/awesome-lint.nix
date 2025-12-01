{
  lib,
  nodejs,
  buildNpmPackage,
  importNpmLock,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "awesome-lint";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "awesome-lint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-G8LAuzdl8heNjQyY5onDB1GgtBmWlgtBWKMmr6U3Dik=";
  };

  postPatch = ''
    rm .npmrc
  '';

  npmConfigHook = importNpmLock.npmConfigHook;
  npmDeps = importNpmLock {
    npmRoot = finalAttrs.src;
    packageLock = lib.importJSON ./package-lock.json;
  };
  dontNpmBuild = true;

  meta = {
    description = "Linter for Awesome lists";
    homepage = "https://github.com/sindresorhus/awesome-lint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
    mainProgram = "awesome-lint";
    platforms = nodejs.meta.platforms;
  };
})
