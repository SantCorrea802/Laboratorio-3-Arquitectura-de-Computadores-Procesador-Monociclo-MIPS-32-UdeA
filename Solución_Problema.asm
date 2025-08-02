.data
vector: .word -41, -93, 11, 8, 4, 75, 53, -43, 14, 28, 60, -38, -70, 77, 65, 21
n: .word 16
pares: .word 0
impares: .word 0
incremento: .word 0 # i
incremento_2: .word 0 #j
decremento: .word 1
auxiliar: .word 0
aumento: .word 4
pila: .word 64
comparador: .word 1 # comparador para el loop exterior 
comparador_2: .word 15 # comparador para el loop interior (len(arreglo)-1)
.text

main:	
	lhu $a0, 64($zero) # Cargar el valor de n en $a0 usando lhu # $a0 = n (longitud del vector)
	
	lw $a1, 0($zero) # $a1 = base del vector (primer elemento)
	lw $a2, incremento # i
	lw $a3, incremento_2 # j
	lw $s0, decremento
	lw $s1, pila # 64
	lw $s2, n # tamaño del vector
	lw $s3, comparador # este valor es 1, para usarlo como comparador en los loops
	lw $s4, comparador_2 # comparador para el loop interior (len(arreglo)-1)
	lw $s5, aumento
	lw $s6, auxiliar
	
	add $t0, $zero, $zero # Inicializamos el contador de numeros pares en 0
	add $t1, $zero, $zero # Inicializamos el contador de numeros impares en 0
	add $t2, $zero, $zero # Inicializamos el indice en 0
	lw $a1, 0($zero) # $a1 = base del vector (primer elemento)
	and $a1, $zero, $zero # Inicializar $a1 a 0 usando `and`

loop_exterior:
	slt $t3, $a2, $s2 # si $a2 < $s2 (el indice (i) es menor a el tamaño del vector) entonces $t3 = 1, sino, $t3 = 0
	add $a3, $zero, $zero
	add $a1, $zero, $zero
	beq $t3, $s3, loop_interior # Si la condicion anterior se cumple, pasamos a loop_interior
	
	j fin_loop

loop_interior:
	slt $t3, $a3, $s4 # si $a3 < $s4 (el indice (j) es menor a el tamaño del vector - 1) entonces $t3 = 1, sino, $t3 = 0
	beq $t3, $s3, condicional_interna # Si la condicion anterior se cumple, pasamos a loop_interior
	add $a2, $a2, $s3
	j loop_exterior

condicional_interna:
	lw $t6, 0($a1) # guardamos en $t6, el elemento actual vector[j]
	lw $t7, 4($a1) # guardamos en $t7, el elemento siguiente vector[j+1]
	
	slt $t3, $t6, $t7 # si $t6 < $t7 (vector[j] < vector[j+1]) entonces $t3 = 1, sino, $t3 = 0
	beq $t3, $s3, ordenar # usaremos ·s3 = comparador = 1 para reciclarlo en este beq, es decir, si se cumple lo anterior, ordenamos
	add $a3, $a3, $s3 # aumentamos en 1 el contador j
	add $t5, $t4, $s5 # pasamos al siguiente siguiente elemento y sera el nuevo elemento siguiente
	add $a1, $a1, $s5
	j loop_interior


ordenar:
	lw $s6, 0($a1) # auxiliar = vector[j]
	lw $t4, 4($a1) # vector[j] = vector[j+1]
	or $t5, $s6, $zero # Copiar $s6 a $t5 usando `or`  add $t5, $zero, $s6  vector[j+1] = auxiliar
	sw $t4, 0($a1)
	sw $t6, 4($a1)
	add $a3, $a3, $s3 # aumentamos en 1 el contador j
	add $t5, $t4, $s5 # pasamos al siguiente siguiente elemento y sera el nuevo elemento siguiente
	add $a1, $a1, $s5
	
	j loop_interior
	
fin_loop:
	
	

	# inicializamos los registros de pares e impares
	lw $s0, pares
	lw $s1, impares
	

	add $a1, $zero, $zero # Inicializar a1 en 0, que será la direccion base del vector
	add $t2, $zero, $zero

contador_paridad:
	
	beq $t2, $a0, salir # si el contador es igual al tamaño del vector, salimos
	
	lw $t0, 0($a1) # Valor base del vector
	
	
	
	andi $t1, $t0, 1      # Hacemos and en el bit menos significativo entre $t0 y 1 y l bit menos significativo se guarda en $t1
			      # Si el bit menos significativo es 1, significa que es impar, si es 0, es par
			      
    	beq $t1, $zero, es_par # Si $t1 == 0, el número es par
    	j es_impar
    

es_par:
	add $s0, $s0, $s3 # aumentamos en 1 el numero de pares
	add $a1, $a1, $s5 # pasamos al siguiente elemento del vector
	add $t2, $t2, $s3 # aumentamos el indice del loop
	j contador_paridad

es_impar:
	add $s1, $s1, $s3
	add $a1, $a1, $s5
	add $t2, $t2, $s3 # aumentamos el indice del loop
	j contador_paridad
salir:

	# find del programa
	# los numeros pares e impares estarian guardados en $s0 y $s1 respectivamente
	sw $s0, pares
	sw $s1, impares
	jal probar
	j fin_programa
probar:
	nor $t9, $a0, $t3 # prueba de instrucciones
	sub $t8, $s4, $s5 # restamos $s4(15) - $s5(4) = 11
	# traer el vector ordenado a los registros para visualizarlo en logisim evolution
	lw $a0, 0($zero)
	lw $a1, 4($zero)
	lw $a2, 8($zero)
	lw $a3, 12($zero)
	lw $t0, 16($zero)
	lw $t1, 20($zero)
	lw $t2, 24($zero)
	lw $t3, 28($zero)
	lw $t4, 32($zero)
	lw $t5, 36($zero)
	lw $t6, 40($zero)
	lw $t7, 44($zero)
	lw $s2, 48($zero)
	lw $s3, 52($zero)
	lw $s4, 56($zero)
	lw $s5, 60($zero)
	jr $ra
fin_programa: