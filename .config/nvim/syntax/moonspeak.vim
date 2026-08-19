if exists("b:current_syntax")
    finish
endif

syn match msHateSpeech "=.*="
hi def link msHateSpeech Keyword

syn match msSkillCheck "\[.* -- .*\]"
hi def link msSkillCheck Keyword

syn match msSub "%.*%"
hi def link msSub Keyword

syn match msDescription "^.*"
hi def link msDescription Comment

syn match msHeadingBorder "^---$"
hi def link msHeadingBorder Keyword

syn match msConditional "^\s*!.*$"
hi def link msConditional Keyword

syn match msSpeaker "^\s*\S\+:"
hi def link msSpeaker Keyword

syn match msOption "^\s*\d\+\. "
hi def link msOption Number

syn match msValue "^\s*\".*\"$"
hi def link msValue String

syn match msReview "\\[^\\]*\\"
hi def link msReview Todo

let b:current_syntax = "moonspeak"
