
.data
GAME: .asciiz "Play game here\n"

.text
la $a0, GAME
printStr($a0)
