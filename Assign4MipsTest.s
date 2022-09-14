start: 	addiu $t3,$0,4 
	addiu $t2,$0,0 
 	addiu $t1,$0,1  
 	addiu $t0,$0,0  
 	addiu $t4,$0,0x2000  
loop1: 	sw $t2,0($t4)  
 	addu $t2,$t2,$t1  
 	addiu $t4,$t4,4  
	sltiu $at,$t2,16 
 	bne $at,$0,loop1 
 	addiu $t4,$t4,8  
loop2: 	subu $t2,$t2,$t1  
 	sw $t2,-8($t4) 
 	addu $t4,$t4,$t3 
 	beq $t2,$0,loop3 
 	j loop2 
loop3: 	addiu $t4,$0,0x1ff8  
	addiu $t3,$0,32 
loop4: 	lw $t5,8($t4)  
	addiu $t5,$t5,-32768 
	sw $t5,8($t4) 
 	addu $t2,$t2,$t1  
 	addiu $t4,$t4,4  
 	sltu $at,$t2,$t3  
 	bne $at,$0,loop4  
  	addiu $v0,$0,10  # service "exit/terminate"
 	syscall 
