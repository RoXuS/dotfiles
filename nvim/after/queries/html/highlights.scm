; ; Cas où l’attribut Lit n’est pas reconnu et part en ERROR :
; ; on match directement ".quelquechose=" au début d’un attribute
; ((attribute) @tag.attribute
;   (#match? @tag.attribute "^[\\.@?][A-Za-z0-9_-]+="))
