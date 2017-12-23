;sublayer
  Kor(key0, key1, key2 := 0, modifier := "LShift") {
    if GetKeyState(modifier) {
      Send key2? key2 : key1
      KeyWait modifier 
    } else {
      Send key1
    }
  }

  ;Space & vk44::Kor "d", "{Esc}", "{Esc}"
  ;Space & vk46::Kor "f", "{Enter}", "{Ins}"
  ;Space & vk47::Kor "g", "{BS}", "{Del}"
  ;$Space::Space
  ;RWin & Space:: Send "{Space}"
  ;RWin & BS::Send "{BS}"

;russian
  ;RWin & vk51::Kor "q", "й", "Й"
  ;RWin & vk57::Kor "w", "ц", "Ц"
  ;RWin & vk45::Kor "e", "у", "У"
  ;RWin & vk52::Kor "r", "к", "К"
  ;RWin & vk54::Kor "t", "е", "Е"
  ;RWin & vk59::Kor "y", "н", "Н"
  ;RWin & vk55::Kor "u", "г", "Г"
  ;RWin & vk49::Kor "i", "ш", "Ш"
  ;RWin & vk4F::Kor "o", "щ", "Щ"
  ;RWin & vk50::Kor "p", "з", "З"
  ;RWin & vkDB::Kor "[", "х", "Х"
  ;RWin & vkDD::Kor "]", "ъ", "Ъ"
  
  ;RWin & vk41::Kor "a", "ф", "Ф"
  ;RWin & vk53::Kor "s", "ы", "Ы"
  ;RWin & vk44::Kor "d", "в", "В"
  ;RWin & vk46::Kor "f", "а", "А"
  ;RWin & vk47::Kor "g", "п", "П"
  ;RWin & vk48::Kor "h", "р", "Р"
  ;RWin & vk4A::Kor "j", "о", "О"
  ;RWin & vk4B::Kor "k", "л", "Л"
  ;RWin & vk4C::Kor "l", "д", "Д"
  ;RWin & vkBA::Kor ";", "ж", "Ж"
  ;RWin & vkDE::Kor "'", "э", "Э"
  ;RWin & vkDC::Kor "\", "\", "|"
  
  ;RWin & vk5A::Kor "z", "я", "Я"
  ;RWin & vk58::Kor "x", "ч", "Ч"
  ;RWin & vk43::Kor "c", "с", "С"
  ;RWin & vk56::Kor "v", "м", "М"
  ;RWin & vk42::Kor "b", "и", "И"
  ;RWin & vk4E::Kor "n", "т", "Т"
  ;RWin & vk4D::Kor "m", "ь", "Ь"
  ;RWin & vkBC::Kor ",", "б", "Б"
  ;RWin & vkBE::Kor ".", "ю", "Ю"
  ;RWin & vkBF::Kor "/", "ё", "Ё"
  
  ;Space & vk51::Kor "q", "!"
  ;Space & vk57::Kor "w", "@"
  ;Space & vk45::Kor "e", "{#}"
  ;Space & vk52::Kor "r", "$"
  ;Space & vk54::Kor "t", "%"
  ;Space & vk59::Kor "y", "^"
  ;Space & vk55::Kor "u", "&"
  ;Space & vk49::Kor "i", "*"
  ;Space & vk4F::Kor "o", "("
  ;Space & vk50::Kor "p", ")"
  ;Space & vkDB::Kor "[", "_"
  ;Space & vkDD::Kor "]", "+"
  
  ;Space & vk41::
  ;Space & vk53::return
  ;Space & vk44::Kor "d", "{Esc}", "{Esc}"
  ;Space & vk46::Kor "f", "{Enter}", "{Ins}"
  ;Space & vk47::Kor "g", "{BS}", "{Del}"
  ;Space & vk48::Kor "h", "{Left}", "^{Left}"
  ;Space & vk4A::Kor "j", "{Down}", "^{Down}"
  ;Space & vk4B::Kor "k", "{Up}", "^{Up}"
  ;Space & vk4C::Kor "l", "{Right}", "^{Right}"
  ;Space & vkBA::
  ;Space & vkDE::
  ;Space & vkDC::
  
  ;Space & vk5A::
  ;Space & vk58::
  ;Space & vk43::
  ;Space & vk56::
  ;Space & vk42::
  ;Space & vk4E::
  ;Space & vk4D::
  ;Space & vkBC::
  ;Space & vkBE::
  ;Space & vkBF::
  ;return
