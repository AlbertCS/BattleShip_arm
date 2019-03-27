@;=========== Fichero fuente principal de la práctica de los barcos  ===========
@;== 	define las variables globales principales del juego (matriz_barcos,	  ==
@;== 	matriz_disparos, ...), la rutina principal() y sus rutinas auxiliares ==
@;== 	programador1: bernat.bosca@estudiants.urv.cat							  ==
@;== 	programador2: albert.canellas@estudiants.urv.cat							  ==


@;-- símbolos habituales ---
NUM_PARTIDAS = 150


@;--- .bss. non-initialized data ---

.bss
	nd8: .space 4					@; promedio de disparos para tableros de 8x8
	nd9: .space 4					@; de 9x9
	nd10: .space 4					@; de 10x10
	matriz_barcos:	 .space 100		@; códigos de los barcos a hundir
	matriz_disparos: .space 100		@; códigos de los disparos realizados


@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm


@; principal():
@;	rutina principal del programa de los barcos; realiza n partidas para cada
@;	uno de los 3 tamaños de tablero establecidos (8x8, 9x9 y 10x10), calculando
@;	el promedio del número de disparos necesario para hundir toda la flota,
@;	que se inicializará en posiciones aleatorias en cada partida; los valores
@;	promedio se deben escribir en las variables globales 'nd8', 'nd9' y 'nd10',
@;	respectivamente.
		.global principal
principal:
		push {lr}
		mov r0, #NUM_PARTIDAS
		cmp r0, #0						@; comprovar que hi han partides
		beq .Lnada
		mov r0, #8						@; R0: dim; tamaño de los tableros (dimxdim)
		ldr r1, =matriz_barcos			@; R1: tablero_barcos[];
		ldr r2, =matriz_disparos		@; R2: tablero_disparos[];
		ldr r3, =nd8					@; R3: var_promedio (dir)
		bl realizar_partidas			@; entrem en realizar_partida
		ldr r12, =nd8					@; R12: puntero a nd8
		str r3, [r12]					@; guardem R3 en nd8
		mov r0, #9
		ldr r1, =matriz_barcos
		ldr r2, =matriz_disparos
		ldr r3, =nd9
		bl realizar_partidas
		ldr r11, =nd9
		str r3, [r11]					@; guardem R3 en nd9
		mov r0, #10
		ldr r1, =matriz_barcos
		ldr r2, =matriz_disparos
		ldr r3, =nd10
		bl realizar_partidas
		ldr r10, =nd10
		str r3, [r10]					@; guardem R3 en nd10
		.Lnada:
		ldr r1, =nd8					@; comprovar resultats
		ldr r2, =nd9
		ldr r3, =nd10
		pop {pc}



@; realizar_partidas(int dim, char tablero_barcos[], 
@;								char tablero_disparos[], char *var_promedio):
@;	rutina para realizar un cierto número de partidas (NUM_PARTIDAS) de la
@;	batalla de barcos, sobre un tablero de barcos y un tablero de disparos
@;	pasados por parámetro, junto con la dimensión de dichos tableros, de
@;	modo que se calcula el promedio de disparos de cada partida necesarios para
@;	hundir todos los barcos; dicho promedio se almacena en la posición de
@;	memoria referenciada por el parámetro 'var_promedio'.
@;	Parámetros:
@;		R0: dim; tamaño de los tableros (dimxdim)
@; 		R1: tablero_barcos[]; dirección base del tablero de barcos
@; 		R2: tablero_disparos[]; dirección base del tablero de disparos
@;		R3: var_promedio (dir); dirección de la variable que albergará el pro-
@;								medio de disparos.
realizar_partidas:
		push {lr}
		mov r5, #0						@; R5: dis_Totals
		mov r6, #NUM_PARTIDAS			@; R6: npartidas
		mov r7, r0						@; R7: dim
		mov r9, r1						@; R9: guardem tablero_barcos[];
		mov r12, r0						@; R12: dim
		.Lwhile:
			cmp r6, #0
			ble .Lfinwhile
			.Linibarcos:
				mov r0, r7					@; recuperem dim si no s'han inicialitzat be els barcos
				bl B_inicializa_barcos		@; R0: es converteix en un nombre,
				cmp r0, #0					@; 		si es !0 -> operació correcta
				beq .Linibarcos
				b .Lfinibarcos
			.Lfinibarcos:
			mov r0, r12					@; R0: torna a ser dim
			bl B_inicializa_disparos	@; inicialitzem el taulell de dispars
			mov r1, r2					@; R1: tablero_disparos[];
			bl jugar
			mov r1, r9					@; recuperem tablero_barcos[];
			mov r4, r0					@; R4: dis_partida
			add r5, r4					@; acumulem els dispars en R5
			sub r6, #1					@; r6 menys 1
			b .Lwhile
		.Lfinwhile:
		mov r0, r5						@; R0: pasa a ser dis_Totals
		mov r1, #NUM_PARTIDAS			@; R1: NUM_PARTIDAS
		mov r2, #0
		bl div_mod						@; retorna el quocient a R2
		ldr r3, [r2]					@; R3: var_promedio (dir)
		pop {pc}



@; B_inicialitzar_disparos(int dim, char tablero_disparos[]):
@;	rutina para colocar todas las casillas del tablero de disparos con un
@;	signo de interrogacion '?'
@;	Parámetros:
@;		R0: dim; tamaño de los tableros (dimxdim)
@;		R2: tablero_disparos[]; dirección base del tablero de disparos
B_inicializa_disparos:
		push {r1, r7, lr}
		mul r7, r0, r0					@; R7: dim_total
		mov r8, #0						@; R8: i;
		.Lforfor:
			cmp r8, r7
			bge .Lfiforfor
			mov r1, #'?'				@; R1: '?';
			strb r1, [r2, r8]				@; ficar '?' en la coordena
			add r8, #1					@; R8: i++;
			b .Lforfor
		.Lfiforfor:
		pop {r1, r7, pc}



.end

