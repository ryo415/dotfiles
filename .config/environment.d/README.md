# environment.d
## 概要
environment.dが読まれるのは`systemd --user`で起動された時のみ  
ex1) Display Manager(GDM/SDDM等)  
  -> systemd user起動  
  -> environment.dが読まれる  
  -> sway起動  
ex2) systemd-run等でセッション起動  
  -> systemd経由  
  -> environment.dが読まれる  
TTYでの起動は読まれない  
ex1) TTYログイン  
  -> bash / zsh  
  -> sway  
  
## 読まれない場合の解決策
### profileでのexport
.zprofileや.profileにて
```
export WLR_NO_HARDWARE_CURSORS=1
```
を記載
### alias
.zshrc等で
```
alias sway="WLR_NO_HARDWARE_CURSORS=1 sway"
```
を記載
