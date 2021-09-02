{ inputs
, makesExecutionId
, outputs
, projectSrc
, projectSrcMutable
, ...
}:
let
  agnostic = import ./agnostic.nix { };

  args = agnostic // {
    inherit inputs;
    inherit makesExecutionId;
    inherit outputs;
    inherit projectSrc;
    projectPath = import ./project-path/default.nix args;
    projectPathLsDirs = import ./project-path-ls-dirs/default.nix args;
    projectPathMutable = rel: projectSrcMutable + rel;
    projectPathsMatching = import ./project-paths-matching/default.nix args;
    projectSrcInStore = builtins.path { name = "head"; path = projectSrc; };
    inherit projectSrcMutable;

    # Impure, require sandbox and restricted evaluation set to false
    lintGitCommitMsg = import ./lint-git-commit-msg/default.nix args;
    lintWithAjv = import ./lint-with-ajv/default.nix args;
    makeNodeJsEnvironment = import ./make-node-js-environment/default.nix args;
    makeNodeJsModules = import ./make-node-js-modules/default.nix args;
  };
in
args
