#hotstring EndChars `t
#include *i ..\snippets_my.ahk 
#include *i ..\snippets_work.ahk 

; *  - ending char is not required
; ?  - trigger inside word (?0 - turn it off)
; b0 - turn off auto backspacing (b - turn it on)
; c  - case sensitive (c0 - turn it off)
; c1 - case conform (abc, Abc, ABC expands hotstring approrpiate)
; kN - key delay (in ms, -1 is no delay)
; o  - omit ending char
; pN - priority ???
; r  - send raw (r0 - turn it off)
; si/sp/se - method to send: sendinput/sendplay/sendevent (si - default)
; t  - send raw without translating character to keystroke (t0/r0 - turn it off) ???
; z  - reset hotstring recognition (for preventing recursion on b0 is off) (z0 - turn it off)

:o:im::
  Sleep 50
  Send "{!}important"
  return

:o:dns1::208.67.222.222
:o:dns2::208.67.220.220
:o:rr::&raw=1
:o:кк::&raw=1

:o?:<--::{U+2190} ;left arrow
:o?:Б--::{U+2190}
:o?:-->::{U+2192} ;right arrow
:o?:--Ю::{U+2192} 
:o?:^--::{U+2191} ;up arrow
:o?:`:--::{U+2191}
:o?:v--::{U+2193} ;down arrow
:o?:м--::{U+2193}

:*?c:ББ::{U+00AB} ;double angle quutation left
:*?:<<::{U+00AB}
:*?c:ЮЮ::{U+00BB} ;double angle quutation right
:*?:>>::{U+00BB}

:o?:---::{U+2014} ;emdash
:o?:--::{U+2013}  ;endash
:o?:_::{U+2212}   ;minus

:o?:+-::{U+00B1}  ;plus-minus
:o?:/=::{U+2260}  ;not equal to
:o?:.=::{U+2260}
:o:x::{U+00D7}   ;multiplication
:o:ч::{U+00D7}
:o?:(/)::{U+2300} ;diameter
:o?:)::{U+00B0}   ;degree
:o?:...::{U+2026} ;ellipsis
:o?:ююю::{U+2026}
:o?:\::{U+0301}   ;combining acute accent

:o?:(c)::{U+00A9} ;copyright
:o?:(с)::{U+00A9}
:o?:(r)::{U+00AE} ;registered
:o?:(к)::{U+00AE}
:o?:tm::{U+2122}  ;tm
:o?:еь::{U+2122}
:o?c:AE::{U+00C6} ;AE 
:o?c:АЕ::{U+00C6}
:o?c:ФУ::{U+00C6}
:o?c:ae::{U+00E6} ;ae 
:o?c:ае::{U+00E6}
:o?c:фу::{U+00E6}

:o?:=r::{U+20BD}  ;ruble
:o?:=к::{U+20BD}
:o?:=e::{U+20AC}  ;euro
:o?:=у::{U+20AC}
:o?:=s::{U+0024}  ;dollar
:o?:=ы::{U+0024}
:o?:=f::{U+0024}  ;pound
:o?:=а::{U+0024} 

:o?c:еЖ::ё
:o?c:ЕЖ::Ё
:o?c:ее::{U+0454} ;є 
:o?c:ЕЕ::{U+0404} 
:o?c:шш::{U+0456} ;і 
:o?c:ШШ::{U+0406}
:o?c:йй::{U+0457} ;ї 
:o?c:ЙЙ::{U+0407}

:o?cr:ёёё::``````
;:o?cr:ё::``
;:o?cr:Ё::~ 
;:o?cr:"::@ 
;:o?cr:№::#
;:o?cr:;::$ 
;:o?cr:`:::^
;:o?cr:?::& 
:o?c:х::[
:o?cr:Х::{
:o?c:ъ::]
:o?cr:Ъ::}
:o?c:ж::;
:o?c:Ж:::
:o?c:э::'
:o?c:Э::"
:o?c:б::,
:o?c:ю::.
:o?c:БЮ::<>{Left}
:o?c:Б::<
:o?c:Ю::>
:o?:,::?
:o?:.::/
