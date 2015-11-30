addi $14 $0 400 #
l0: #
lw $13 0($12) # tmp = a[address]
add $11 $11 $13 # ans += tmp
addi $12 $12 4 # ++i(address->4)
sub $15 $12 $14 #
bltz $15 l0 # (i - 400 < 0) -> l0
sw $11 0($12) #