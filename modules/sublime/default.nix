/*

Sublime Text settings (macOS only; the app is a cask)

*/

{ username, ... }:

{
  home-manager.users.${username} = {
    home.file."Library/Application Support/Sublime Text/Packages/Declarative/Preferences.sublime-settings".source =
      ./Preferences.sublime-settings;
  };
}
