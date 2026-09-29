# Instructions

- Keep comments few and concise.
- Comments explain rationale or interaction with a non-obvious other system,
  not what the code does.
- When in doubt, ask.
- Keep PR descriptions terse.
- After pushing a branch, give the user a command to test drive it:
  `nix develop 'github:sven-m/system-config?ref=<branch>#<host>' --refresh`
  (not `flake:cfg?ref=`; Nix ignores query parameters on registry refs).
