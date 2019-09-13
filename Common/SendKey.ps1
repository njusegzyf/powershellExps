
function Send-Key([String]$keyDesc) {
  [System.Windows.Forms.SendKeys]::Send($keyDesc)
  # [System.Windows.Forms.SendKeys]::SendWait($keyDesc)
}

Send-Key('{CAPSLOCK}')

# Shift + F1
Send-Key('+{F1}')

# Ctrl + F1
Send-Key('^{F1}')

# Alt + F1
Send-Key('%{F1}')

# Ctrl + Shift + Alt + F1
Send-Key('+^%{F1}')

# Alt + F4
Send-Key('%{F4}')

<#
以下是   SendKeys   的一些特殊键代码表。  
  键   代码    
  BACKSPACE   {BACKSPACE}、{BS}   或   {BKSP}    
  BREAK   {BREAK}    
  CAPS   LOCK   {CAPSLOCK}    
  DEL   或   DELETE   {DELETE}   或   {DEL}    
  DOWN   ARROW（下箭头键）   {DOWN}    
  END   {END}    
  ENTER   {ENTER}   或   ~    
  ESC   {ESC}    
  HELP   {HELP}    
  HOME   {HOME}    
  INS   或   INSERT   {INSERT}   或   {INS}    
  LEFT   ARROW（左箭头键）   {LEFT}    
  NUM   LOCK   {NUMLOCK}    
  PAGE   DOWN   {PGDN}    
  PAGE   UP   {PGUP}    
  PRINT   SCREEN   {PRTSC}（保留，以备将来使用）    
  RIGHT   ARROW（右箭头键）   {RIGHT}    
  SCROLL   LOCK   {SCROLLLOCK}    
  TAB   {TAB}    
  UP   ARROW（上箭头键）   {UP}    
  F1   {F1}    
  F2   {F2}    
  F3   {F3}    
  F4   {F4}    
  F5   {F5}    
  F6   {F6}    
  F7   {F7}    
  F8   {F8}    
  F9   {F9}    
  F10   {F10}    
  F11   {F11}    
  F12   {F12}    
  F13   {F13}    
  F14   {F14}    
  F15   {F15}    
  F16   {F16}    
  数字键盘加号   {ADD}    
  数字键盘减号   {SUBTRACT}    
  数字键盘乘号   {MULTIPLY}     
  数字键盘除号   {DIVIDE}    
   
  若要指定与   SHIFT、CTRL   和   ALT   键的任意组合一起使用的键，请在这些键代码之前加上以下一个或多个代码
  键   代码    
  SHIFT  +
  CTRL   ^
  ALT    %
#>