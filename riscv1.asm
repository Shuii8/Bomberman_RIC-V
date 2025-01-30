 #All rights reserved
#Copyright belongs to Ernesto Rivera
#You can use this code freely in your project(s) as long as credit is given :)

#Inspiration taken from a MIPS assembly version done by: https://github.com/AndrewHamm/MIPS-Pong for the 
#MARS emulator

#The official repository of the RARS emulator can be found in: https://github.com/TheThirdOne/rars

# To run the project:
# 1) In the upper bar go to Run->Assemble (f3)
# 2) In the upper bar go to Tools->Bitmap Display
# 3) Configure the following settings in in the Bitmap Display:
	# a) Unit Width: 8
	# b) Unit Height: 8
	# c) Display Width: 512
	# d) Display Height: 512
	# e) Base Address: gp
	# f) Press connect to program 
# 4) In the upper bar go to Tools->Keyboard and Display MMIO Simulator and press connect to MIPS
# 5) In the upper bar go to Run->Go (f5)
# 6) Click on the lower window of the Keyboard and Display simulator to produce inputs

#Player movement is w and s for the left player and o and l for the right player.

#FOR THE STUDENTS: Internal labels of a function starts with a .

# Here I define the constants that will be used along the code
.eqv TOTAL_PIXELS, 16384#8192 The total ammount of pixels in the screen
.eqv FOUR_BYTES, 4 # The displacement in memory is done words which equals four bytes

.eqv TITLE_SCREEN_FIRST_LINE_ROW_Y, 1
.eqv TITLE_SCREEN_SECOND_LINE_ROW_Y, 12

.eqv PONG_TEXT_X, 6
.eqv PONG_TEXT_Y, 5
.eqv PONG_TEXT_H, 6

.eqv PRESS_TEXT_X, 20
.eqv PRESS_TEXT_Y, 23
.eqv PRESS_TEXT_H, 4

.eqv NAME_TEXT_X 6
.eqv NAME_TEXT_Y 40
.eqv NAME_TEXT_H, 4

.eqv WORD_1_x 15	#Winner
.eqv WORD_1_y 27

.eqv GAMEO_1_x 7	#Game Over
.eqv GAMEO_1_y 27

.eqv VIDA_1_x 3 
.eqv VIDA_1_y 9

.eqv PUNTOS_1_x 1	 
.eqv PUNTOS_y 28

.eqv NIVEL_x 3	 
.eqv NIVEL_1_y 9

.eqv POWER_UP_BOMBAX 9
.eqv POWER_UP_BOMBAY 25

.eqv POWER_UP_BOMBA2X 9
.eqv POWER_UP_BOMBA2Y 45

.eqv POWER_UP_LLAMAX 9
.eqv POWER_UP_LLAMAY 40
 
.eqv POWER_UP_PATINX 9
.eqv POWER_UP_PATINY 20

.eqv Lv_x 	1	 # Etiqueta de nivel
.eqv Lv_y 45

.eqv KEY_INPUT_ADDRESS 0xFFFF0004
.eqv KEY_STATUS_ADDRESS 0xFFFF0000
# For reference of those addreses check https://www.it.uu.se/education/course/homepage/os/vt18/module-1/memory-mapped-io/

.eqv ASCII_1 0x00000031
.eqv ASCII_2 0x00000032

.eqv MOV_UP 1
.eqv MOV_DOWN 2
.eqv MOV_LEFT 3
.eqv MOV_RIGHT 4
.eqv MOV_STAY 0
.eqv SET_BOMB 5

.eqv NO_BOMB 0
.eqv NOBOOM_BOMB 1
.eqv BOOM_BOMB 2

.eqv MURO_ARRIBA 1
.eqv MURO_ABAJO 2
.eqv MURO_IZQ 3
.eqv MURO_DER 4

.eqv INITIAL_PADDLE_POSITION 13

.eqv BLOQUE_1_x 14
.eqv BLOQUE_1_y 10
.eqv PASILLO 6

.eqv SCORE_FIRST_ROW_POINTS 5
.eqv SCORE_SECOND_ROW_POINTS 6
.eqv ROW_1 1
.eqv ROW_3 3
.eqv P1_SCORE_COLUMN 1
.eqv P2_SCORE_COLUMN 54
.eqv GAME_WIN_POINTS 10

.eqv PADDLE_LENGTH 4

.eqv TOP_PADDLE_Y_ROW 0
.eqv BOTTOM_PADDLE_Y_ROW 59 #  31 - 5 = 26 Thats the lowest point that paddle y can reach
.eqv DER_PADDLE_X_ROW 0
.eqv IZQ_PADDLE_X_ROW 511

.eqv PLAYER_1_X_POS 9
.eqv PLAYER_1_Y_POS 5
.eqv ENEMY_1_X_INIT 34
.eqv ENEMI_1_Y_INIT 5
.eqv ENEMY_2_X_INIT 29
.eqv ENEMI_2_Y_INIT 25
.eqv ENEMY_3_X_INIT 49
.eqv ENEMI_3_Y_INIT 25
.eqv ENEMY_4_X_INIT 24
.eqv ENEMI_4_Y_INIT 35
.eqv ENEMY_12_X_INIT 19
.eqv ENEMI_12_Y_INIT 25
.eqv ENEMY_13_X_INIT 24
.eqv ENEMI_13_Y_INIT 55

.eqv FIRST_COLUMN 0
.eqv LAST_COLUMN 63

.eqv BALL_RIGHT_DIR 1
.eqv BALL_LEFT_DIR -1
.eqv BALL_UP_DIR -1
.eqv BALL_DOWN_DIR 1

.eqv BALL_Y_VELOCITY_REDUCTION -1

.eqv LEFT_COLLISION_X_POS 14
.eqv RIGHT_COLLISION_X_POS 49

# The constants for the ball-pallet collision position
.eqv TOP_HIGH 0
.eqv TOP_MID 1
.eqv TOP_LOW 2
.eqv BOTTOM_HIGH 3
.eqv BOTTOM_MID 4
.eqv BOTTOM_LOW 5

# The horizontal wall limists
.eqv Y_DOWN_LIMIT 31
.eqv Y_UP_LIMIT 0

.eqv Y_MAX_COLLISION_VELOCITY 1

# Player modes
.eqv ONE_PLAYER_MODE 1
.eqv TWO_PLAYER_MODE 2


# ASSCII characters

.eqv ASCII_W 119
.eqv ASCII_S 115
.eqv ASCII_A 97
.eqv ASCII_D 100
.eqv ASCII_SPACE 32
.eqv ASCII_N 110
.eqv ASCII_K 107

# The coordinmates of the end game screen

.eqv P_CHAR_WIN_X 26
.eqv P_CHAR_WIN_Y 5
.eqv P_CHAR_WIN_H 5

.eqv PLAYER_NUM_WIN_X 33
.eqv PLAYER_NUM_WIN_Y 5
.eqv PLAYER_NUM_WIN_H 5

.eqv WINS_TEXT_X, 21
.eqv WINS_TEXT_Y, 16
.eqv WINS_TEXT_H, 5

 # Begin of the data section
.data
	color_white:	.word 0x00ffffff
	color_black:	.word 0x00000000
	color_black1:	.word 0x00000001
	color_black2:	.word 0x00000002
	color_red:		.word 0x00ff0000
	color_cyan: 	.word 0x0000ffff
	color_orange:	.word 0x00ffa500
	color_verde:	.word 0x0000a33d
	color_gris1:	.word 0x00f3f3f3
	color_gris2:	.word 0x00c6c6c6
	color_gris22:	.word 0x00c6c6c7
	color_grisO:	.word 0x00393939
	color_grisO2:	.word 0x002e2e2e
	color_amarillo:	.word 0x0000ffff
	color_amarillo1:.word 0x00ffc40c
	color_amarillo11:.word 0x00ffc40d
	color_amarillo12:.word 0x00ffc40e
	color_amarillo2:.word 0x00d2bd2e
	color_amarilloB:.word 0x00d2bd2f
	color_naranja:	.word 0x00e85800
	color_naranjaM:	.word 0x00e85807
	color_naranja1:	.word 0x00e85801
	color_naranja2:	.word 0x00e85802
	color_naranjaB:	.word 0x00e85803
	color_naranjaB2:.word 0x00e85806
	color_naranjaLl:.word 0x00e85804
	color_naranjaP:	.word 0x00e85805
	color_azul:		.word 0x0017a7ff
	color_azulO:	.word 0x00094293
	color_piel:		.word 0x00fdddca
	color_ladrillo:	.word 0x00c56600
	color_ladrillo2:.word 0x00a52a2a
	color_ladrillo3:.word 0x00a52a2b
	color_ladrillo4:.word 0x00a52a2c
	color_gris3:	.word 0x00a9a9a9
	color_gris4:	.word 0x009b9b9b
	color_cafe1:	.word 0x00914e11
	color_cafeT:	.word 0x00914e12
	color_cafe2:	.word 0x00864505
	color_cafe3:	.word 0x00804000
	color_cafe4:	.word 0x00804001
	color_cafe4B:	.word 0x00804002
	color_cafe4B2:	.word 0x00804005
	color_cafe4Ll:	.word 0x00804003
	color_cafe4P:	.word 0x00804004
	color_rojo:		.word 0x00ff7b5a
	color_rojo1:	.word 0x00ff7b5b
	color_rojo2:	.word 0x00a51b0b
	color_rosado:	.word 0x00ff7ea8
	color_rosado2:	.word 0x00e30052
	
	counter:			.word 1100
	time_speed_draw:.word 0
	time_draw:		.word 20
	time_draw_x:	.word 21
	time_draw_y:	.word 2

	power_up_bomba:		.word 0 
		power_up_bomba_bloque:	.word 0
		power_up_bomba_bloque2:	.word 0
	power_up_patin:		.word 0
	power_up_patin_timer:		.word 10
		power_up_patin_bloque:	.word 0 

	power_up_llama: 	.word 0
		power_up_llama_bloque:	.word 0
		power_up_llamax: 	.word 0
		power_up_llamay: 	.word 0
	vulnerabilidad: 	.word 200
	

	colision_bomba_player:	.word 0
	colision_enemigo_player:	.word 0
	player_power:	.word 0
	player_kills:	.word 0
	player_lives:	.word 3

	enemy_speed1:	.word 8
	enemy_speed2:	.word 6
	enemy_speed3:	.word 4
	
	enemigo1x:				.word 34
	enemigo1y:				.word 5
		enemigo1_dir:		.word 1
		enemigo1_muerte:	.word 0
	enemigo12x:				.word 19
	enemigo12y:				.word 25
		enemigo12_dir:		.word 1
		enemigo12_muerte:	.word 0
	enemigo13x:				.word 24
	enemigo13y:				.word 55
		enemigo13_dir:		.word 1
		enemigo13_muerte:	.word 0
	enemigo2x:				.word 29
	enemigo2y:				.word 25
		enemigo2_dir:		.word 3
		enemigo2_muerte:	.word 0
	enemigo3x:				.word 49
	enemigo3y:				.word 25
		enemigo3_dir:		.word 2
		enemigo3_muerte:	.word 0
	enemigo4x:				.word 24
	enemigo4y:				.word 35
		enemigo4_dir:		.word 2
		enemigo4_muerte:	.word 0
	
		
	level:				.word 1		
	state:				.word 0		#Estado o nivel del juego
	gate:				.word 0	
	bombax:				.word 0	
	bombay:				.word 0	
	bomba1x:			.word 0	
	bomba1y:			.word 0	
		bomba1_timer:			.word 0	
		bomba1_state:			.word 0
	bomba2x:			.word 0	
	bomba2y:			.word 0	
		bomba2_timer:			.word 0	
		bomba2_state:			.word 0	
	bomba3x:			.word 0	
	bomba3y:			.word 0
		bomba3_timer:			.word 0	
		bomba3_state:			.word 0
	colision_bomba_muro:		.word 0
	colision_bomba_muro1:		.word 0
	colision_bomba_muro2:		.word 0
	colision_bomba_muro3:		.word 0
	colision_bomba_muro4:		.word 0
		muerte_muro1_x:			.word 0	
		muerte_muro1_y:			.word 0	
		muerte_muro2_x:			.word 0	
		muerte_muro2_y:			.word 0	
		muerte_muro3_x:			.word 0	
		muerte_muro3_y:			.word 0	
		muerte_muro4_x:			.word 0	
		muerte_muro4_y:			.word 0

	

.text

new_game:	#Espera en la portada hasta presionar 1 para comenzar
	
	jal clear_board
	jal draw_title_screen
	li t0, 1
	sw t0, level, t1

	select_1:
    	lw t0, KEY_INPUT_ADDRESS # Verify if the player pressed an input
    	li t1, ASCII_1
    	beq t0, t1, start_game
    	
    	li a0, 1
    	li a7, 32
    	ecall
    	
    	j select_1 # If a key was not pressed go back to the loop
    	

    start_game:
		li t0, 1
		sw t0, state, t1
    	sw zero, KEY_STATUS_ADDRESS, t0 # This clears the status if a key was pressed
	j new_round	



new_round:	#Inicializa valores
	#Initialize of the required register state for  the new round
	
	li s4, PLAYER_1_X_POS	# INITIAL_PADDLE_POSITION = 0
	li s5, PLAYER_1_Y_POS
	li s10, MOV_STAY	#Direccion inicial jugador en 0
	li s9, MOV_STAY	# Direccion inicial enemigos en 0
	
	li t0, 3
	sw t0, player_lives, t1
	sw zero, player_kills, t1
	sw zero, gate, t1 
	sw zero, power_up_bomba_bloque, t1
	sw zero, power_up_bomba_bloque2, t1
	sw zero, power_up_patin_bloque, t1
	sw zero, power_up_llama_bloque, t1
	 
	sw zero, power_up_llama, t1
	sw zero, power_up_bomba, t1
	sw zero, power_up_patin, t1
	li t0, 5
	sw t0, power_up_patin_timer, t1 
	li t0, 200
	sw t0, vulnerabilidad, t1
	li t0, 4
	sw t0, enemy_speed3, t1
	li t0, 6
	sw t0, enemy_speed2, t1
	li t0, 8
	sw t0, enemy_speed1, t1

	li t0, 1100
		sw t0, counter, t1
	li t0, 20
		sw t0, time_draw, t1
	sw zero, time_speed_draw, t1

	li t0, ENEMY_1_X_INIT
	sw t0, enemigo1x, t1
	li t0, ENEMI_1_Y_INIT
	sw t0, enemigo1y, t1

	li t0, ENEMY_2_X_INIT
	sw t0, enemigo2x, t1
	li t0, ENEMI_2_Y_INIT
	sw t0, enemigo2y, t1

	li t0, ENEMY_3_X_INIT
	sw t0, enemigo3x, t1
	li t0, ENEMI_3_Y_INIT
	sw t0, enemigo3y, t1

	li t0, ENEMY_4_X_INIT
	sw t0, enemigo4x, t1
	li t0, ENEMI_4_Y_INIT
	sw t0, enemigo4y, t1

	li t0, ENEMY_12_X_INIT
	sw t0, enemigo12x, t1
	li t0, ENEMI_12_Y_INIT
	sw t0, enemigo12y, t1

	li t0, ENEMY_13_X_INIT
	sw t0, enemigo13x, t1
	li t0, ENEMI_13_Y_INIT
	sw t0, enemigo13y, t1

	sw zero, enemigo1_muerte, t1
	sw zero, enemigo12_muerte, t1
	sw zero, enemigo13_muerte, t1
	sw zero, enemigo2_muerte, t1
	sw zero, enemigo3_muerte, t1
	sw zero, enemigo4_muerte, t1
	sw zero, bomba1_timer, t1
	sw zero, bomba1_state , t1
	sw zero, bomba2_timer, t1
	sw zero, bomba2_state , t1
	sw zero, bomba3_timer, t1
	sw zero, bomba3_state , t1
	sw zero, colision_enemigo_player, t1

	jal clear_board
	jal draw_marco
	jal Time
	#Draw_level
		lw t0, level
			li t1, 1
			li t2, 2
				bne t0, t1, .level2
				jal draw_map1
				j .continue
			.level2:
				bne t0, t2, .level3
				jal draw_map2
				j .continue
			.level3:
				jal draw_map3

			.continue:
	jal draw_vidas
	jal draw_puntos
	jal erase_barra_puntos
	jal erase_barra_vidas
	jal draw_powerup_bombas
	jal draw_powerup_bombas2
	jal draw_powerup_patin
	jal draw_powerup_llama
	jal draw_enemy

	mv a0, s4						# PLAYER_1_PADDLE_X_POS = 0
	mv a1, s5
	lw a2, color_azul
	li a3, MOV_STAY
	jal	draw_paddle
	jal draw_gate
	
	li a0, 1
	li a7, 32		
	ecall		# 1 second delay

	j main_game_loop

main_game_loop: 	# Intrucciones una vez comenzado el juego
	
	
	.draw_objects:	
		
		lw t1, power_up_patin
			li t2, 1
			bne t1, t2, .lento 
			jal draw_paddle
			j .caminar
			.lento:
			lw, t0, power_up_patin_timer
			addi t0, t0, -1
			sw, t0, power_up_patin_timer, t1
			bne zero, t0, .caminar
				jal draw_paddle	
				li, t0, 5 
				sw, t0, power_up_patin_timer, t1
			.caminar:

		jal draw_gate
		jal draw_bomba 
		jal draw_vidas
		jal draw_puntos
		jal draw_enemy
		jal Time
		jal Vulnerabilidad_time
		jal draw_powerup_bombas
		jal draw_powerup_bombas2
		jal draw_powerup_patin
		jal draw_powerup_llama


		

		#jal Colision_erase_element
		

	.begin_standby:
		li t0, 2 # A counter is loaded for an aprox 50ms delay
	
	.standby:
		blez t0, .end_standby
		
		# syscall for pausing 10 ms
		li a0, 1 
		li a7, 32
		ecall		
	
		addi t0, t0, -1
		
		# check for a key press
		lw t1, KEY_STATUS_ADDRESS		#Carga el estado de entrada en t1
		blez t1, .standby				# si t1 <=0(no se presiona ninguna tecla) salte a standby
		
		jal adjust_dir					#Si se presiono una tecla salte a adjust_dir
		sw zero, KEY_STATUS_ADDRESS, t1 # Clean the state that a key has been pressed
		#j .standby
		
	.end_standby:
		j .draw_objects


#
### Funciones dinamicas
#
adjust_dir:
	lw t0, KEY_INPUT_ADDRESS
	
	.adjust_dir_left_up:
		li t1, ASCII_W
		bne t0, t1, .adjust_dir_down
		li s10, MOV_UP
		j .adjust_dir_done
	
	.adjust_dir_down:
		li t1, ASCII_S
		bne t0, t1, .adjust_dir_left
		li s10, MOV_DOWN
		j .adjust_dir_done
	
	.adjust_dir_left:
		li t1, ASCII_A
		bne t0, t1, .adjust_dir_right
		li s10, MOV_LEFT
		j .adjust_dir_done
		
	.adjust_dir_right:
		li t1, ASCII_D
		bne t0, t1, .press_space
		li s10, MOV_RIGHT
		j .adjust_dir_done

	.press_space:
		li t1, ASCII_SPACE
		bne t0, t1, .press_n
		li s11, SET_BOMB
		j .adjust_dir_done
		
	.press_n:
		li t1, ASCII_N
		bne t0, t1, .press_k
		lw t0, level
		addi t0, t0, 1
		sw t0, level, t1
		li t0, 4
		lw t1, level
		bne t0, t1, .nextl
		j winner
		.nextl:
		j new_round

	.press_k:
		li t1, ASCII_K
		bne t0, t1, .adjust_dir_none
		lw t0, player_kills
		addi t0, t0, 1
		sw t0, player_kills, t1
		li t0, 7
		lw t1, player_kills
		bne t0, t1, .adjust_dir_none
		li t0, 6
		sw t0, player_kills, t1

	.adjust_dir_none:
		# This section is kept as a case point if the player didn't press a valid option
	
	.adjust_dir_done:
		jr ra

adjust_dir_enemy:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	
	li  a7, 42          # Código de la llamada al sistema para rand_int_range
    li  a0, 1           # Valor mínimo (1)
    li  a1, 4           # Valor máximo (4)
    ecall
	addi a0, a0, 1
	mv s9, a0

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12

	jr ra


Colision_bomba_muros:
	addi sp, sp -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw a0, 12(sp)
	sw a1, 16(sp)
	sw s2, 20(sp)


	jal CollisionDirectionBomba
		#Colision bomba muro 

			lw t0, colision_bomba_muro1
			li t1, 1
			bne t0, t1, .colision_muro2
				lw s1, muerte_muro1_y 
				addi s1, s1, -4
				lw s0, muerte_muro1_x
				jal erase_bloque 
				sw zero, colision_bomba_muro1, t1
				

			.colision_muro2: 
			lw t0, colision_bomba_muro2
			li t1, 1
			bne t0, t1, .colision_muro3
				lw s1, muerte_muro2_y 
				lw s0, muerte_muro2_x 
				jal erase_bloque 
				sw zero, colision_bomba_muro2, t1
				

			.colision_muro3: 
			lw t0, colision_bomba_muro3
			li t1, 1
			bne t0, t1, .colision_muro4
				lw s0, muerte_muro3_x 
				addi s0, s0, -4
				lw s1, muerte_muro3_y
				jal erase_bloque 
				sw zero, colision_bomba_muro3, t1
				addi s0, s0, 5
			
			.colision_muro4: 
			lw t0, colision_bomba_muro4
			li t1, 1
			bne t0, t1, .colision_muro4__done
				lw s0, muerte_muro4_x 
				lw s1, muerte_muro4_y
				jal erase_bloque 
				sw zero, colision_bomba_muro4, t1
		
			.colision_muro4__done:

	lw s2, 20(sp)
	lw a1, 16(sp)
	lw a0, 12(sp)
	lw s1, 8(sp)
	lw s0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 24
	jr ra

Colision_jugador_bomba:
	addi sp, sp -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw a0, 12(sp)
	sw a1, 16(sp)
	sw s2, 20(sp)


	jal CollisionDirectionBomba  

				lw t0, colision_bomba_player
				beq zero, t0, .colision_jugador_done1
				lw t1, player_lives
				addi t1, t1, -1
				sw t1, player_lives, t2 
					li t0, 20
					sw t0, time_draw, t1
					li t0, 1100	#2200
					sw t0, counter, t1 
					sw zero, time_speed_draw, t1 
				mv s0, s4
				mv s1, s5
				jal erase_bloque
				jal erase_barra_vidas
				li s4, PLAYER_1_X_POS
				li s5, PLAYER_1_Y_POS
				sw zero, colision_bomba_player, t1
			 	li t0, 200 
			 	sw t0, vulnerabilidad, t1
				lw t1, player_lives 
				bne zero, t1, .colision_jugador_done1
				j game_over 

			.colision_jugador_done1:  


	lw s2, 20(sp)
	lw a1, 16(sp)
	lw a0, 12(sp)
	lw s1, 8(sp)
	lw s0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 24
	jr ra

Colision_jugador_enemigo:
	addi sp, sp -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw a0, 12(sp)
	sw a1, 16(sp)
	sw s2, 20(sp)


	jal CollisionDirection  
				lw t0, colision_enemigo_player
				beq zero, t0, .colision_jugador_done2
				lw t1, player_lives
				addi t1, t1, -1
				sw t1, player_lives, t2 
					li t0, 20
					sw t0, time_draw, t1
					li t0, 1100	#2200
					sw t0, counter, t1 
					sw zero, time_speed_draw, t1 
				mv s0, s4
				mv s1, s5
				jal erase_bloque
				jal erase_barra_vidas
				li s4, PLAYER_1_X_POS
				li s5, PLAYER_1_Y_POS
				sw zero, colision_enemigo_player, t1
			 	li t0, 200 
				sw t0, vulnerabilidad, t1
				lw t1, player_lives 
				bne zero, t1, .colision_jugador_done2
				j game_over 

			.colision_jugador_done2:
				


	lw s2, 20(sp)
	lw a1, 16(sp)
	lw a0, 12(sp)
	lw s1, 8(sp)
	lw s0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 24
	jr ra

Colision_enemigo_jugador:
	addi sp, sp -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw a0, 12(sp)
	sw a1, 16(sp)
	sw s2, 20(sp)
 
				lw t0, colision_enemigo_player
				beq zero, t0, .colision_jugador_done22E
				lw t1, player_lives
				addi t1, t1, -1
				sw t1, player_lives, t2 
					li t0, 20
					sw t0, time_draw, t1
					li t0, 1100	#2200
					sw t0, counter, t1 
					sw zero, time_speed_draw, t1 
				mv s0, s4
				mv s1, s5
				jal erase_bloque
				jal erase_barra_vidas
				li s4, PLAYER_1_X_POS
				li s5, PLAYER_1_Y_POS
				sw zero, colision_enemigo_player, t1
				li t0, 200 
				sw t0, vulnerabilidad, t1
				lw t1, player_lives 
				bne zero, t1, .colision_jugador_done22E
				j game_over 

			.colision_jugador_done22E: 


	lw s2, 20(sp)
	lw a1, 16(sp)
	lw a0, 12(sp)
	lw s1, 8(sp)
	lw s0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 24
	jr ra

CollisionColor:	#Colores con condicion de colision 
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)

	#Anular colision con colores del gate
		lw t0, color_azul
		bne a7, t0, .colorG
		li a7, 0
		j .done
		.colorG:
		lw t0, color_azulO
		bne a7, t0, .salirG
		li a7, 0
		j .done
		.salirG:

	# Colision con enemigos
		lw t0, vulnerabilidad 
		bne zero, t0, .salirE
		.enemy1A2:
		lw t0, color_amarillo2
		bne a7, t0, .enemy1 
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .done
		.enemy1:
		lw t0, color_amarillo1
		bne a7, t0, .enemy11
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .done
		.enemy11:
		lw t0, color_amarillo11
		bne a7, t0, .enemy12
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .done
		.enemy12:
		lw t0, color_amarillo12
		bne a7, t0, .enemy2
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .done
		.enemy2:
		lw t0, color_rosado
		bne a7, t0, .enemy3
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .done
		.enemy3:
		lw t0, color_naranja
		bne a7, t0, .enemy4
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .done
		.enemy4:
		lw t0, color_white
		bne a7, t0, .salirE
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .done
		.salirE:
		
		

	# Anular colision con power ups
		# Power up bombas
	
			lw t0, color_naranjaB
			bne a7, t0, .salirPB
			li a7, 0

				li  t0, 2
				sw t0, power_up_bomba_bloque, t1

				lw t0, power_up_bomba 
				li t0, 1
				sw t0, power_up_bomba , t1
			j .done
			.salirPB:

			lw t0, color_naranjaB2
			bne a7, t0, .salirPB2
			li a7, 0

				li  t0, 2
				sw t0, power_up_bomba_bloque2, t1

				lw t0, power_up_bomba 
				li t0, 2
				sw t0, power_up_bomba , t1
			j .done
			.salirPB2:
			
		# Power up llamas
			lw t0, color_naranjaLl
			bne a7, t0, .salirPP
			li a7, 0
			
			li  t0, 2
			sw t0, power_up_llama_bloque, t1

			lw t0, power_up_llama
				li t0, 1
				sw t0, power_up_llama, t1
			j .done
			.salirPP:
			
		# Power up patin
			lw t0, color_naranjaP
			bne a7, t0, .salirPLl
			li a7, 0
 
				li t0, 1
				sw t0, power_up_patin, t1
				li t0, 2
				sw t0, power_up_patin_bloque, t1
			j .done
			.salirPLl:
			

		# cafeT
			lw t0, color_cafeT
			bne a7, t0, .salirPT
			li a7, 0

			j .done
			.salirPT:
			li a7, 1

	.done:

	lw s0, 4(sp)
	lw s1, 8(sp)
	lw ra, 0(sp)
	addi sp, sp, 12
	jr ra

CollisionColorEnemy:	#Colores con condicion de colision 
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp) 

	# Colision jugador
		lw t0, vulnerabilidad 
		bne zero, t0, .Jdone2
		.Jrojo:
		lw t0, color_rojo
		bne a7, t0, .Jrojo2
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .Jdone2
		.Jrojo2:
		lw t0, color_rojo2
		bne a7, t0, .Jpiel
			li t0, 1
			sw t0, colision_enemigo_player, t1
		j .Jdone2
		.Jpiel:
		lw t0, color_piel
		bne a7, t0, .Jdone2
			li t0, 1
			sw t0, colision_enemigo_player, t1
		  
	.Jdone2:

	lw s0, 4(sp)
	lw s1, 8(sp)
	lw ra, 0(sp)
	addi sp, sp, 12
	jr ra

CollisionBombaColor:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8,(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	li a3, 0

	#Colision con colores del jugador
		lw t0, vulnerabilidad 
		bne zero, t0, .done1

		lw t0, color_piel
		bne a7, t0, .rojo
			li a3, 1
		.rojo:
		lw t0, color_rojo
		bne a7, t0, .color1
			li a3, 1
			li t0, 1
			sw t0, colision_bomba_player, t1
		.color1:
		lw t0, color_rojo2
		bne a7, t0, .done1
			li a3, 1
			li t0, 1
			sw t0, colision_bomba_player, t1
	.done1:

	#Colision con otras bombas 
		lw t0, color_naranjaM
		bne a7, t0, .black1  
			li a3, 1
		.black1:
		lw t0, color_black1
		bne a7, t0, .black2  
			sw zero, bomba2_timer, t1
		.black2:
		lw t0, color_black2
		bne a7, t0, .doneBB 
			sw zero, bomba3_timer, t1 
		.doneBB:
	#Colison con muros destruibles
		lw t0, color_cafe3
		bne a7, t0, .color2
			li a3, 0
			#verificar con que nuro colisiona
				li t0, MURO_ARRIBA
					bne a4, t0, .muro_abajo
						li a3, 0
						li t0, 1
						sw t0, colision_bomba_muro1, t1 
						sw a0, muerte_muro1_x, t1 
						sw a1, muerte_muro1_y, t1
					j .done3
				.muro_abajo:
					li t0, MURO_ABAJO
					bne a4, t0, .muro_izq
						li a3, 0
						li t0, 1
						sw t0, colision_bomba_muro2, t1 
						sw a0, muerte_muro2_x, t1 
						sw a1, muerte_muro2_y, t1
					j .done3
				.muro_izq:
					li t0, MURO_IZQ
					bne a4, t0, .muro_der
						li a3, 0
						li t0, 1
						sw t0, colision_bomba_muro3, t1 
						sw a0, muerte_muro3_x, t1 
						sw a1, muerte_muro3_y, t1
					j .done3
				.muro_der:
					li t0, MURO_DER	
					bne a4, t0, .color2	
						li a3, 0	#Ver si colisiona con muro a la derecha
						li t0, 1
						sw t0, colision_bomba_muro4, t1 
						sw a0, muerte_muro4_x, t1 
						sw a1, muerte_muro4_y, t1
					j .done3
	# Gate y Power up
			
			.color2:
			 
			lw t0, color_cafe4
			bne a7, t0, .colorA 
				li a3, 0
				li t0, 1
				sw t0, gate, t1
			j .done2 
			.colorA:
			lw t0, color_azul
			bne a7, t0, .colorAO 
				li a3, 1 
			j .done2 
			.colorAO:
			lw t0, color_azulO
			bne a7, t0, .naranjaB 
				li a3, 1 
			j .done2
			.naranjaB: 
			lw t0, color_naranjaB
			bne a7, t0, .naranjaLl
				li a3, 1 
			j .done2
			.naranjaLl:
			lw t0, color_naranjaLl
			bne a7, t0, .naranjaP
				li a3, 1 
			j .done2
			.naranjaP:
			lw t0, color_naranjaP
			bne a7, t0, .Bomba
				li a3, 1 
			j .done2
			.Bomba:
			lw t0, color_cafe4B2
			bne a7, t0, .Bomba2
				li a3, 0
				li t0, 1
				sw t0, power_up_bomba_bloque2, t1
				li s0, POWER_UP_BOMBA2X
				li s1, POWER_UP_BOMBA2Y
				jal erase_bloque
			j .done2 
			.Bomba2:
			lw t0, color_cafe4B
			bne a7, t0, .Patin
				li a3, 0
				li t0, 1
				sw t0, power_up_bomba_bloque, t1
				li s0, POWER_UP_BOMBAX
				li s1, POWER_UP_BOMBAY
				jal erase_bloque
			j .done2
			.Patin:
			lw t0, color_cafe4P
			bne a7, t0, .CafeT
				li a3, 0
				li t0, 1
				sw t0, power_up_patin_bloque, t1
				li s0, POWER_UP_PATINX
				li s1, POWER_UP_PATINY
				jal erase_bloque
			j .done2
			.CafeT:
			lw t0, color_cafeT
			bne a7, t0, .Llama
				li a3, 1  
			j .done2 
			.Llama:
			lw t0, color_cafe4Ll
			bne a7, t0, .salir2
				li a3, 0
				li t0, 1
				sw t0, power_up_llama_bloque, t1
				li s0, POWER_UP_LLAMAX
				li s1, POWER_UP_LLAMAY
				jal erase_bloque
			j .done2
			.salir2:
	.done2:

	#colision enemigos
		lw t0, color_amarillo1
		bne a7, t0, .color3
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
			li t1, 1
			sw t1, enemigo1_muerte, t2
			lw s0, enemigo1x
			lw s1, enemigo1y
			jal erase_bloque
			j .done3
		.color3:
		lw t0, color_naranja
		bne a7, t0, .color32
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
			li t1, 1
			sw t1, enemigo3_muerte, t2
			lw s0, enemigo3x
			lw s1, enemigo3y
			jal erase_bloque
			j .done3
		.color32:
		lw t0, color_rosado
		bne a7, t0, .color33
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
			li t1, 1
			sw t1, enemigo2_muerte, t2
			lw s0, enemigo2x
			lw s1, enemigo2y
			jal erase_bloque
			j .done3
		.color33:	
		lw t0, color_ladrillo2
		bne a7, t0, .color34
			li t1, 1
			sw t1, enemigo1_muerte, t2
			lw s0, enemigo1x
			lw s1, enemigo1y
			jal erase_bloque
			j .done3
		.color34:	
		lw t0, color_white
		bne a7, t0, .color35
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
			li t1, 1
			sw t1, enemigo4_muerte, t2
			lw s0, enemigo4x
			lw s1, enemigo4y
			jal erase_bloque
			j .done3
		.color35:	
		lw t0, color_rosado2
		bne a7, t0, .color36
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
			li t1, 1
			sw t1, enemigo2_muerte, t2
			lw s0, enemigo2x
			lw s1, enemigo2y
			jal erase_bloque
			j .done3
		.color36:	
		lw t0, color_amarillo11
		bne a7, t0, .color37
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
			li t1, 1
			sw t1, enemigo12_muerte, t2
			lw s0, enemigo12x
			lw s1, enemigo12y
			jal erase_bloque
			j .done3
		.color37:	
		lw t0, color_amarillo12
		bne a7, t0, .color38
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
			li t1, 1
			sw t1, enemigo13_muerte, t2
			lw s0, enemigo13x
			lw s1, enemigo13y
			jal erase_bloque
			j .done3
		.color38:	
		lw t0, color_ladrillo3
		bne a7, t0, .color39
			li t1, 1
			sw t1, enemigo12_muerte, t2
			lw s0, enemigo12x
			lw s1, enemigo12y
			jal erase_bloque
			j .done3
		.color39:	
		lw t0, color_ladrillo4
		bne a7, t0, .salir3
			li t1, 1
			sw t1, enemigo13_muerte, t2
			lw s0, enemigo13x
			lw s1, enemigo13y
			jal erase_bloque
			j .done3
		.salir3:
	
	.done3:

	lw s0, 12(sp)
	lw s1, 16(sp)
	lw a1, 8(sp)
	lw a0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 20
	jr ra

CollisionDirection:
	addi  sp,  sp, -8
	sw ra, 0(sp)
	sw a2, 4(sp)

	lw a2, color_verde
	mv a0, s4
	mv a1, s5

	.ColUp:
		li t6, MOV_UP
		bne  s10, t6, .ColDown
		#ajusta la cordenada para subir
		addi  a1,  a1, -1
		.Pixel0Up:
			jal LoadColor
			beq   a7, a2, .Pixel1Up
			jal CollisionColor
			j .ColDone
		.Pixel1Up:	
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel2Up
			jal CollisionColor
			j .ColDone
		.Pixel2Up:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel3Up
			jal CollisionColor
			j .ColDone
		.Pixel3Up:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel4Up
			jal CollisionColor
			j .ColDone
		.Pixel4Up:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.NoColUp
			jal CollisionColor
			j .ColDone
		.NoColUp:
			li   a7, 0
			li s11, 0
			j .ColDone				
							
		
	.ColDown:
		li t6, MOV_DOWN
		bne  s10, t6, .ColLeft
		#ajusta la cordenada para subir
		addi  a1,  a1, 5
		.Pixel0Down:
			jal LoadColor
			beq   a7, a2, .Pixel1Down
			jal CollisionColor
			j .ColDone
		.Pixel1Down:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel2Down
			jal CollisionColor
			j .ColDone
		.Pixel2Down:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel3Down
			jal CollisionColor
			j .ColDone
		.Pixel3Down:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel4Down
			jal CollisionColor
			j .ColDone
		.Pixel4Down:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.NoColDown
			jal CollisionColor
			j .ColDone
		.NoColDown:
			li   a7, 0
			j .ColDone			
	.ColLeft:
		li t6, MOV_LEFT
		bne  s10, t6, .ColRight
		addi  a0,  a0, -1
		.Pixel0Left:
			jal LoadColor
			beq   a7, a2,.Pixel1Left
			jal CollisionColor
			j .ColDone
		.Pixel1Left:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel2Left
			jal CollisionColor
			j .ColDone
		.Pixel2Left:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel3Left
			jal CollisionColor
			j .ColDone
		.Pixel3Left:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel4Left
			jal CollisionColor
			j .ColDone
		.Pixel4Left:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.NoColLeft
			jal CollisionColor
			j .ColDone
		.NoColLeft:
			li   a7, 0
			j .ColDone				
			
	.ColRight:
		li t6, MOV_RIGHT
		bne  s10, t6, .ColDone
		addi  a0,  a0, 5
		.Pixel0Right:
			jal LoadColor
			beq   a7, a2,.Pixel1Right
			jal CollisionColor
			j .ColDone
		.Pixel1Right:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel2Right
			jal CollisionColor
			j .ColDone
		.Pixel2Right:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel3Right
			jal CollisionColor
			j .ColDone
		.Pixel3Right:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel4Right
			jal CollisionColor
			j .ColDone
		.Pixel4Right:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.NoColRight
			jal CollisionColor
			j .ColDone
		.NoColRight:
			li   a7, 0
			j .ColDone			
	.ColDone:
	lw  ra, 0( sp)
	lw a2, 4(sp)
	addi  sp,  sp, 8
	jr  ra


PosicionarBomba:
	addi  sp,  sp, -24
	sw ra, 0(sp)
	sw a2, 4(sp)
	sw s2, 8(sp)
	sw a5, 12(sp)
	sw a6, 16(sp)
	sw s3, 20(sp)

	lw a2, color_gris2
	lw a5, color_gris3
	lw a6, color_gris4
	mv a0, s0
	mv a1, s1
	li s2, 0
	li s3, 0

	.ColUpP:
		#ajusta la cordenada para subir
		addi  a1,  a1, -1
		.Pixel0UpP:
			jal LoadColor
			bne a7, a5, .Pixel01UpP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1UpP
			.Pixel01UpP:	
			bne   a7, a2, .Pixel02UpP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1UpP
			.Pixel02UpP:	
			bne   a7, a6, .Pixel1UpP
			li s2, 1
			addi s3,  s3, 1
		.Pixel1UpP:	
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel11UpP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2UpP
			.Pixel11UpP:	
			bne   a7, a2, .Pixel12UpP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2UpP
			.Pixel12UpP:	
			bne   a7, a6, .Pixel2UpP
			li s2, 2
			addi s3,  s3, 1
		.Pixel2UpP:
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel21UpP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3UpP
			.Pixel21UpP:	
			bne   a7, a2, .Pixel22UpP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3UpP
			.Pixel22UpP:	
			bne   a7, a6, .Pixel3UpP
			li s2, 3
			addi s3,  s3, 1
		.Pixel3UpP:
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel31UpP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4UpP
			.Pixel31UpP:	
			bne   a7, a2, .Pixel32UpP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4UpP
			.Pixel32UpP:	
			bne   a7, a6, .Pixel4UpP
			li s2, 4
			addi s3,  s3, 1
			
		.Pixel4UpP:
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel41UpP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar
			.Pixel41UpP:	
			bne   a7, a2, .Pixel42UpP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar
			.Pixel42UpP:	
			bne   a7, a6, .Posicionar
			li s2, 5
			addi s3,  s3, 1

		.Posicionar:			

			li t0, 5
			beq t0, s3, .mover1_no
			beq zero, s3, .mover1_no
				li t0, 1
				bne t0, s2, .mover1_der2
					addi s0, s0, 1
					j .ColDoneP
				.mover1_der2:
				li t0, 2
				bne t0, s2, .mover1_der3
					addi s0, s0,  2
					j .ColDoneP
				.mover1_der3:
				li t0, 3
				bne t0, s2, .mover1_izq1
					addi s0, s0,  3
					j .ColDoneP
				.mover1_izq1:
				li t0, 4
				bne t0, s2, .mover1_der_1
					addi s0, s0, -1
					j .ColDoneP
				.mover1_der_1:
				li t0, 5
				li t1, 4
				bne t0, s2, .mover1_der_2
				bne s3, t1, .mover1_der_2
					addi s0, s0, 1
					j .ColDoneP
				.mover1_der_2:
				li t0, 5
				li t1, 3
				bne t0, s2, .mover1_izq_2
				bne s3, t1, .mover1_izq_2
					addi s0, s0, 2
					j .ColDoneP
				.mover1_izq_2:
				li t0, 5
				li t1, 2
				bne t0, s2, .mover1_izq_1
				bne s3, t1, .mover1_izq_1
					addi s0, s0, -2
					j .ColDoneP
				.mover1_izq_1:
				li t0, 5
				li t1, 1
				bne t0, s2, .mover1_no
				bne s3, t1, .mover1_no
					addi s0, s0, -1
					j .ColDoneP
				
				.mover1_no:	
					li s2, 0
					li s3, 0	
		
	.ColDownP:		
		mv a0, s0
		mv a1, s1
		#ajusta la cordenada para subir
		addi  a1,  a1, 5
		.Pixel0DownP:
			jal LoadColor
			bne a7, a5, .Pixel01DownP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1DownP
			.Pixel01DownP:	
			bne   a7, a2, .Pixel02DownP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1DownP
			.Pixel02DownP:	
			bne   a7, a6, .Pixel1DownP
			li s2, 1
			addi s3,  s3, 1
		.Pixel1DownP:	
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel11DownP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2DownP
			.Pixel11DownP:	
			bne   a7, a2, .Pixel12DownP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2DownP
			.Pixel12DownP:	
			bne   a7, a6, .Pixel2DownP
			li s2, 2
			addi s3,  s3, 1
		.Pixel2DownP:
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel21DownP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3DownP
			.Pixel21DownP:	
			bne   a7, a2, .Pixel22DownP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3DownP
			.Pixel22DownP:	
			bne   a7, a6, .Pixel3DownP
			li s2, 3
			addi s3,  s3, 1
		.Pixel3DownP:
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel31DownP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4DownP
			.Pixel31DownP:	
			bne   a7, a2, .Pixel32DownP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4DownP
			.Pixel32DownP:	
			bne   a7, a6, .Pixel4DownP
			li s2, 4
			addi s3,  s3, 1
			
		.Pixel4DownP:
			addi  a0,  a0, 1
			jal LoadColor
			bne a7, a5, .Pixel41DownP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar1
			.Pixel41DownP:	
			bne   a7, a2, .Pixel42DownP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar1
			.Pixel42DownP:	
			bne   a7, a6, .Posicionar1
			li s2, 5
			addi s3,  s3, 1
		.Posicionar1:			

			li t0, 5
			beq t0, s3, .mover2_no
			beq zero, s3, .mover2_no
				li t0, 1
				bne t0, s2, .mover2_der2
					addi s0, s0, 1
					j .ColDoneP
				.mover2_der2:
				li t0, 2
				bne t0, s2, .mover2_der3
					addi s0, s0,  2
					j .ColDoneP
				.mover2_der3:
				li t0, 3
				bne t0, s2, .mover2_izq1
					addi s0, s0,  3
					j .ColDoneP
				.mover2_izq1:
				li t0, 4
				bne t0, s2, .mover2_der_1
					addi s0, s0, -1
					j .ColDoneP
				.mover2_der_1:
				li t0, 5
				li t1, 4
				bne t0, s2, .mover2_der_2
				bne s3, t1, .mover2_der_2
					addi s0, s0, 1
					j .ColDoneP
				.mover2_der_2:
				li t0, 5
				li t1, 3
				bne t0, s2, .mover2_izq_2
				bne s3, t1, .mover2_izq_2
					addi s0, s0, 2
					j .ColDoneP
				.mover2_izq_2:
				li t0, 5
				li t1, 2
				bne t0, s2, .mover2_izq_1
				bne s3, t1, .mover2_izq_1
					addi s0, s0, -2
					j .ColDoneP
				.mover2_izq_1:
				li t0, 5
				li t1, 1
				bne t0, s2, .mover2_no
				bne s3, t1, .mover2_no
					addi s0, s0, -1
					j .ColDoneP
				
				.mover2_no:	
					li s2, 0
					li s3, 0	
	
	.ColLeftP:
		mv a0, s0
		mv a1, s1
		#ajusta la cordenada para subir
		addi  a0,  a0, -1
		.Pixel0LeftP:
			jal LoadColor
			bne a7, a5, .Pixel01LeftP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1LeftP
			.Pixel01LeftP:	
			bne   a7, a2, .Pixel02LeftP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1LeftP
			.Pixel02LeftP:	
			bne   a7, a6, .Pixel1LeftP
			li s2, 1
			addi s3,  s3, 1
		.Pixel1LeftP:	
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel11LeftP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2LeftP
			.Pixel11LeftP:	
			bne   a7, a2, .Pixel12LeftP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2LeftP
			.Pixel12LeftP:	
			bne   a7, a6, .Pixel2LeftP
			li s2, 2
			addi s3,  s3, 1
		.Pixel2LeftP:
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel21LeftP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3LeftP
			.Pixel21LeftP:	
			bne   a7, a2, .Pixel22LeftP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3LeftP
			.Pixel22LeftP:	
			bne   a7, a6, .Pixel3LeftP
			li s2, 3
			addi s3,  s3, 1
		.Pixel3LeftP:
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel31LeftP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4LeftP
			.Pixel31LeftP:	
			bne   a7, a2, .Pixel32LeftP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4LeftP
			.Pixel32LeftP:	
			bne   a7, a6, .Pixel4LeftP
			li s2, 4
			addi s3,  s3, 1
			
		.Pixel4LeftP:
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel41LeftP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar2
			.Pixel41LeftP:	
			bne   a7, a2, .Pixel42LeftP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar2
			.Pixel42LeftP:	
			bne   a7, a6, .Posicionar2
			li s2, 5
			addi s3,  s3, 1

		.Posicionar2:			

			li t0, 5
			beq t0, s3, .mover3_no
			beq zero, s3, .mover3_no
				li t0, 1
				bne t0, s2, .mover3_der2
					addi s1, s1, 1
					j .ColDoneP
				.mover3_der2:
				li t0, 2
				bne t0, s2, .mover3_der3
					addi s1, s1,  2
					j .ColDoneP
				.mover3_der3:
				li t0, 3
				bne t0, s2, .mover3_izq1
					addi s1, s1,  3
					j .ColDoneP
				.mover3_izq1:
				li t0, 4
				bne t0, s2, .mover3_der_1
					addi s1, s1, -1
					j .ColDoneP
				.mover3_der_1:
				li t0, 5
				li t1, 4
				bne t0, s2, .mover3_der_2
				bne s3, t1, .mover3_der_2
					addi s1, s1, 1
					j .ColDoneP
				.mover3_der_2:
				li t0, 5
				li t1, 3
				bne t0, s2, .mover3_izq_2
				bne s3, t1, .mover3_izq_2
					addi s1, s1, 2
					j .ColDoneP
				.mover3_izq_2:
				li t0, 5
				li t1, 2
				bne t0, s2, .mover3_izq_1
				bne s3, t1, .mover3_izq_1
					addi s1, s1, -2
					j .ColDoneP
				.mover3_izq_1:
				li t0, 5
				li t1, 1
				bne t0, s2, .mover3_no
				bne s3, t1, .mover3_no
					addi s1, s1, -1
					j .ColDoneP
				
				.mover3_no:	
					li s2, 0
					li s3, 0	

	.ColRightP:
		mv a0, s0
		mv a1, s1
		#ajusta la cordenada para subir
		addi  a0,  a0, 5
		.Pixel0RightP:
			jal LoadColor
			bne a7, a5, .Pixel01RightP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1RightP
			.Pixel01RightP:	
			bne   a7, a2, .Pixel02RightP
			li s2, 1
			addi s3,  s3, 1
			j .Pixel1RightP
			.Pixel02RightP:	
			bne   a7, a6, .Pixel1RightP
			li s2, 1
			addi s3,  s3, 1
		.Pixel1RightP:	
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel11RightP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2RightP
			.Pixel11RightP:	
			bne   a7, a2, .Pixel12RightP
			li s2, 2
			addi s3,  s3, 1
			j .Pixel2RightP
			.Pixel12RightP:	
			bne   a7, a6, .Pixel2RightP
			li s2, 2
			addi s3,  s3, 1
		.Pixel2RightP:
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel21RightP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3RightP
			.Pixel21RightP:	
			bne   a7, a2, .Pixel22RightP
			li s2, 3
			addi s3,  s3, 1
			j .Pixel3RightP
			.Pixel22RightP:	
			bne   a7, a6, .Pixel3RightP
			li s2, 3
			addi s3,  s3, 1
		.Pixel3RightP:
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel31RightP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4RightP
			.Pixel31RightP:	
			bne   a7, a2, .Pixel32RightP
			li s2, 4
			addi s3,  s3, 1
			j .Pixel4RightP
			.Pixel32RightP:	
			bne   a7, a6, .Pixel4RightP
			li s2, 4
			addi s3,  s3, 1
			
		.Pixel4RightP:
			addi  a1,  a1, 1
			jal LoadColor
			bne a7, a5, .Pixel41RightP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar3
			.Pixel41RightP:	
			bne   a7, a2, .Pixel42RightP
			li s2, 5
			addi s3,  s3, 1
			j .Posicionar3
			.Pixel42RightP:	
			bne   a7, a6, .Posicionar3
			li s2, 5
			addi s3,  s3, 1

		.Posicionar3:			

			li t0, 5
			beq t0, s3, .mover4_no
			beq zero, s3, .mover4_no
				li t0, 1
				bne t0, s2, .mover4_der2
					addi s1, s1, 1
					j .ColDoneP
				.mover4_der2:
				li t0, 2
				bne t0, s2, .mover4_der3
					addi s1, s1,  2
					j .ColDoneP
				.mover4_der3:
				li t0, 3
				bne t0, s2, .mover4_izq1
					addi s1, s1,  3
					j .ColDoneP
				.mover4_izq1:
				li t0, 4
				bne t0, s2, .mover4_der_1
					addi s1, s1, -1
					j .ColDoneP
				.mover4_der_1:
				li t0, 5
				li t1, 4
				bne t0, s2, .mover4_der_2
				bne s3, t1, .mover4_der_2
					addi s1, s1, 1
					j .ColDoneP
				.mover4_der_2:
				li t0, 5
				li t1, 3
				bne t0, s2, .mover4_izq_2
				bne s3, t1, .mover4_izq_2
					addi s1, s1, 2
					j .ColDoneP
				.mover4_izq_2:
				li t0, 5
				li t1, 2
				bne t0, s2, .mover4_izq_1
				bne s3, t1, .mover4_izq_1
					addi s1, s1, -2
					j .ColDoneP
				.mover4_izq_1:
				li t0, 5
				li t1, 1
				bne t0, s2, .mover4_no
				bne s3, t1, .mover4_no
					addi s1, s1, -1
					j .ColDoneP
				
				.mover4_no:	
					li s2, 0
					li s3, 0	
	.ColDoneP:
		mv a0, s0
		mv a1, s1

	lw s3, 20(sp)
	lw a6, 16(sp)
	lw a5, 12(sp)
	lw s2, 8(sp)
	lw  ra, 0( sp)
	lw a2, 4(sp)
	addi  sp,  sp, 24
	jr  ra


CollisionDirectionBomba:
	addi  sp,  sp, -40
	sw ra, 0(sp)
	sw a2, 4(sp)
	sw a0, 8(sp)
	sw a1, 12(sp)
	sw a6, 24(sp)
	sw s5, 16(sp)
	sw s6, 20(sp)
	sw s0, 28(sp)
	sw s1, 32(sp)
	sw a3, 36(sp)

	mv a0, s0
	mv a1, s1 

	lw a2, color_verde
	lw a6, color_gris4
	
	.ColUpB:
		mv a0, s0
		mv a1, s1
		li s5, 6
		#ajusta la cordenada para colision superior 
			lw t0, power_up_llama
			li t1, 1
			bne t0, t1, .LoopUpB
			li s5, 11
		.LoopUpB:
			li a4, 1
			li a3, 0
			.Pixel0UpB:
				jal LoadColor
				beq   a7, a2, .Pixel1UpB
				beq   a7, a6, .ColUPBDone
				jal CollisionBombaColor
				li t0, 1
				beq t0, a3, .Pixel1UpB
				j .ColUPBDone
			.Pixel1UpB:	
				addi  a0,  a0, 1
				jal LoadColor
				beq   a7, a2,.Pixel2UpB
				jal CollisionBombaColor
				li t0, 1
				beq t0, a3, .Pixel2UpB
				j .ColUPBDone
			.Pixel2UpB:
				addi  a0,  a0, 1
				jal LoadColor
				beq   a7, a2,.Pixel3UpB
				jal CollisionBombaColor
				li t0, 1
				beq t0, a3, .Pixel3UpB
				j .ColUPBDone
			.Pixel3UpB:
				addi  a0,  a0, 1
				jal LoadColor
				beq   a7, a2,.Pixel4UpB
				jal CollisionBombaColor
				li t0, 1
				beq t0, a3, .Pixel4UpB
				j .ColUPBDone
			.Pixel4UpB:
				addi  a0,  a0, 1
				jal LoadColor
				beq   a7, a2,.NoColUpB
				jal CollisionBombaColor
				li t0, 1
				beq t0, a3, .NoColUpB
				j .ColUPBDone
		
		.NoColUpB:	
		mv a0, s0
		addi a1, a1, -1
		addi s5, s5, -1
		bne zero, s5, .LoopUpB	

		.ColUPBDone:			
		
	.ColDownB:
		mv a0, s0
		mv a1, s1
		li s5, 6
		
		#ajusta la cordenada para subir
		 addi  a1,  a1, 4
			lw t0, power_up_llama
			li t1, 1
			bne t0, t1, .LoopDownB
			li s5, 11
		.LoopDownB:
		li a3, 0
		li a4, 2
		.Pixel0DownB:
			jal LoadColor
			beq   a7, a6, .ColDownBDone
			beq   a7, a2, .Pixel1DownB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel1DownB
			j .ColDownBDone
		
		.Pixel1DownB:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel2DownB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel2DownB
			j .ColDownBDone
		.Pixel2DownB:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel3DownB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel3DownB
			j .ColDownBDone
		.Pixel3DownB:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel4DownB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel4DownB
			j .ColDownBDone
		.Pixel4DownB:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.NoColDownB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .NoColDownB
			j .ColDownBDone	
  
		.NoColDownB:	
		mv a0, s0
		addi a1, a1,  1
		addi s5, s5, -1
		bne zero, s5, .LoopDownB	

		.ColDownBDone:


	.ColLeftB:
		mv a0, s0
		mv a1, s1
		li s5, 6 
			lw t0, power_up_llama
			li t1, 1
			bne t0, t1, .LoopLeftB
			li s5, 11
		.LoopLeftB:
		li a4, 3
		li a3, 0
		.Pixel0LeftB:
			jal LoadColor
			beq   a7, a6, .ColLeftBDone
			beq   a7, a2,.Pixel1LeftB
			jal CollisionBombaColor 
			li t0, 1
			beq t0, a3, .Pixel1LeftB
			j .ColLeftBDone

		.Pixel1LeftB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel2LeftB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel2LeftB
			j .ColLeftBDone
		.Pixel2LeftB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel3LeftB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel3LeftB
			j .ColLeftBDone
		.Pixel3LeftB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel4LeftB
			jal CollisionBombaColor 
			li t0, 1
			beq t0, a3, .Pixel4LeftB
			j .ColLeftBDone
		.Pixel4LeftB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.NoColLeftB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .NoColLeftB
			j .ColLeftBDone
		
		.NoColLeftB:
		mv a1, s1
		addi a0, a0, -1
		addi s5, s5, -1
		bne zero, s5, .LoopLeftB			
		.ColLeftBDone:
			
	.ColRightB:
		mv a0, s0
		mv a1, s1
		li s5, 6
		addi  a0,  a0, 4
			lw t0, power_up_llama
			li t1, 1
			bne t0, t1, .LoopRightB
			li s5, 11
		.LoopRightB:
		li a4, 4
		li a3, 0
		.Pixel0RightB:
			jal LoadColor
			beq   a7, a6, .ColRightBDone #Incluir en las demas, invertir loop y agregar color gris de parda
			beq   a7, a2,.Pixel1RightB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel1RightB
			j .ColRightBDone

		.Pixel1RightB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel2RightB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel2RightB
			j .ColRightBDone
		.Pixel2RightB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel3RightB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel3RightB
			j .ColRightBDone
		.Pixel3RightB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel4RightB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .Pixel4RightB
			j .ColRightBDone
		.Pixel4RightB:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.NoColRightB
			jal CollisionBombaColor
			li t0, 1
			beq t0, a3, .NoColRightB
			j .ColRightBDone
		
		.NoColRightB:
		mv a1, s1
		addi a0, a0, 1
		addi s5, s5, -1
		bne zero, s5, .LoopRightB	
		.ColRightBDone:
		li a4, 0

	lw a3, 36(sp)
	lw s0, 28(sp)
	lw s1, 32(sp)
	lw a6, 24(sp)
	lw s6, 20(sp)
	lw s5, 16(sp)
	lw a1, 12(sp)
	lw a0, 8(sp)	
	lw ra, 0(sp)
	lw a2, 4(sp)
	addi  sp,  sp, 40
	jr  ra


CollisionDirectionEnemy:
	
	addi  sp,  sp, -16
	sw ra, 0(sp)
	sw a2, 4(sp)
	sw a0, 8(sp)
	sw a1, 12(sp)

	lw a2, color_verde
	mv a0, s0
	mv a1, s1

	.ColUpE:
		li t6, MOV_UP
		bne  s9, t6, .ColDownE
		#ajusta la cordenada para subir
		addi  a1,  a1, -1
		.Pixel0UpE:
			jal LoadColor
			beq   a7, a2, .Pixel1UpE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel1UpE:	
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel2UpE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel2UpE:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel3UpE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel3UpE:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel4UpE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel4UpE:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.NoColUpE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.NoColUpE:
			li   a7, 0
			j .ColDoneE				
							
		
	.ColDownE:
		li t6, MOV_DOWN
		bne  s9, t6, .ColLeftE
		#ajusta la cordenada para subir
		addi  a1,  a1, 5
		.Pixel0DownE:
			jal LoadColor
			beq   a7, a2, .Pixel1DownE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel1DownE:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel2DownE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel2DownE:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel3DownE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel3DownE:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.Pixel4DownE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel4DownE:
			addi  a0,  a0, 1
			jal LoadColor
			beq   a7, a2,.NoColDownE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.NoColDownE:
			li   a7, 0
			j .ColDoneE			
	.ColLeftE:
		li t6, MOV_LEFT
		bne  s9, t6, .ColRightE
		addi  a0,  a0, -1
		.Pixel0LeftE:
			jal LoadColor
			beq   a7, a2,.Pixel1LeftE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel1LeftE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel2LeftE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel2LeftE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel3LeftE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel3LeftE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel4LeftE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel4LeftE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.NoColLeftE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.NoColLeftE:
			li   a7, 0
			j .ColDoneE			
			
	.ColRightE:
		li t6, MOV_RIGHT
		bne  s9, t6, .ColDoneE
		addi  a0,  a0, 5
		.Pixel0RightE:
			jal LoadColor
			beq   a7, a2,.Pixel1RightE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel1RightE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel2RightE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel2RightE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel3RightE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel3RightE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.Pixel4RightE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.Pixel4RightE:
			addi  a1,  a1, 1
			jal LoadColor
			beq   a7, a2,.NoColRightE
			jal CollisionColorEnemy
			li a7, 1
			j .ColDoneE
		.NoColRightE:
			li   a7, 0
			j .ColDoneE		
	.ColDoneE:

	lw ra, 0(sp)
	lw a2, 4(sp)
	lw a0, 8(sp)
	lw a1, 12(sp)
	addi  sp,  sp, 16
	jr  ra


draw_paddle:
	addi sp, sp -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	

	mv s0, s4
	mv s1, s5

	 
	jal Colision_jugador_enemigo

	mv s0, s4
	mv s1, s5

	beq a7, zero, .Continue
	j .no_mov

	.Continue:
	li t0, MOV_UP
	beq t0, s10, .up
	li t0, MOV_DOWN
	beq t0, s10, .down
	li t0, MOV_LEFT
	beq t0, s10, .left
	li t0, MOV_RIGHT
	beq t0, s10, .right
	j .no_mov

	.up: 
		#Verificar gate
		mv a0, s0
		mv a1, s1
		lw t0, player_kills
		li t1, 6
		bne t0, t1, .continued
		addi a0, a0, 2
		addi a1, a1, 3
		jal LoadColor
		lw t0, color_azul
		bne a7, t0, .continued
		lw s3, level
		li t1, 3
		bne s3, t1, .next_level1
		j winner
		.next_level1:
		addi, s3, s3, 1
		sw s3, level, t1
		j new_round
		
		.continued:
		#erase player
		jal erase_player
		
		li t0, TOP_PADDLE_Y_ROW
		beq s1, t0, .no_mov 
		addi  s1, s1, -1
		j .move

	.down:
		#Verificar gate
		mv a0, s0
		mv a1, s1
		lw t0, player_kills
		li t1, 6
		bne t0, t1, .continued1
		addi a0, a0, 4
		addi a1, a1, 1
		jal LoadColor
		lw t0, color_azul
		bne a7, t0, .continued1
		lw s3, level
		li t1, 3
		bne s3, t1, .next_level2
		j winner
		.next_level2:
		addi, s3, s3, 1
		sw s3, level, t1
		j new_round

		.continued1:
		#erase player
		jal erase_player
		
		li t0, BOTTOM_PADDLE_Y_ROW
		beq s1, t0, .no_mov 
		addi  s1, s1, 1
		j .move
	
	.left:

		#Verificar gate
		mv a0, s0
		mv a1, s1
		lw t0, player_kills
		li t1, 6
		bne t0, t1, .continued3
		addi a0, a0, 3
		jal LoadColor
		lw t0, color_azul
		bne a7, t0, .continued3
		lw s3, level
		li t1, 3
		bne s3, t1, .next_level3
		j winner
		.next_level3:
		addi, s3, s3, 1
		sw s3, level, t1
		j new_round

		.continued3:
		#erase player
		jal erase_player
	
		addi s0, s0, -1
		j .move
	
	.right:
		#Verificar gate
		mv a0, s0
		mv a1, s1
		lw t0, player_kills
		li t1, 6
		bne t0, t1, .continued4
		addi a1, a1, 3
		jal LoadColor
		lw t0, color_azul
		bne a7, t0, .continued4
		lw s3, level
		li t1, 3
		bne s3, t1, .next_level4
		j winner
		.next_level4:
		addi, s3, s3, 1
		sw s3, level, t1
		j new_round

		.continued4:
		#erase player
		mv a0, s0
		addi a0, a0,  4
		li t0, 63
		bge a0, t0, .no_mov
		jal erase_player
		
		addi  s0, s0, 1
		j .move

	.no_mov:
		
		li s10, MOV_STAY
	
	.move:
		#P2
			#derecha
				#fila0
					mv a0, s0
					mv a1, s1
					li t0, 3
					add a3, a0, t0
					lw a2, color_rojo2
					jal draw_horizontal_line

				#fila1
					mv a0, s0
					addi a1, a1, 1
					addi a0, a0, 1
					li t0, 2
					add a3, a0, t0
					lw a2, color_piel
					jal draw_horizontal_line

					mv a0, s0
					lw a2, color_rojo2
					jal draw_point

				#fila2
					addi a1, a1, 1
					mv a0, s0
					li t0, 3
					add a3, a0, t0
					lw a2, color_rojo
					jal draw_horizontal_line

					
					addi a0, a0, 4
					lw a2, color_rojo2
					jal draw_point
				#fila3
					addi a1, a1, 1
					mv a0, s0
					li t0, 2
					addi a0, a0, 1
					add a3, a0, t0
					lw a2, color_rojo2
					jal draw_horizontal_line

				#fila4
					addi a1, a1, 1
					mv a0, s0
					li t0, 1
					add a3, a0, t0
					lw a2, color_rojo2
					jal draw_horizontal_line

					mv a0, s0
					li t0, 1
					addi a0, a0, 3
					add a3, a0, t0
					lw a2, color_rojo2
					jal draw_horizontal_line


	# The return values of the new y-top position
	mv s4, s0
	mv s5, s1
	li s10, MOV_STAY

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp 20
	jr ra

draw_enemy:
	addi sp, sp -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw a7, 20(sp)

	lw t0, enemy_speed1
	addi, t0, t0, -1
	sw t0, enemy_speed1, t1 

	lw t0, enemy_speed2
	addi, t0, t0, -1
	sw t0, enemy_speed2, t1 

	lw t0, enemy_speed3
	addi, t0, t0, -1
	sw t0, enemy_speed3, t1

	li t0, 1
	li t1, 2
	li t2, 3
	lw t3, level
	blt t3, t1, .draw1
	blt t3, t2, .draw2

		lw t0, enemy_speed3
		bne zero, t0, .draw2
	#Dibujar y mover enemigo4
		lw t0, enemigo4_muerte
		bne zero, t0, .en3
		lw s0, enemigo4x
		lw s1, enemigo4y
		lw s9, enemigo4_dir	
		jal move_enemy
		sw s0, enemigo4x, t1
		sw s1, enemigo4y, t1
		sw s9, enemigo4_dir, t1

		jal draw_bloque_enemy4
	.en3:
	#Dibujar y mover enemigo3
		lw t0, enemigo3_muerte
		bne zero, t0, .draw2
		lw s0, enemigo3x
		lw s1, enemigo3y
		lw s9, enemigo3_dir	
		jal move_enemy
		sw s0, enemigo3x, t1
		sw s1, enemigo3y, t1
		sw s9, enemigo3_dir, t1
		jal draw_bloque_enemy3

		li t0, 4
		sw t0, enemy_speed3, t1
	
	.draw2:
		lw t0, enemy_speed2
		bne zero, t0, .draw1
	#Dibujar y mover enemigo2
		lw t0, enemigo2_muerte
		bne zero, t0, .draw1
		lw s0, enemigo2x
		lw s1, enemigo2y
		lw s9, enemigo2_dir	
		jal move_enemy
		sw s0, enemigo2x, t1
		sw s1, enemigo2y, t1
		sw s9, enemigo2_dir, t1
		jal draw_bloque_enemy2

		li t0, 6
		sw t0, enemy_speed2, t1

	.draw1:

		lw t0, enemy_speed1
		bne zero, t0, .draw_enemy_done
	#Dibujar y mover enemigo1
		lw t0, enemigo1_muerte
		bne zero, t0, .en12
			lw s0, enemigo1x
			lw s1, enemigo1y
			lw s9, enemigo1_dir	
			jal move_enemy
			sw s0, enemigo1x, t1
			sw s1, enemigo1y, t1
			sw s9, enemigo1_dir, t1
			jal draw_bloque_enemy1
		.en12:
		lw t0, enemigo12_muerte
		bne zero, t0, .en13
			lw s0, enemigo12x
			lw s1, enemigo12y
			lw s9, enemigo12_dir	
			jal move_enemy
			sw s0, enemigo12x, t1
			sw s1, enemigo12y, t1
			sw s9, enemigo12_dir, t1
			jal draw_bloque_enemy12
		.en13:
		lw t0, enemigo13_muerte
		bne zero, t0, .no_en1
			lw s0, enemigo13x
			lw s1, enemigo13y
			lw s9, enemigo13_dir	
			jal move_enemy
			sw s0, enemigo13x, t1
			sw s1, enemigo13y, t1
			sw s9, enemigo13_dir, t1
			jal draw_bloque_enemy13
		.no_en1:
		li t0, 10
		sw t0, enemy_speed1, t1

	.draw_enemy_done:
	lw t0, enemy_speed3
	bne zero, t0, .reiniciar_speed2
	li t0, 4
	sw t0, enemy_speed3, t1
	.reiniciar_speed2:
	lw t0, enemy_speed2
	bne zero, t0, .draw_enemy_done1
	li t0, 4
	sw t0, enemy_speed2, t1

	.draw_enemy_done1:
		

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw a7, 20(sp)
	addi sp, sp 24
	jr ra

move_enemy:
	addi sp, sp -16
	sw ra, 0(sp)
	sw s2, 4(sp)
	sw s3, 8(sp)
	sw a7, 12(sp)

	mv a0, s0
	mv a1, s1

	jal CollisionDirectionEnemy
	jal Colision_enemigo_jugador
	beq a7, zero, .ContinueE
		jal adjust_dir_enemy
		j .no_movE

	.ContinueE:
	li t0, MOV_UP
	beq t0, s9, .upE
	li t0, MOV_DOWN
	beq t0, s9, .downE
	li t0, MOV_LEFT
	beq t0, s9, .leftE
	li t0, MOV_RIGHT
	beq t0, s9, .rightE
	j .no_movE

	.upE: 
		mv a0, s0
		mv a1, s1
		jal erase_bloque
		
		li t0, TOP_PADDLE_Y_ROW
		beq s1, t0, .no_movE
		addi s1, s1, -1
		j .moveE

	.downE:
		mv a0, s0
		mv a1, s1
		jal erase_bloque
		
		li t0, BOTTOM_PADDLE_Y_ROW
		beq s1, t0, .no_movE
		addi s1, s1, 1
		j .moveE
	
	.leftE:
		mv a0, s0
		mv a1, s1
		jal erase_bloque
	
		addi s0, s0, -1
		j .moveE
	
	.rightE:
		mv a0, s0
		mv a1, s1
		#erase player
		addi a0, a0,  4
		li t0, 63
		bge a0, t0, .no_movE
			mv a0, s0
			mv a1, s1
			jal erase_bloque
		
		addi s0, s0, 1
		j .moveE

	.no_movE:
	
	.moveE:

	# The return values of the new y-top position
	

	lw ra, 0(sp)
	lw s2, 4(sp)
	lw s3, 8(sp)
	lw a7, 12(sp)
	addi sp, sp 16
	jr ra

draw_gate:
	addi sp, sp, -4
	sw ra, 0(sp)

	#Bloque gate
		li a0, BLOQUE_1_x
		li a1, BLOQUE_1_y
		addi a0, a0, -5
		addi a1, a1, 5

		#Desactivo
		lw t0, gate
		li t1, 1
		beq t0, t1, .activo
		jal draw_bloqueGate2
		j .continuar
		#Activo
			.activo:
			jal draw_bloqueGate

		.continuar:

	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

draw_bomba:

	
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	
	#bomba nueva
		li t0, SET_BOMB
		bne t0, s11, .set_bomb_done

			lw t0, bomba1_state
			bne zero, t0, .bomba2
			sw s4, bomba1x, t1
			sw s5, bomba1y, t1
			lw s0, bomba1x
			lw s1, bomba1y
			jal PosicionarBomba
			sw a0, bomba1x, t1
			sw a1, bomba1y, t1
			lw s0, bomba1x
			lw s1, bomba1y
			li t0, NOBOOM_BOMB
			sw t0, bomba1_state, t1
			li t0, 200
			sw t0, bomba1_timer, t1
			jal draw_bloque_bomba

			j .draw 

		.bomba2:
			lw t0, power_up_bomba 
			beq zero, t0, .set_bomb_done 

			lw t0, bomba2_state
			bne zero, t0, .bomba3
			sw s4, bomba2x, t1
			sw s5, bomba2y, t1
			lw s0, bomba2x
			lw s1, bomba2y
			jal PosicionarBomba
			sw a0, bomba2x, t1
			sw a1, bomba2y, t1
			lw s0, bomba2x
			lw s1, bomba2y
			li t0, NOBOOM_BOMB
			sw t0, bomba2_state, t1
			li t0, 200
			sw t0, bomba2_timer, t1
			jal draw_bloque_bomba1

			j .draw 

		.bomba3: 
			lw t0, power_up_bomba 
			li t1, 2
			bne t0, t1, .set_bomb_done
 
			lw t0, bomba3_state
			bne zero, t0, .set_bomb_done
			sw s4, bomba3x, t1
			sw s5, bomba3y, t1
			lw s0, bomba3x
			lw s1, bomba3y
			jal PosicionarBomba
			sw a0, bomba3x, t1
			sw a1, bomba3y, t1
			lw s0, bomba3x
			lw s1, bomba3y
			li t0, NOBOOM_BOMB
			sw t0, bomba3_state, t1
			li t0, 200
			sw t0, bomba3_timer, t1
			jal draw_bloque_bomba2

			

		.draw:

		.set_bomb_done:
			li s11, MOV_STAY

	#Bombas existentes
		# Bomba 1
			lw t0, bomba1_state
			beq zero, t0, .bombaE2		#Ver el estado de la bomba
			lw s0, bomba1x
			lw s1, bomba1y 
			lw t1, bomba1_timer
			bne zero, t1, .timing		#Ver el temporizador de la bomba
			jal erase_bomba
			jal Colision_bomba_muros	#Verificar colision de explosion con elementos
			jal Colision_jugador_bomba
			li t0, NO_BOMB
			sw t0, bomba1_state, t1
			j .bombaE2
			.timing:
			lw t1, bomba1_timer
			addi t1, t1, -1
			sw t1, bomba1_timer, t3
			jal draw_bloque_bomba

		# Bomba 2
			.bombaE2:
				
				lw t0, bomba2_state 
				beq zero, t0, .bombaE3		#Ver el estado de la bomba
				lw s0, bomba2x
				lw s1, bomba2y 
				lw t1, bomba2_timer
				bne zero, t1, .timing2		#Ver el temporizador de la bomba
				jal erase_bomba
				jal Colision_bomba_muros	#Verificar colision de explosion con elementos
				jal Colision_jugador_bomba
				li t0, NO_BOMB
				sw t0, bomba2_state, t1
				j .bombaE3
				.timing2:
				lw t1, bomba2_timer
				addi t1, t1, -1
				sw t1, bomba2_timer, t3
				jal draw_bloque_bomba1

		# Bomba 3
			.bombaE3:
				lw t0, bomba3_state 
				beq zero, t0, .bomb_done		#Ver el estado de la bomba
				lw s0, bomba3x
				lw s1, bomba3y 
				lw t1, bomba3_timer
				bne zero, t1, .timing3		#Ver el temporizador de la bomba
				jal erase_bomba 
				jal Colision_bomba_muros	#Verificar colision de explosion con elementos
				jal Colision_jugador_bomba
				li t0, NO_BOMB
				sw t0, bomba3_state, t1
				j .bomb_done
				.timing3:
				lw t1, bomba3_timer
				addi t1, t1, -1
				sw t1, bomba3_timer, t3
				jal draw_bloque_bomba2

			
			.bomb_done:

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 12
	jr ra

draw_vidas:
	
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)


	lw t0, player_lives
	li t1, 1
	beq t0, t1, .una_vida
	lw t0, player_lives
	li t1, 2
	beq t0, t1, .dos_vidas
		li a0, VIDA_1_x
		li a1, VIDA_1_y
		lw a2, color_rojo1
		jal draw_point

		addi, a0, a0, 1
		addi, a1, a1, 1
		lw a2, color_rojo1
		jal draw_point

		li a0, VIDA_1_x
		li a1, VIDA_1_y
		addi, a0, a0, 2
		lw a2, color_rojo1
		jal draw_point

	.dos_vidas:
		li a0, VIDA_1_x
		li a1, VIDA_1_y
		addi a1, a1, 3
		lw a2, color_rojo1
		jal draw_point

		li a0, VIDA_1_x
		addi, a0, a0, 1
		li a1, VIDA_1_y
		addi, a1, a1, 4
		lw a2, color_rojo1
		jal draw_point

		li a0, VIDA_1_x
		addi, a0, a0, 2
		li a1, VIDA_1_y
		addi a1, a1, 3
		lw a2, color_rojo1
		jal draw_point
	.una_vida:
		li a0, VIDA_1_x
		li a1, VIDA_1_y
		addi a1, a1, 6
		lw a2, color_rojo1
		jal draw_point

		li a0, VIDA_1_x
		addi, a0, a0, 1
		li a1, VIDA_1_y
		addi, a1, a1, 7
		lw a2, color_rojo1
		jal draw_point

		li a0, VIDA_1_x
		addi, a0, a0, 2
		li a1, VIDA_1_y
		addi a1, a1, 6
		lw a2, color_rojo1
		jal draw_point

		li a0, 1
		li a1, 22
		addi a3, a0, 6
		lw a2, color_grisO
		jal draw_horizontal_line

		li a0, 1
		li a1, 39
		addi a3, a0, 6
		lw a2, color_grisO
		jal draw_horizontal_line

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 12
	jr ra


draw_puntos:
	
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)

	#Pts
		li a0, PUNTOS_1_x
		li a1, PUNTOS_y
		lw a2, color_gris22
		addi a3, a1, 4
		jal draw_vertical_line

		li a0, PUNTOS_1_x
		addi a0, a0, 1
		li a1, PUNTOS_y
		lw a2, color_gris22
		jal draw_point
		 
		addi a0, a0, 1
		li a1, PUNTOS_y
		lw a2, color_gris22
		jal draw_point

		li a0, PUNTOS_1_x
		addi a0, a0, 1
		li a1, PUNTOS_y
		addi a1, a1, 2
		lw a2, color_gris22
		jal draw_point

		li a0, PUNTOS_1_x
		addi a0, a0, 2
		li a1, PUNTOS_y
		addi a1, a1, 1
		lw a2, color_gris22 
		jal draw_point
 
		addi a1, a1, 1
		lw a2, color_gris22
		jal draw_point
		
	

	#Puntos
		#Escalar puntor para mapa1
				li t0, 1
				lw t1, level
			bne t0, t1, .pass
				li t0, 1
				lw t1, player_kills
			beq t0, t1, .pass1
				li t0, 3
				lw t1, player_kills
			beq t0, t1, .pass1
				li t0, 5
				lw t1, player_kills
			beq t0, t1, .pass1
				j .pass
			.pass1:
			lw t0, player_kills
			addi t0, t0, 1
			sw t0, player_kills, t1
	.pass:
	# Escalar puntos para mapa2
		li t0, 2
		lw t1, level
		bne t0, t1, .pass2
		lw t0, player_kills
		li t1, 1
		bne t0, t1,, .pass2
		lw t0, player_kills
		addi t0, t0, 2
		sw t0, player_kills, t1
	.pass2:
	#numero de kills
		lw a2, color_gris22
		lw t0, player_kills
		li t1, 1
		beq t0, t1, .un_punto
		lw t0, player_kills
		li t1, 2
		beq t0, t1, .dos_puntos
		lw t0, player_kills
		li t1, 3
		beq t0, t1, .tres_puntos
		lw t0, player_kills
		li t1, 4
		beq t0, t1, .cuatro_puntos
		lw t0, player_kills
		li t1, 5
		beq t0, t1, .cinco_puntos
		lw t0, player_kills
		li t1, 6
		beq t0, t1, .seis_puntos
		j .cero_puntos
	#Dijar barra
		.seis_puntos:
			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1, -3
			jal draw_point

			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1, -2
			jal draw_point

		.cinco_puntos:
			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1,  -1 
			jal draw_point

			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6 
			jal draw_point

		.cuatro_puntos:
			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1,  1 
			jal draw_point

			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6 
			addi, a1, a1, 2 
			jal draw_point

		.tres_puntos:
			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1,  3 
			jal draw_point

			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6 
			addi, a1, a1,  4 
			jal draw_point

		.dos_puntos:
			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1,  5 
			jal draw_point

			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6 
			addi, a1, a1, 6
			jal draw_point

		.un_punto:
			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1, 7
			jal draw_point
			
			li a0, PUNTOS_1_x
			li a1, PUNTOS_y
			addi, a0, a0, 6
			addi, a1, a1, 8 
			jal draw_point

		.cero_puntos:

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 12
	jr ra

draw_map1:
	addi sp, sp, -4
	sw ra, 0(sp)

	# Lv1
		li a0, Lv_x
		li a1, Lv_y
		lw a2, color_gris22
		addi a3, a1, 4
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y
		addi a1, a1, 4  
		addi a3, a0, 2
		jal draw_horizontal_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 2
		addi a0, a0, 4 
		addi a3, a1, 1
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 2
		addi a0, a0, 6 
		addi a3, a1, 1
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 4
		addi a0, a0, 5 
		jal draw_point
	#1
		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 10
		addi a0, a0, 2 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 7 
		addi a0, a0, 2 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 6
		addi a0, a0, 3 
		addi a3, a1, 4
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 10
		addi a0, a0, 4 
		jal draw_point

	#Bloques rompibles
		li a0, BLOQUE_1_x
		li a1, BLOQUE_1_y
	

		#Columna2
			li a1, BLOQUE_1_y
			addi a1, a1, -5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
			
		#Columna3
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		#Columna4
			li a1, BLOQUE_1_y
			addi a0, a0, 5
		#Columna5
			li a1, BLOQUE_1_y
			addi a0, a0, 5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -1
			jal draw_bloque2	

		#Columna6
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2

			addi a1, a1, PASILLO	
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -8
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2		

		#Columna7
			li a1, BLOQUE_1_y
			addi a1, a1, -5
			addi a0, a0, 5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
			
		#Columna8
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		
			addi a0, a0, -5

			
			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, -1
			addi a1, a1, PASILLO
			jal draw_bloque2
			addi a1, a1, 1
			jal draw_bloque2	

		#Columna9
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		#Columna10
			li a1, BLOQUE_1_y
			addi a1, a1, -5
			addi a0, a0, 5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2
		#Columna11
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	

		#Columna12
			li a1, BLOQUE_1_y
			addi a0, a0, 5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -1
			jal draw_bloque2	

	#Bloques fijos
		li a0, BLOQUE_1_x
		li a1, BLOQUE_1_y

		#Columna1
			lw a2, color_naranja
			jal draw_bloque	

			addi a1, a1, PASILLO
			lw a2, color_naranja
			jal draw_bloque	

			addi a1, a1, PASILLO
			lw a2, color_naranja
			jal draw_bloque	

			addi a1, a1, PASILLO
			lw a2, color_naranja
			jal draw_bloque	

			addi a1, a1, PASILLO
			lw a2, color_naranja
			jal draw_bloque	

		#Columna2
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	
			
		#Columna3
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

		#Columna4
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

		#Columna5

	
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque	

			addi a1, a1, PASILLO
			jal draw_bloque		

	

	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra


draw_map2:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	# Lv2
		li a0, Lv_x
		li a1, Lv_y
		lw a2, color_gris22
		addi a3, a1, 4
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y
		addi a1, a1, 4  
		addi a3, a0, 2
		jal draw_horizontal_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 2
		addi a0, a0, 4 
		addi a3, a1, 1
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 2
		addi a0, a0, 6 
		addi a3, a1, 1
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 4
		addi a0, a0, 5 
		jal draw_point
	#1
		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 10
		addi a0, a0, 2 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 7 
		addi a0, a0, 2 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 6
		addi a0, a0, 3 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 7
		addi a0, a0, 4
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 8
		addi a0, a0, 4
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 9
		addi a0, a0, 3
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 10
		addi a0, a0, 3
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 10
		addi a0, a0, 4 
		jal draw_point
	#Bloques rompibles
		li a0, BLOQUE_1_x
		li a1, BLOQUE_1_y

		#Columna1
			

		#Columna2
			li a1, BLOQUE_1_y
			addi a1, a1, -5 

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
			
		#Columna3
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		#Columna4
			li a1, BLOQUE_1_y
			addi a0, a0, 5
		#Columna5
			li a1, BLOQUE_1_y
			addi a0, a0, 5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -1
			jal draw_bloque2	

		#Columna6
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2

			addi a1, a1, PASILLO	
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -8
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2		

		#Columna7
			li a1, BLOQUE_1_y
			addi a1, a1, -5
			addi a0, a0, 5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
			
		#Columna8
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		
			addi a0, a0, -5

			
			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, -1
			addi a1, a1, PASILLO
			jal draw_bloque2
			addi a1, a1, 1
			jal draw_bloque2	

		#Columna9
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		#Columna10
			li a1, BLOQUE_1_y
			addi a1, a1, -5
			addi a0, a0, 5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2
		#Columna11
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	

		#Columna12
			li a1, BLOQUE_1_y
			addi a0, a0, 5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -1
			jal draw_bloque2	

	#Bloques fijos
		li a0, BLOQUE_1_x
		li a1, BLOQUE_1_y

		#Columna1
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2

			addi a1, a1, PASILLO
			jal draw_bloquemap2

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

		#Columna2
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	
			
		#Columna3
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

		#Columna4
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

		#Columna5

	
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2	

			addi a1, a1, PASILLO
			jal draw_bloquemap2		
			

	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

draw_map3:
	addi sp, sp, -4
	sw ra, 0(sp)

	# Lv1
		li a0, Lv_x
		li a1, Lv_y
		lw a2, color_gris22
		addi a3, a1, 4
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y
		addi a1, a1, 4  
		addi a3, a0, 2
		jal draw_horizontal_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 2
		addi a0, a0, 4 
		addi a3, a1, 1
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 2
		addi a0, a0, 6 
		addi a3, a1, 1
		jal draw_vertical_line

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 4
		addi a0, a0, 5 
		jal draw_point
	#3	
		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 10
		addi a0, a0, 2 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 6 
		addi a0, a0, 2 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 6
		addi a0, a0, 3 
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 7
		addi a0, a0, 4
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 8
		addi a0, a0, 3
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 9
		addi a0, a0, 4
		jal draw_point

		li a0, Lv_x 
		li a1, Lv_y 
		addi a1, a1, 10
		addi a0, a0, 3
		jal draw_point
		
	#Bloques rompibles
		li a0, BLOQUE_1_x
		li a1, BLOQUE_1_y

		#Columna1
			#addi a0, a0, -5

			
			#addi a1, a1, PASILLO
			#addi a1, a1, -2
			#addi a1, a1, PASILLO
			#jal draw_bloque2	

			#addi a1, a1, PASILLO
			#addi a1, a1, -1
			#addi a1, a1, PASILLO
			#jal draw_bloque2
			#addi a1, a1, 1
			#jal draw_bloque2	

		#Columna2
			li a1, BLOQUE_1_y
			addi a1, a1, -5
			#addi a0, a0, 5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
			
		#Columna3
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		#Columna4
			li a1, BLOQUE_1_y
			addi a0, a0, 5
		#Columna5
			li a1, BLOQUE_1_y
			addi a0, a0, 5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -1
			jal draw_bloque2	

		#Columna6
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2

			addi a1, a1, PASILLO	
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -8
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2		

		#Columna7
			li a1, BLOQUE_1_y
			addi a1, a1, -5
			addi a0, a0, 5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
			
		#Columna8
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		
			addi a0, a0, -5

			
			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, -1
			addi a1, a1, PASILLO
			jal draw_bloque2
			addi a1, a1, 1
			jal draw_bloque2	

		#Columna9
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	
		#Columna10
			li a1, BLOQUE_1_y
			addi a1, a1, -5
			addi a0, a0, 5

			addi a1, a1, PASILLO
			addi a1, a1, -2
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2
		#Columna11
			li a1, BLOQUE_1_y
			addi a0, a0, 5
			addi a1, a1, -5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, 1
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, 4
			addi a1, a1, PASILLO
			jal draw_bloque2	

		#Columna12
			li a1, BLOQUE_1_y
			addi a0, a0, 5

			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -2
			jal draw_bloque2	

			addi a1, a1, PASILLO
			addi a1, a1, PASILLO
			addi a1, a1, -1
			jal draw_bloque2	

	#Bloques fijos
		li a0, BLOQUE_1_x
		li a1, BLOQUE_1_y

		#Columna1
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3

			addi a1, a1, PASILLO
			jal draw_bloquemap3

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

		#Columna2
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	
			
		#Columna3
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

		#Columna4
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

		#Columna5

	
			li a1, BLOQUE_1_y
			addi a0, a0, 10

			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3	

			addi a1, a1, PASILLO
			jal draw_bloquemap3		
			

	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra


Time:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)

		.startime:
	# Restar 1 al contador
		lw t0, counter
		addi t0, t0, -1
		sw t0, counter, t1
		lw t0, counter
		bne zero, t0, .cuente
				lw t1, player_lives
				addi t1, t1, -1
				sw t1, player_lives, t2 
				mv s0, s4
				mv s1, s5
				jal erase_bloque
				jal erase_barra_vidas
				li s4, PLAYER_1_X_POS
				li s5, PLAYER_1_Y_POS 
				li t0, 20
				sw t0, time_draw, t1
				li t0, 1100	#2200
				sw t0, counter, t1
				sw zero, time_speed_draw, t1
				lw t1, player_lives 
				bne zero, t1, .startime
				j game_over 
		.cuente:

	#contar hasta 50 para reducir barra de tiempo
		lw t0, time_speed_draw
		addi t0, t0, 1
		sw t0, time_speed_draw, t1
		li t1, 110		#110
		lw t0, time_speed_draw
		bne t0, t1, .no_contar
			lw a0, time_draw_x
			lw a1, time_draw_y

			jal erase_time
			# Cambiar barra a color rojo
				lw a2, color_gris1
				li t0, 200
				lw t1, counter
				blt t0, t1, .mantener_gris
					lw a2, color_rojo1
				.mantener_gris:
			lw t0, time_draw
			add a3, a0, t0
			jal draw_horizontal_line

			lw t0, time_draw
			addi t0, t0, -1
			sw t0, time_draw, t1

			sw zero, time_speed_draw, t1
		.no_contar:

	# Barras laterales
		lw a0, time_draw_x
		lw a1, time_draw_y
		
		lw a0, time_draw_x
		addi a0, a0, -2
		lw a1, time_draw_y 
		addi a1, a1, -1
		lw a2, color_gris4
		addi a3, a1, 2
		jal draw_vertical_line

		lw a0, time_draw_x
		addi a0, a0, 22
		lw a1, time_draw_y 
		addi a1, a1, -1
		lw a2, color_gris4
		addi a3, a1, 2
		jal draw_vertical_line


	lw s0, 4(sp)
	lw s1, 8(sp)
	lw ra, 0(sp)
	addi sp, sp, 12
	jr ra

Vulnerabilidad_time:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)


		lw t0, vulnerabilidad
		beq zero, t0, .vulnerable
		addi t0, t0, -1
		sw t0, vulnerabilidad, t1
		.vulnerable:

	lw s0, 4(sp)
	lw s1, 8(sp)
	lw ra, 0(sp)
	addi sp, sp, 12
	jr ra


draw_powerup_bombas:
	addi sp, sp, -12
	sw ra, 0(sp) 
	sw s0, 4(sp) 
	sw s1, 8(sp) 

		.borrarBloque:
		lw t0, power_up_bomba_bloque
		li t1, 3
		beq t0, t1, .continuarB
		lw t0, power_up_bomba_bloque
		li t1, 2
		bne t0, t1, .dibujar
			li s0, POWER_UP_BOMBAX
			li s1, POWER_UP_BOMBAY
			jal erase_bloque
			li t0, 3
			sw t0, power_up_bomba_bloque, t1
			j .borrarBloque
		.dibujar:
		#Desactivo
		lw t0, power_up_bomba_bloque
		li t1, 1
		beq t0, t1, .activoB
		jal draw_bloque_powerB2
		j .continuarB
		#Activo
			.activoB:
			jal draw_bloque_powerB

		.continuarB:

	lw s0, 4(sp) 
	lw s1, 8(sp)
	lw ra, 0(sp)
	addi sp, sp, 12
	jr ra

draw_powerup_bombas2:
	addi sp, sp, -12
	sw ra, 0(sp) 
	sw s0, 4(sp) 
	sw s1, 8(sp) 

		.borrarBloque2:
		lw t0, power_up_bomba_bloque2
		li t1, 3
		beq t0, t1, .continuarB2
		lw t0, power_up_bomba_bloque2
		li t1, 2
		bne t0, t1, .dibujar2
			li s0, POWER_UP_BOMBA2X
			li s1, POWER_UP_BOMBA2Y
			jal erase_bloque
			li t0, 3
			sw t0, power_up_bomba_bloque2, t1
			j .borrarBloque2
		.dibujar2:
		#Desactivo
		lw t0, power_up_bomba_bloque2
		li t1, 1
		beq t0, t1, .activoB2
		jal draw_bloque_powerB2_2
		j .continuarB2
		#Activo
			.activoB2:
			jal draw_bloque_powerB_2

		.continuarB2:

	lw s0, 4(sp) 
	lw s1, 8(sp)
	lw ra, 0(sp)
	addi sp, sp, 12
	jr ra

draw_powerup_patin:
	addi sp, sp, -4
	sw ra, 0(sp) 

		.borrarBloqueP:
		lw t0, power_up_patin_bloque
		li t1, 3
		beq t0, t1, .continuarP
		lw t0, power_up_patin_bloque
		li t1, 2
		bne t0, t1, .dibujarP
			li s0, POWER_UP_PATINX
			li s1, POWER_UP_PATINY
			jal erase_bloque
			li t0, 3
			sw t0, power_up_patin_bloque, t1
			j .borrarBloqueP
		.dibujarP:
		#Desactivo
		lw t0, power_up_patin_bloque
		li t1, 1
		beq t0, t1, .activoP
		jal draw_bloque_powerP2
		j .continuarP
		#Activo
			.activoP:
			jal draw_bloque_powerP

		.continuarP:

	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

draw_powerup_llama:
	addi sp, sp, -4
	sw ra, 0(sp) 

		.borrarBloqueLl:
		lw t0, power_up_llama_bloque
		li t1, 3
		beq t0, t1, .continuarLL
		lw t0, power_up_llama_bloque
		li t1, 2
		bne t0, t1, .dibujarLl
			li s0, POWER_UP_LLAMAX
			li s1, POWER_UP_LLAMAY
			jal erase_bloque
			li t0, 3
			sw t0, power_up_llama_bloque, t1
			j .borrarBloqueLl
		.dibujarLl:
		#Desactivo
		lw t0, power_up_llama_bloque
		li t1, 1
		beq t0, t1, .activoLL
		jal draw_bloque_powerLl2
		j .continuarLL
		#Activo
			.activoLL:
			jal draw_bloque_powerLl

		.continuarLL:

	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

#

##### Funciones para dibujar
#
draw_vertical_line:
	
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	
	sub s0, a3, a1
	mv s1, a1
	li s2, 0
	
	.vertical_loop:
		add a1, s1, s0
		jal draw_point
		addi s0, s0, -1
		
		bge s0, s2, .vertical_loop
	
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	
	addi sp, sp, 16	
	
	jr ra
draw_point:
	li t0, 6
	sll t0, a1, t0 #Due to the size of the screen, multiply y coodinate by 64 (length of the field)
	add t1, a0, t0
	li t0, 2 
	sll t1, t1, t0 # Multiply the resulting coodinate by 4
	add t1, t1, gp
	sw a2, (t1)
	jr ra

LoadColor:
	li t0, 6
	sll t0, a1,t0
	add a7, a0, t0
	li t0, 2
	sll a7, a7, t0
	add a7, a7, gp
	lw a7, 0(a7)
	jr ra
	

draw_horizontal_line:
	
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	
	sub s0, a3, a0						# s0 = magnitud de la linea
	mv s1, a0						# Copia la coordenada x inicial en s1
	li s2, 0						# Carga 0 en s2
	
	.horizontal_loop:
		add a0, s1, s0					# Coloca a0 en coordenada x final de la linea, para pasar como argumento a draw_point
		jal draw_point					# Pinta el pixel mas a la derecha
		addi s0, s0, -1					# Resta 1 a a0, para continuar pintando pixeles hacia la izquierda
		
		bge s0, s2, .horizontal_loop
	
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16	
	
	jr ra

#
#### Bloques, marcos, titulo
#
winner:	#Espera en la portada hasta presionar 1 para comenzar
	jal clear_key_press
	jal clear_key_status

	sw zero, state, t1
	jal clear_board
	jal draw_winner

	select_11:
    	lw t0, KEY_INPUT_ADDRESS # Verify if the player pressed an input
    	li t1, ASCII_SPACE
    	beq t0, t1, start_game1
    	
    	li a0, 1
    	li a7, 32
    	ecall
    	
    	j select_11 # If a key was not pressed go back to the loop
    	

    start_game1:
		
    	sw zero, KEY_STATUS_ADDRESS, t0 # This clears the status if a key was pressed
	j new_game	

game_over:	#Espera en la portada hasta presionar 1 para comenzar
	
	jal clear_key_press
	jal clear_key_status

	sw zero, state, t1
	jal clear_board
	jal draw_gameover

	select_G:
    	lw t0, KEY_INPUT_ADDRESS # Verify if the player pressed an input
    	li t1, ASCII_SPACE
    	beq t0, t1, start_gameG
    	
    	li a0, 1
    	li a7, 32
    	ecall
    	
    	j select_G # If a key was not pressed go back to the loop
    	

    start_gameG:
		
    	sw zero, KEY_STATUS_ADDRESS, t0 # This clears the status if a key was pressed
	j new_game	 


	
draw_bloque:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

	li s0, 3
	li s1, 1
	.loopb:
		lw a2, color_gris4
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris2
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4
		jal draw_point

		beq s0, s1, .endloopb

		lw a0, 4(sp)
		addi a1, a1, 1
		lw a2, color_gris3
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4	
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris3
		jal draw_point
		addi a0, a0, 1
		jal draw_point

	.endloopb:
		lw a0, 4(sp)
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, zero, .loopb
		addi a1, a1, -1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra

draw_bloquemap2:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

		lw a2, color_gris4
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4
		jal draw_point


		lw a0, 4(sp)
		addi a1, a1, 1
		lw a2, color_gris3
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4	
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris3
		jal draw_point
		addi a0, a0, 1
		jal draw_point

		lw a0, 4(sp)
		addi a1, a1, 1
		lw a2, color_gris4
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cyan
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4
		jal draw_point


		lw a0, 4(sp)
		addi a1, a1, 1
		lw a2, color_gris3
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4	
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris3
		jal draw_point
		addi a0, a0, 1
		jal draw_point

		lw a0, 4(sp)
		addi a1, a1, 1
		lw a2, color_gris4
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_gris4
		jal draw_point
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra


draw_bloquemap3:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv s0, a0
	mv s1, a1

	#Enemigo 2

		#columna0
			mv a0, s0
			mv a1, s1

			lw a2, color_gris4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris4
			jal draw_point
		#Columna1
			mv a0, s0
			mv a1, s1
			addi a0, a0, 1
			
			lw a2, color_gris4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris4
			jal draw_point
		#Columna2
			mv a0, s0
			mv a1, s1
			addi a0, a0, 2
			
			lw a2, color_gris4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris4
			jal draw_point
		#Columna3
			mv a0, s0
			mv a1, s1
			addi a0, a0, 3
			
			lw a2, color_gris4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris4
			jal draw_point

		#Columna4
			mv a0, s0
			mv a1, s1
			addi a0, a0, 4

			lw a2, color_gris4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_gris4
			jal draw_point


	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque2:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

	li s0, 3
	li s1, 1
	.loopb22:
		lw a2, color_cafe3
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe3
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe3
		jal draw_point

		beq s0, s1, .endloopb22

		lw a0, 4(sp)
		addi a1, a1, 1
		lw a2, color_cafe3
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe3	
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe3
		jal draw_point

	.endloopb22:
		lw a0, 4(sp)
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, zero, .loopb22
		addi a1, a1, -1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra

draw_bloqueGate:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a1, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)
	sw a0, 16(sp)

	li s0, 5
	li s1, 0
	
		lw a2, color_azul
		li, t0, 3
		add a3, a0, t0
		jal draw_horizontal_line

		lw a2, color_azul
		li, t0, 3
		addi a1, a1, 4
		add a3, a0, t0
		jal draw_horizontal_line
		

		lw a1, 4(sp)
		addi a0, a0, 4
		li t0, 4
		add a3, a1, t0
		jal draw_vertical_line

		lw a1, 4(sp)
		lw a0, 16(sp)
		li t0, 4
		add a3, a1, t0
		jal draw_vertical_line

		li s0, 3
		li s1, 0
		lw a1, 4(sp)
		lw a0, 16(sp)
		addi a1, a1, 1
		addi a0, a0, 1

	.loopgate2:
		lw a2, color_azulO
		li, t0, 2
		add a3, a0, t0
		jal draw_horizontal_line
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, s1, .loopgate2
	 
	
	lw ra, 0(sp)
	lw a1, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	lw a0, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloqueGate2:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

	li s0, 3
	li s1, 1
	.loopbg2:
		lw a2, color_cafe4
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4
		jal draw_point

		beq s0, s1, .endloopg22

		lw a0, 4(sp)
		addi a1, a1, 1
		lw a2, color_cafe4
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4	
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4
		jal draw_point

	.endloopg22:
		lw a0, 4(sp)
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, zero, .loopbg2
		addi a1, a1, -1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra

draw_bloque_powerP:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a1, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)
	sw a0, 16(sp)


	li a0, POWER_UP_PATINX
	li a1, POWER_UP_PATINY

		addi a1, a1, 1
		lw a2, color_naranjaP
		addi a3, a1, 1
		jal draw_vertical_line  

		li a0, POWER_UP_PATINX
		li a1, POWER_UP_PATINY
		lw a2, color_naranjaP
		addi a1, a1, 2
		addi a3, a0, 4
		jal draw_horizontal_line
		

		li a0, POWER_UP_PATINX
		li a1, POWER_UP_PATINY
		lw a2, color_cafeT
		addi a1, a1, 3 
		addi a0, a0, 1 
		jal draw_point
		
		li a0, POWER_UP_PATINX
		li a1, POWER_UP_PATINY
		lw a2, color_cafeT 
		addi a1, a1, 3
		addi a0, a0, 3 
		jal draw_point

	
	lw ra, 0(sp)
	lw a1, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	lw a0, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_powerP2:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

	li s0, 3
	li s1, 1


	li a0, POWER_UP_PATINX
	li a1, POWER_UP_PATINY 

	.loopPP2:
		lw a2, color_cafe4P
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4P
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4P
		jal draw_point

		beq s0, s1, .endloopPP22

		li a0, POWER_UP_PATINX
		addi a1, a1, 1
		lw a2, color_cafe4P
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4P
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4P
		jal draw_point

	.endloopPP22:
		li a0, POWER_UP_PATINX
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, zero, .loopPP2
		addi a1, a1, -1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra

draw_bloque_powerB:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a1, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)
	sw a0, 16(sp)


	li a0, POWER_UP_BOMBAX 
	li a1, POWER_UP_BOMBAY

		addi a0, a0, 1
		lw a2, color_naranjaB
		li, t0, 2
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

		addi a0, a0, 4
		lw a2, color_cafeT
		jal draw_point
		addi a0, a0, -4

		addi a0, a0, 3
		lw a2, color_cafeT
		jal draw_point
		addi a0, a0, -3


		lw a2, color_naranjaB
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		addi a0, a0, 2
		lw a2, color_cafeT
		jal draw_point
		addi a0, a0, -2
		
		lw a2, color_naranjaB
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		addi a0, a0, 1
		li, t0, 2
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

	
	lw ra, 0(sp)
	lw a1, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	lw a0, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_powerB2:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

	li s0, 3
	li s1, 1


	li a0, POWER_UP_BOMBAX 
	li a1, POWER_UP_BOMBAY

	.loopPB2:
		lw a2, color_cafe4B
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B
		jal draw_point

		beq s0, s1, .endloopPB22

		li a0, POWER_UP_BOMBAX 
		addi a1, a1, 1
		lw a2, color_cafe4B
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B	
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B
		jal draw_point

	.endloopPB22:
		li a0, POWER_UP_BOMBAX 
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, zero, .loopPB2
		addi a1, a1, -1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra

draw_bloque_powerB_2:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a1, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)
	sw a0, 16(sp)


	li a0, POWER_UP_BOMBA2X 
	li a1, POWER_UP_BOMBA2Y

		addi a0, a0, 1
		lw a2, color_naranjaB2
		li, t0, 2
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

		addi a0, a0, 4
		lw a2, color_cafeT
		jal draw_point
		addi a0, a0, -4

		addi a0, a0, 3
		lw a2, color_cafeT
		jal draw_point
		addi a0, a0, -3


		lw a2, color_naranjaB2
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		addi a0, a0, 2
		lw a2, color_cafeT
		jal draw_point
		addi a0, a0, -2
		
		lw a2, color_naranjaB2
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		addi a0, a0, 1
		li, t0, 2
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

	
	lw ra, 0(sp)
	lw a1, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	lw a0, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_powerB2_2:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

	li s0, 3
	li s1, 1


	li a0, POWER_UP_BOMBA2X 
	li a1, POWER_UP_BOMBA2Y

	.loopPB22:
		lw a2, color_cafe4B2
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B2
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B2
		jal draw_point

		beq s0, s1, .endloopPB222

		li a0, POWER_UP_BOMBA2X 
		addi a1, a1, 1
		lw a2, color_cafe4B2
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B2
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4B2
		jal draw_point

	.endloopPB222:
		li a0, POWER_UP_BOMBA2X 
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, zero, .loopPB22
		addi a1, a1, -1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra

draw_bloque_powerLl:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a1, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)
	sw a0, 16(sp)


	li a0, POWER_UP_LLAMAX 
	li a1, POWER_UP_LLAMAY

		addi a0, a0, 2
		lw a2, color_naranjaLl 
		jal draw_point
 
		lw a2, color_cafeT
		addi a1, a1, 1 
		jal draw_point 

		lw a2, color_cafeT
		addi a1, a1, 1 
		jal draw_point 

		lw a2, color_cafeT
		addi a1, a1, 1 
		jal draw_point 
  
		addi a1, a1, 1
		lw a2, color_naranjaLl 
		jal draw_point 


		li a0, POWER_UP_LLAMAX 
		li a1, POWER_UP_LLAMAY
		addi a1, a1, 2
		lw a2, color_naranjaLl 
		jal draw_point
 
		lw a2, color_cafeT
		addi a0, a0, 1 
		jal draw_point 

		lw a2, color_cafeT
		addi a0, a0, 1 
		jal draw_point 

		lw a2, color_cafeT
		addi a0, a0, 1 
		jal draw_point 
  
		addi a0, a0, 1
		lw a2, color_naranjaLl 
		jal draw_point

		li a0, POWER_UP_LLAMAX 
		li a1, POWER_UP_LLAMAY
		addi a1, a1, 1
		addi a0, a0, 1
		lw a2, color_naranjaLl 
		jal draw_point
 
		addi a0, a0, 2
		lw a2, color_naranjaLl 
		jal draw_point

		addi a1, a1, 2
		lw a2, color_naranjaLl 
		jal draw_point
 
		addi a0, a0, -2
		lw a2, color_naranjaLl 
		jal draw_point
 
		

	
	lw ra, 0(sp)
	lw a1, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	lw a0, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_powerLl2:

	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)

	li s0, 3
	li s1, 1


	li a0, POWER_UP_LLAMAX 
	li a1, POWER_UP_LLAMAY 

	.loopLl2:
		lw a2, color_cafe4Ll
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4Ll
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4Ll
		jal draw_point

		beq s0, s1, .endloopLl22

		li a0, POWER_UP_LLAMAX 
		addi a1, a1, 1
		lw a2, color_cafe4Ll
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4Ll	
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, 1
		lw a2, color_cafe4Ll
		jal draw_point

	.endloopLl22:
		li a0, POWER_UP_LLAMAX 
		addi s0, s0, -1
		addi a1, a1, 1
		bne s0, zero, .loopLl2
		addi a1, a1, -1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	addi sp, sp, 16
	
	jr ra


draw_bloque_bomba:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

		addi a0, a0, 1
		lw a2, color_black
		li, t0, 2
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

		addi a0, a0, 4
		lw a2, color_naranjaM
		jal draw_point
		addi a0, a0, -4

		addi a0, a0, 3
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, -3


		lw a2, color_black
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		addi a0, a0, 2
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, -2
		
		lw a2, color_black
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		addi a0, a0, 1
		li, t0, 2
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1
	
	 
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_bomba1:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

		addi a0, a0, 1
		lw a2, color_black1
		li, t0, 2
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

		addi a0, a0, 4
		lw a2, color_naranjaM
		jal draw_point
		addi a0, a0, -4

		addi a0, a0, 3
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, -3


		lw a2, color_black1
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		addi a0, a0, 2
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, -2
		
		lw a2, color_black1
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		addi a0, a0, 1
		li, t0, 2
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1
	
	 
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_bomba2:

	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

		addi a0, a0, 1
		lw a2, color_black2
		li, t0, 2
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

		addi a0, a0, 4
		lw a2, color_naranjaM
		jal draw_point
		addi a0, a0, -4

		addi a0, a0, 3
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, -3


		lw a2, color_black2
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		addi a0, a0, 2
		lw a2, color_cafe1
		jal draw_point
		addi a0, a0, -2
		
		lw a2, color_black2
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		addi a0, a0, 1
		li, t0, 2
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1
	
	 
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_enemy1:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

	#Enemigo 1

		#columna0
			#mv a0, s0
			#mv a1, s1
			#li t0, 4
			#add a3, a1, t0
			#lw a2, color_piel
			#jal draw_vertical_line
		#Columna1
			#mv a0, s0
			#mv a1, s1
			#addi a0, a0, 1
			#lw a2, color_piel
			#jal draw_point

		
			#addi a1, a1, 1
			#lw a2, color_black
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_piel
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_black
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_piel
			#jal draw_point
		#Columna2
			#mv a0, s0
			#mv a1, s1
			#addi a0, a0, 2
			#li t0, 2
			#add a3, a1, t0
			#lw a2, color_piel
			#jal draw_vertical_line

			#addi a1, a1, 3
			#lw a2, color_black
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_piel
			#jal draw_point
		#Columna3
			#mv a0, s0
			#mv a1, s1
			#addi a0, a0, 3
			#lw a2, color_piel
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_black
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_piel
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_black
			#jal draw_point

			#addi a1, a1, 1
			#lw a2, color_piel
			#jal draw_point

		#Columna4
			#mv a0, s0
			#mv a1, s1
			#addi a0, a0, 4
			#li t0, 4
			#add a3, a1, t0
			#lw a2, color_piel
			#jal draw_vertical_line

	#Enemigo 1.2

		#columna0
			mv a0, s0
			mv a1, s1

			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point

		#Columna1
			mv a0, s0
			mv a1, s1
			addi a0, a0, 1
			
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_ladrillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point
		#Columna2
			mv a0, s0
			mv a1, s1
			addi a0, a0, 2
			
			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_grisO
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point

		#Columna3
			mv a0, s0
			mv a1, s1
			addi a0, a0, 3
			
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_ladrillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

		#Columna4
			mv a0, s0
			mv a1, s1
			addi a0, a0, 4
			
			lw a2, color_amarillo1
			jal draw_point

			addi a1, a1, 1

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo1
			jal draw_point


	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_enemy12:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

	#Enemigo 1.2

		#columna0
			mv a0, s0
			mv a1, s1

			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point

		#Columna1
			mv a0, s0
			mv a1, s1
			addi a0, a0, 1
			
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_ladrillo3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point
		#Columna2
			mv a0, s0
			mv a1, s1
			addi a0, a0, 2
			
			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1
			lw a2, color_grisO
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point

		#Columna3
			mv a0, s0
			mv a1, s1
			addi a0, a0, 3
			
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_ladrillo3
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

		#Columna4
			mv a0, s0
			mv a1, s1
			addi a0, a0, 4
			
			lw a2, color_amarillo11
			jal draw_point

			addi a1, a1, 1

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo11
			jal draw_point


	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_enemy13:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1



	#Enemigo 1.2

		#columna0
			mv a0, s0
			mv a1, s1

			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point

		#Columna1
			mv a0, s0
			mv a1, s1
			addi a0, a0, 1
			
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_ladrillo4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point
		#Columna2
			mv a0, s0
			mv a1, s1
			addi a0, a0, 2
			
			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1
			lw a2, color_grisO
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point

		#Columna3
			mv a0, s0
			mv a1, s1
			addi a0, a0, 3
			
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_ladrillo4
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

		#Columna4
			mv a0, s0
			mv a1, s1
			addi a0, a0, 4
			
			lw a2, color_amarillo12
			jal draw_point

			addi a1, a1, 1

			addi a1, a1, 1
			lw a2, color_amarillo2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_amarillo12
			jal draw_point


	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_enemy2:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

	#Enemigo 2

		#columna0
			mv a0, s0
			mv a1, s1
			addi a1, a1, 1
			li t0, 1
			add a3, a1, t0
			lw a2, color_rosado
			jal draw_vertical_line

			addi a1, a1, 3
			lw a2, color_rosado2
			jal draw_point
		#Columna1
			mv a0, s0
			mv a1, s1
			addi a0, a0, 1
			lw a2, color_rosado
			jal draw_point

		
			addi a1, a1, 1
			lw a2, color_azulO
			jal draw_point

			addi a1, a1, 1
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_rosado
			jal draw_point

			addi a1, a1, 1
			lw a2, color_rosado2
			jal draw_point
		#Columna2
			mv a0, s0
			mv a1, s1
			addi a0, a0, 2
			li t0, 3
			add a3, a1, t0
			lw a2, color_rosado
			jal draw_vertical_line
		#Columna3
			mv a0, s0
			mv a1, s1
			addi a0, a0, 3
			lw a2, color_rosado
			jal draw_point

		
			addi a1, a1, 1
			lw a2, color_azulO
			jal draw_point

			addi a1, a1, 1
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_rosado
			jal draw_point

			addi a1, a1, 1
			lw a2, color_rosado2
			jal draw_point

		#Columna4
			mv a0, s0
			mv a1, s1
			addi a0, a0, 4
			addi a1, a1, 1
			li t0, 1
			add a3, a1, t0
			lw a2, color_rosado
			jal draw_vertical_line

			addi a1, a1, 3
			lw a2, color_rosado2
			jal draw_point


	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra


draw_bloque_enemy3:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

	#Enemigo 2

		#columna0
			mv a0, s0
			mv a1, s1
			addi a1, a1, 1
			li t0, 3
			add a3, a1, t0
			lw a2, color_naranja
			jal draw_vertical_line
		#Columna1
			mv a0, s0
			mv a1, s1
			addi a0, a0, 1
			lw a2, color_naranja
			jal draw_point

		
			addi a1, a1, 1
			lw a2, color_grisO
			jal draw_point

			addi a1, a1, 1
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja
			jal draw_point
		#Columna2
			mv a0, s0
			mv a1, s1
			addi a0, a0, 2
			li t0, 4
			add a3, a1, t0
			lw a2, color_naranja
			jal draw_vertical_line
		#Columna3
			mv a0, s0
			mv a1, s1
			addi a0, a0, 3
			lw a2, color_naranja
			jal draw_point

		
			addi a1, a1, 1
			lw a2, color_grisO
			jal draw_point

			addi a1, a1, 1
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja
			jal draw_point

		#Columna4
			mv a0, s0
			mv a1, s1
			addi a0, a0, 4
			addi a1, a1, 1
			li t0, 3
			add a3, a1, t0
			lw a2, color_naranja
			jal draw_vertical_line


	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

draw_bloque_enemy4:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw s0, 12(sp)
	sw s1, 16(sp)

	mv a0, s0
	mv a1, s1

	#Enemigo 2

		#columna0
			mv a0, s0
			mv a1, s1

			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point
		#Columna1
			mv a0, s0
			mv a1, s1
			addi a0, a0, 1
			
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point
		#Columna2
			mv a0, s0
			mv a1, s1
			addi a0, a0, 2
			
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point
		#Columna3
			mv a0, s0
			mv a1, s1
			addi a0, a0, 3
			
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_black
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point

		#Columna4
			mv a0, s0
			mv a1, s1
			addi a0, a0, 4
			
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_naranja2
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point

			addi a1, a1, 1
			lw a2, color_white
			jal draw_point


	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw s0, 12(sp)
	lw s1, 16(sp)
	addi sp, sp, 20
	
	jr ra

erase_barra_puntos:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	

	#linea negra puntos
		li a0, PUNTOS_1_x
		li a1, PUNTOS_y
		addi a0, a0, 6
		addi a1, a1, -3
		lw a2, color_black
		addi a3, a1, 11
		jal draw_vertical_line

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12
	
	jr ra


erase_barra_vidas:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	

	#linea negra puntos
		li a0, VIDA_1_x
		li a1, VIDA_1_y 
		lw a2, color_grisO2
		addi a3, a1, 8
		jal draw_vertical_line

		li a0, VIDA_1_x
		li a1, VIDA_1_y
		addi a0, a0, 1
		lw a2, color_grisO2
		addi a3, a1, 8
		jal draw_vertical_line

		li a0, VIDA_1_x
		li a1, VIDA_1_y
		addi a0, a0, 2
		lw a2, color_grisO2
		addi a3, a1, 8
		jal draw_vertical_line

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12
	
	jr ra
	
erase_time:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)

		lw a0, time_draw_x
		lw a1, time_draw_y
		lw a2, color_grisO
		addi a3, a0, 20
		jal draw_horizontal_line

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12
	
	jr ra

clear_board:
	lw t0, color_black
	li t1, TOTAL_PIXELS
	li t2, FOUR_BYTES

	lw t4, state
	li t5, 0
	beq t4, t5, .start_clear_loop
	lw t0, color_verde
	
	.start_clear_loop:
		sub t1, t1, t2
		add t3, t1, gp
		sw t0, (t3)
		beqz t1, .end_clear_loop
		j .start_clear_loop
		
	.end_clear_loop:
	
	jr ra
	
erase_player:

	addi sp, sp -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)

	mv s0, s4
	mv s1, s5

	#derecha
				#fila0
					mv a0, s0
					mv a1, s1
					li t0, 3
					add a3, a0, t0
					lw a2, color_verde
					jal draw_horizontal_line

				#fila1
					mv a0, s0
					addi a1, a1, 1
					addi a0, a0, 1
					li t0, 2
					add a3, a0, t0
					lw a2, color_verde
					jal draw_horizontal_line

					mv a0, s0
					lw a2, color_verde
					jal draw_point

				#fila2
					addi a1, a1, 1
					mv a0, s0
					li t0, 3
					add a3, a0, t0
					lw a2, color_verde
					jal draw_horizontal_line

					
					addi a0, a0, 4
					lw a2, color_verde
					jal draw_point
				#fila3
					addi a1, a1, 1
					mv a0, s0
					li t0, 2
					addi a0, a0, 1
					add a3, a0, t0
					lw a2, color_verde
					jal draw_horizontal_line

				#fila4
					addi a1, a1, 1
					mv a0, s0
					li t0, 1
					add a3, a0, t0
					lw a2, color_verde
					jal draw_horizontal_line

					mv a0, s0
					li t0, 1
					addi a0, a0, 3
					add a3, a0, t0
					lw a2, color_verde
					jal draw_horizontal_line

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp 16
	jr ra

erase_bomba:

	addi sp, sp -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)

	mv a0, s0
	mv a1, s1

	addi a0, a0, 1
		lw a2, color_verde
		li, t0, 2
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1

		addi a0, a0, 4
		lw a2, color_verde
		jal draw_point
		addi a0, a0, -4

		addi a0, a0, 3
		lw a2, color_verde
		jal draw_point
		addi a0, a0, -3


		lw a2, color_verde
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		addi a0, a0, 2
		lw a2, color_verde
		jal draw_point
		addi a0, a0, -2
		
		lw a2, color_verde
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		addi a0, a0, 1
		li, t0, 2
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		addi a0, a0, -1


	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp 16
	jr ra

erase_bloque:

	addi sp, sp -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw a3, 16(sp)

	mv a0, s0
	mv a1, s1

		lw a2, color_verde
		li, t0, 4
		add a3, a0, t0
		jal draw_horizontal_line

		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
		
		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line

		li, t0, 4
		addi a1, a1, 1
		add a3, a0, t0
		jal draw_horizontal_line
	
	lw a3, 16(sp)
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp 20
	jr ra



draw_title_screen:

	addi sp, sp, -4
	sw ra, 0(sp)

	# Marco superior
		#Lineas horizontales
		li a0, 1									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_horizontal_line
		
		li a0, 2
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_cyan
		li a3, 61
		jal draw_horizontal_line
		
		li a0, 3
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_orange
		li a3, 60
		jal draw_horizontal_line
	
		#Lineas verticales derechas
		li a0, 1									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 7									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 2
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_cyan
		li a3, 7
		jal draw_vertical_line
		
		li a0, 3
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_orange
		li a3, 7
		jal draw_vertical_line
		
		#Lineas verticales izquierdas
		li a0, 62									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 7									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 61
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_cyan
		li a3, 7
		jal draw_vertical_line
		
		li a0, 60
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_orange
		li a3, 7
		jal draw_vertical_line
	
	# Marco inferior
		#Lineas horizontales
		li a0, 1									# a0-> coordenada en x
		li a1, 62						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_horizontal_line
		
		li a0, 2
		li a1, 61
		lw a2, color_cyan
		li a3, 61
		jal draw_horizontal_line
		
		li a0, 3
		li a1, 60
		lw a2, color_orange
		li a3, 60
		jal draw_horizontal_line
	
		#Lineas verticales derechas
		li a0, 1									# a0-> coordenada en x
		li a1, 55						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 2
		li a1, 55
		lw a2, color_cyan
		li a3, 61
		jal draw_vertical_line
		
		li a0, 3
		li a1, 55
		lw a2, color_orange
		li a3, 60
		jal draw_vertical_line
		
		#Lineas verticales izquierdas
		li a0, 62									# a0-> coordenada en x
		li a1, 55						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 61
		li a1, 55
		lw a2, color_cyan
		li a3, 61
		jal draw_vertical_line
		
		li a0, 60
		li a1, 55
		lw a2, color_orange
		li a3, 60
		jal draw_vertical_line
	
	# Bomberman text
		# The B
		li a0, PONG_TEXT_X
		li a1, PONG_TEXT_Y
		lw a2, color_white
		li a3, PONG_TEXT_Y
		addi a3, a3, PONG_TEXT_H
		jal draw_vertical_line
		
		li a0, PONG_TEXT_X
		addi a0, a0, 4
		li a1, PONG_TEXT_Y
		addi a1, a1, 1
		lw a2, color_white
		addi a3, a1, 1
		jal draw_vertical_line
		
		li a0, PONG_TEXT_X
		addi a0, a0, 4
		li a1, PONG_TEXT_Y
		addi a1, a1, 4
		lw a2, color_white
		addi a3, a1, 1
		jal draw_vertical_line #derecha abajo
		
		li a0, PONG_TEXT_X
		addi a0, a0, 1
		li a1, PONG_TEXT_Y
		addi a1, a1, 3
		lw a2, color_white
		addi a3, a0, 2
		jal draw_horizontal_line #medio
		
		li a0, PONG_TEXT_X
		addi a0, a0, 1
		li a1, PONG_TEXT_Y
		lw a2, color_white
		addi a3, a0, 2
		jal draw_horizontal_line #arriba
		
		li a0, PONG_TEXT_X
		addi a0, a0, 1
		li a1, PONG_TEXT_Y
		addi a1, a1, 6
		lw a2, color_white
		addi a3, a0, 2
		jal draw_horizontal_line #abajo
		
		# The O
			li a0, PONG_TEXT_X
			addi a0, a0, 6
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 10
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 6
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a0, 3
			jal draw_horizontal_line
		
			li a0, PONG_TEXT_X
			addi a0, a0, 6
			li a1, PONG_TEXT_Y
			addi a1,  a1, 6
			lw a2, color_white
			addi a3, a0, 3
			jal draw_horizontal_line
					
		# The M
			li a0, PONG_TEXT_X
			addi a0, a0, 12
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 13
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 14
			li a1, PONG_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 15
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 16
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			
		# The B
			li a0, PONG_TEXT_X
			addi a0, a0, 18
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 22
			li a1, PONG_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 22
			li a1, PONG_TEXT_Y
			addi a1, a1, 4
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line #derecha abajo
			
			li a0, PONG_TEXT_X
			addi a0, a0, 19
			li a1, PONG_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, PONG_TEXT_X
			addi a0, a0, 19
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
			li a0, PONG_TEXT_X
			addi a0, a0, 19
			li a1, PONG_TEXT_Y
			addi a1, a1, 6
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #abajo
			
		# The E
			li a0, PONG_TEXT_X
			addi a0, a0, 24
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 25
			li a1, PONG_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, PONG_TEXT_X
			addi a0, a0, 25
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
			li a0, PONG_TEXT_X
			addi a0, a0, 25
			li a1, PONG_TEXT_Y
			addi a1, a1, 6
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #abajo
			
		# The R
			li a0, PONG_TEXT_X
			addi a0, a0, 29
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 33
			li a1, PONG_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 33
			li a1, PONG_TEXT_Y
			addi a1, a1, 4
			lw a2, color_white
			addi a3, a1, 2
			jal draw_vertical_line #derecha abajo
			
			li a0, PONG_TEXT_X
			addi a0, a0, 30
			li a1, PONG_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, PONG_TEXT_X
			addi a0, a0, 30
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
		# The M
			li a0, PONG_TEXT_X
			addi a0, a0, 35
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 36
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 37
			li a1, PONG_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 38
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 39
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
		# The A
			li a0, PONG_TEXT_X
			addi a0, a0, 41
			li a1, PONG_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 45
			li a1, PONG_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 5
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 42
			li a1, PONG_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, PONG_TEXT_X
			addi a0, a0, 42
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
		# The M
			li a0, PONG_TEXT_X
			addi a0, a0, 47
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 48
			li a1, PONG_TEXT_Y
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 49
			li a1, PONG_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			addi a3, a1, 2
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 50
			li a1, PONG_TEXT_Y
			addi a1, a1, 5
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PONG_TEXT_X
			addi a0, a0, 51
			li a1, PONG_TEXT_Y
			lw a2, color_white
			li a3, PONG_TEXT_Y
			addi a3, a3, PONG_TEXT_H
			jal draw_vertical_line
		
	# Press 1 or 2 text
		
		#Lineas
			li a0, PRESS_TEXT_X
			addi a0, a0, -6
			li a1, PRESS_TEXT_Y
			addi a1, a1, -4
			lw a2, color_orange
			addi a3, a0, 36
			jal draw_horizontal_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, -6
			li a1, PRESS_TEXT_Y
			addi a1, a1, 8
			lw a2, color_orange
			addi a3, a0, 36
			jal draw_horizontal_line
		
		# The P
			li a0, PRESS_TEXT_X
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 3
			li a1, PRESS_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 1
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 1
			li a1, PRESS_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line
		
		# The R
		
			li a0, PRESS_TEXT_X
			addi a0, a0, 5
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 7
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 7
			li a1, PRESS_TEXT_Y
			addi a1, a1, 2
			lw a2, color_black
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 6
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			jal draw_point

			li a0, PRESS_TEXT_X
			addi a0, a0, 6
			li a1, PRESS_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			jal draw_point
				
		# The E
			li a0, PRESS_TEXT_X
			addi a0, a0, 9
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 10
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 10
			li a1, PRESS_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 10
			li a1, PRESS_TEXT_Y
			addi a1, a1, 4
			lw a2, color_white
			jal draw_point
		
		# The S
			li a0, PRESS_TEXT_X
			addi a0, a0, 12
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 12
			li a1, PRESS_TEXT_Y
			addi a1, a1, 3
			lw a2, color_black
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 13
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 13
			li a1, PRESS_TEXT_Y
			addi a1,  a1, 2
			lw a2, color_white
			jal draw_point

			li a0, PRESS_TEXT_X
			addi a0, a0, 13
			li a1, PRESS_TEXT_Y
			addi a1,  a1, 4
			lw a2, color_white
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 14
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line

			li a0, PRESS_TEXT_X
			addi a0, a0, 14
			li a1, PRESS_TEXT_Y
			addi a1,  a1, 1
			lw a2, color_black
			jal draw_point

		# The S
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 16
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 16
			li a1, PRESS_TEXT_Y
			addi a1, a1, 3
			lw a2, color_black
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 17
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 17
			li a1, PRESS_TEXT_Y
			addi a1,  a1, 2
			lw a2, color_white
			jal draw_point

			li a0, PRESS_TEXT_X
			addi a0, a0, 17
			li a1, PRESS_TEXT_Y
			addi a1,  a1, 4
			lw a2, color_white
			jal draw_point
			
			li a0, PRESS_TEXT_X
			addi a0, a0, 18
			li a1, PRESS_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line

			li a0, PRESS_TEXT_X
			addi a0, a0, 18
			li a1, PRESS_TEXT_Y
			addi a1,  a1, 1
			lw a2, color_black
			jal draw_point
		
		# The 1 

		li a0, PRESS_TEXT_X
		addi a0, a0, 23
		li a1, PRESS_TEXT_Y
		lw a2, color_white
		addi a3, a1, PRESS_TEXT_H
		jal draw_vertical_line
				
		li a0, PRESS_TEXT_X
		addi a0, a0, 22
		li a1, PRESS_TEXT_Y
		addi a1,  a1, 1
		lw a2, color_white
		jal draw_point
		
		li a0, PRESS_TEXT_X
		addi a0, a0, 22
		li a1, PRESS_TEXT_Y
		addi a1, a1, PRESS_TEXT_H
		lw a2, color_white
		addi a3, a0, 2
		jal draw_horizontal_line
		
		
	# The name																																																																
			
		# The S
				
			li a0, NAME_TEXT_X
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_black
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 1
			li a1, NAME_TEXT_Y
			lw a2, color_white
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 1
			li a1, NAME_TEXT_Y
			addi a1,  a1, 2
			lw a2, color_white
			jal draw_point

			li a0, NAME_TEXT_X
			addi a0, a0, 1
			li a1, NAME_TEXT_Y
			addi a1,  a1, 4
			lw a2, color_white
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 2
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line

			li a0, NAME_TEXT_X
			addi a0, a0, 2
			li a1, NAME_TEXT_Y
			addi a1,  a1, 1
			lw a2, color_black
			jal draw_point
																																																																																																																																																																																																																																																							
		# The A
			
			li a0, NAME_TEXT_X
			addi a0, a0, 4
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 5
			li a1, NAME_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 7
			li a1, NAME_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 8
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 6
			li a1, NAME_TEXT_Y
			lw a2, color_white
			jal draw_point

			li a0, NAME_TEXT_X
			addi a0, a0, 5
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line																																																																																																																																																																																						
						
		# The U
			
			li a0, NAME_TEXT_X
			addi a0, a0, 10
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line

			li a0, NAME_TEXT_X
			addi a0, a0, 12
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line		

			li a0, NAME_TEXT_X
			addi a0, a0, 11
			li a1, NAME_TEXT_Y
			addi a1, a1, NAME_TEXT_H
			lw a2, color_white
			jal draw_point
			
		# The L
			li a0, NAME_TEXT_X
			addi a0, a0, 14
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line	

			li a0, NAME_TEXT_X
			addi a0, a0, 15
			li a1, NAME_TEXT_Y
			addi a1, a1, NAME_TEXT_H
			addi a3, a0, 1
			lw a2, color_white
			jal draw_horizontal_line
			
			
		# The R 
			
			li a0, NAME_TEXT_X
			addi a0, a0, 22
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 20
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 22
			li a1, NAME_TEXT_Y
			addi a1, a1, 2
			lw a2, color_black
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 21
			li a1, NAME_TEXT_Y
			lw a2, color_white
			jal draw_point

			li a0, NAME_TEXT_X
			addi a0, a0, 21
			li a1, NAME_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			jal draw_point
			
		# The A
			
			li a0, NAME_TEXT_X
			addi a0, a0, 24
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 25
			li a1, NAME_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 27
			li a1, NAME_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 28
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 26
			li a1, NAME_TEXT_Y
			lw a2, color_white
			jal draw_point

			li a0, NAME_TEXT_X
			addi a0, a0, 25
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line
			
		# The N
			
			li a0, NAME_TEXT_X
			addi a0, a0, 30
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 31
			li a1, NAME_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 32
			li a1, NAME_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 33
			li a1, NAME_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 34
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			
		# The I
			li a0, NAME_TEXT_X
			addi a0, a0, 36
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 37
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 36
			li a1, NAME_TEXT_Y
			addi a1, a1, NAME_TEXT_H
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line
			
		# The R 
			
			li a0, NAME_TEXT_X
			addi a0, a0, 42
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 40
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, NAME_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 42
			li a1, NAME_TEXT_Y
			addi a1, a1, 2
			lw a2, color_black
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 41
			li a1, NAME_TEXT_Y
			lw a2, color_white
			jal draw_point

			li a0, NAME_TEXT_X
			addi a0, a0, 41
			li a1, NAME_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			jal draw_point
			
		# The E
			li a0, NAME_TEXT_X
			addi a0, a0, 44
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a1, PRESS_TEXT_H
			jal draw_vertical_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 45
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a0, 1
			jal draw_horizontal_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 45
			li a1, NAME_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			addi a3, a0, 1
			jal draw_horizontal_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 45
			li a1, NAME_TEXT_Y
			addi a1, a1, 4
			lw a2, color_white
			addi a3, a0, 1
			jal draw_horizontal_line		
			
		# The Z
				
			li a0, NAME_TEXT_X
			addi a0, a0, 48
			li a1, NAME_TEXT_Y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 48
			li a1, NAME_TEXT_Y
			addi a1, a1, NAME_TEXT_H
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line
			
			li a0, NAME_TEXT_X
			addi a0, a0, 50
			li a1, NAME_TEXT_Y
			addi a1, a1, 1
			lw a2, color_white
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 49
			li a1, NAME_TEXT_Y
			addi a1, a1, 2
			lw a2, color_white
			jal draw_point
			
			li a0, NAME_TEXT_X
			addi a0, a0, 48
			li a1, NAME_TEXT_Y
			addi a1, a1, 3
			lw a2, color_white
			jal draw_point
			
	
			
	lw ra, 0(sp)
	addi sp, sp, 4
	
	jr ra 


draw_marco:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
		
	

	#Borde superior e inferior
		#Superior
		li a1, 0
		.loop:
		li a0, 0
		li t0, 63
		lw a2, color_grisO
		add a3, a0, t0
		jal draw_horizontal_line
		addi a1, a1, 1
		li t0, 5
		beq a1, t0, .Salir

		li a0, 0
		li t0, 63
		lw a2, color_grisO
		add a3, a0, t0
		jal draw_horizontal_line
		addi a1, a1, 1
		li t0, 5
		bne a1, t0, .loop
		.Salir:

		#Inferior
		li a1, 60
		.loop1:
		li a0, 0
		li t0, 63
		lw a2, color_grisO
		add a3, a0, t0
		jal draw_horizontal_line
		addi a1, a1, 1
		li t0, 64
		beq a1, t0, .Salir1

		li a0, 0
		li t0, 63
		lw a2, color_grisO
		add a3, a0, t0
		jal draw_horizontal_line
		addi a1, a1, 1
		li t0, 64
		bne a1, t0, .loop1
		.Salir1:
	#Borde lateral izquierdo
		li a0, 0
		.loopi:
		li a1, 5
		li t0, 54
		lw a2, color_grisO2
		add a3, a1, t0
		jal draw_vertical_line
		addi a0, a0, 1
		li t0, 9
		beq a0, t0, .Salir3

		li a1, 5
		li t0, 54
		lw a2, color_grisO2
		add a3, a1, t0
		jal draw_vertical_line
		addi a0, a0, 1
		li t0, 9
		bne a0, t0, .loopi
		.Salir3:		

		li a0, 21
		li a1, 2
		lw a2, color_gris1 
		addi a3, a0, 20
		jal draw_horizontal_line
	
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 12
	jr ra

draw_winner:

	addi sp, sp, -4
	sw ra, 0(sp)

	# Marco superior
		#Lineas horizontales
		li a0, 1									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_horizontal_line
		
		li a0, 2
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_cyan
		li a3, 61
		jal draw_horizontal_line
		
		li a0, 3
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_orange
		li a3, 60
		jal draw_horizontal_line
	
		#Lineas verticales derechas
		li a0, 1									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 7									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 2
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_cyan
		li a3, 7
		jal draw_vertical_line
		
		li a0, 3
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_orange
		li a3, 7
		jal draw_vertical_line
		
		#Lineas verticales izquierdas
		li a0, 62									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 7									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 61
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_cyan
		li a3, 7
		jal draw_vertical_line
		
		li a0, 60
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_orange
		li a3, 7
		jal draw_vertical_line
	
	# Marco inferior
		#Lineas horizontales
		li a0, 1									# a0-> coordenada en x
		li a1, 62						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_horizontal_line
		
		li a0, 2
		li a1, 61
		lw a2, color_cyan
		li a3, 61
		jal draw_horizontal_line
		
		li a0, 3
		li a1, 60
		lw a2, color_orange
		li a3, 60
		jal draw_horizontal_line
	
		#Lineas verticales derechas
		li a0, 1									# a0-> coordenada en x
		li a1, 55						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 2
		li a1, 55
		lw a2, color_cyan
		li a3, 61
		jal draw_vertical_line
		
		li a0, 3
		li a1, 55
		lw a2, color_orange
		li a3, 60
		jal draw_vertical_line
		
		#Lineas verticales izquierdas
		li a0, 62									# a0-> coordenada en x
		li a1, 55						# a1-> coordenada en y
		lw a2, color_red								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 61
		li a1, 55
		lw a2, color_cyan
		li a3, 61
		jal draw_vertical_line
		
		li a0, 60
		li a1, 55
		lw a2, color_orange
		li a3, 60
		jal draw_vertical_line
	
	# Winner text
		
		# The W
			li a0, WORD_1_x
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 4
			li a1, WORD_1_y
			lw a2, color_white
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 1 
			li a1, WORD_1_y
			addi a1, a1, 6
			lw a2, color_white 
			jal draw_point
			
			li a0, WORD_1_x
			addi a0, a0, 2
			li a1, WORD_1_y
			addi a1, a1, 5
			lw a2, color_white 
			jal draw_point
			
			li a0, WORD_1_x
			addi a0, a0, 3 
			li a1, WORD_1_y
			addi a1, a1, 6
			lw a2, color_white 
			jal draw_point
			
			
		# The I
			li a0, WORD_1_x
			addi a0, a0, 7
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 6
			li a1, WORD_1_y
			lw a2, color_white 
			jal draw_point
			
			li a0, WORD_1_x
			addi a0, a0, 8
			li a1, WORD_1_y
			lw a2, color_white 
			jal draw_point
			
			li a0, WORD_1_x
			addi a0, a0, 6
			li a1, WORD_1_y
			addi a1, a1, 6
			lw a2, color_white 
			jal draw_point
			
			li a0, WORD_1_x
			addi a0, a0, 8
			li a1, WORD_1_y
			addi a1, a1, 6
			lw a2, color_white 
			jal draw_point

		
		# The N
			li a0, WORD_1_x
			addi a0, a0, 10
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 11
			li a1, WORD_1_y
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 12
			li a1, WORD_1_y
			addi a1, a1, 2
			lw a2, color_white
			addi a3, a1, 2
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 13
			li a1, WORD_1_y
			addi a1, a1, 5
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 14
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
		
		# The N
			li a0, WORD_1_x
			addi a0, a0, 16
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 17
			li a1, WORD_1_y
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 18
			li a1, WORD_1_y
			addi a1, a1, 2
			lw a2, color_white
			addi a3, a1, 2
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 19
			li a1, WORD_1_y
			addi a1, a1, 5
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 20
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
		
			
		# The E
			li a0, WORD_1_x
			addi a0, a0, 22
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 23
			li a1, WORD_1_y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, WORD_1_x
			addi a0, a0, 23
			li a1, WORD_1_y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
			li a0, WORD_1_x
			addi a0, a0, 23
			li a1, WORD_1_y
			addi a1, a1, 6
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #abajo
			
		# The R
			li a0, WORD_1_x
			addi a0, a0, 27
			li a1, WORD_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 31
			li a1, WORD_1_y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, WORD_1_x
			addi a0, a0, 31
			li a1, WORD_1_y
			addi a1, a1, 4
			lw a2, color_white
			addi a3, a1, 2
			jal draw_vertical_line #derecha abajo
			
			li a0, WORD_1_x
			addi a0, a0, 28
			li a1, WORD_1_y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, WORD_1_x
			addi a0, a0, 28
			li a1, WORD_1_y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
		
			
	
			
	lw ra, 0(sp)
	addi sp, sp, 4
	
	jr ra 


draw_gameover:

	addi sp, sp, -4
	sw ra, 0(sp)

	# Marco superior
		#Lineas horizontales
		li a0, 1									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_gris4								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_horizontal_line
		
		li a0, 2
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_gris3
		li a3, 61
		jal draw_horizontal_line
		
		li a0, 3
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_gris2
		li a3, 60
		jal draw_horizontal_line
	
		#Lineas verticales derechas
		li a0, 1									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_gris4								# a2-> color
		li a3, 7									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 2
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_gris3
		li a3, 7
		jal draw_vertical_line
		
		li a0, 3
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_gris2
		li a3, 7
		jal draw_vertical_line
		
		#Lineas verticales izquierdas
		li a0, 62									# a0-> coordenada en x
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y						# a1-> coordenada en y
		lw a2, color_gris4								# a2-> color
		li a3, 7									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 61
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 1
		lw a2, color_gris3
		li a3, 7
		jal draw_vertical_line
		
		li a0, 60
		li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
		addi a1, a1, 2
		lw a2, color_gris2
		li a3, 7
		jal draw_vertical_line
	
	# Marco inferior
		#Lineas horizontales
		li a0, 1									# a0-> coordenada en x
		li a1, 62						# a1-> coordenada en y
		lw a2, color_gris4								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_horizontal_line
		
		li a0, 2
		li a1, 61
		lw a2, color_gris3
		li a3, 61
		jal draw_horizontal_line
		
		li a0, 3
		li a1, 60
		lw a2, color_gris2
		li a3, 60
		jal draw_horizontal_line
	
		#Lineas verticales derechas
		li a0, 1									# a0-> coordenada en x
		li a1, 55						# a1-> coordenada en y
		lw a2, color_gris4								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 2
		li a1, 55
		lw a2, color_gris3
		li a3, 61
		jal draw_vertical_line
		
		li a0, 3
		li a1, 55
		lw a2, color_gris2
		li a3, 60
		jal draw_vertical_line
		
		#Lineas verticales izquierdas
		li a0, 62									# a0-> coordenada en x
		li a1, 55						# a1-> coordenada en y
		lw a2, color_gris4								# a2-> color
		li a3, 62									# a3-> final de coordenada
		jal draw_vertical_line
		
		li a0, 61
		li a1, 55
		lw a2, color_gris3
		li a3, 61
		jal draw_vertical_line
		
		li a0, 60
		li a1, 55
		lw a2, color_gris2
		li a3, 60
		jal draw_vertical_line
	
	# Winner text
		
		# The G
			li a0, GAMEO_1_x
			li a1, GAMEO_1_y
			addi a1, a1, 1 
			lw a2, color_white 
			addi a3, a1, 4
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 4
			li a1, GAMEO_1_y
			addi a1, a1, 4
			lw a2, color_white
			addi a3, a1, 2
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 1 
			li a1, GAMEO_1_y 
			lw a2, color_white 
			addi a3, a0, 3	
			jal draw_horizontal_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 1 
			li a1, GAMEO_1_y
			addi a1, a1, 6 
			lw a2, color_white 
			addi a3, a0, 3
			jal draw_horizontal_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 2 
			li a1, GAMEO_1_y
			addi a1, a1, 3 
			lw a2, color_white 
			addi a3, a0, 2
			jal draw_horizontal_line

		# The A
			li a0, GAMEO_1_x
			addi a0, a0, 6
			li a1, GAMEO_1_y
			addi a1, a1, 1
			lw a2, color_white 
			addi a3, a1, 5
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 10
			li a1, GAMEO_1_y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 5
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 7
			li a1, GAMEO_1_y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, GAMEO_1_x
			addi a0, a0, 7
			li a1, GAMEO_1_y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba	

		# The M
			li a0, GAMEO_1_x
			addi a0, a0, 12
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 13
			li a1, GAMEO_1_y
			lw a2, color_white 
			jal draw_point
			
			li a0, GAMEO_1_x
			addi a0, a0, 14
			li a1, GAMEO_1_y
			addi a1, a1, 1 
			jal draw_point
			
			li a0, GAMEO_1_x
			addi a0, a0, 15
			li a1, GAMEO_1_y 
			lw a2, color_white 
			jal draw_point
			
			li a0, GAMEO_1_x
			addi a0, a0, 16
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line	

	# The E
			li a0, GAMEO_1_x
			addi a0, a0, 18
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 19
			li a1, GAMEO_1_y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, GAMEO_1_x
			addi a0, a0, 19
			li a1, GAMEO_1_y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
			li a0, GAMEO_1_x
			addi a0, a0, 19
			li a1, GAMEO_1_y
			addi a1, a1, 6
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #abajo	
			
	# The O
			li a0, GAMEO_1_x
			addi a0, a0, 27
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 27
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a0, 4
			jal draw_horizontal_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 27
			li a1, GAMEO_1_y
			addi a1, a1, 6
			lw a2, color_white 
			addi a3, a0, 4
			jal draw_horizontal_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 31
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line	

	# The V
			li a0, GAMEO_1_x
			addi a0, a0, 33
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 4
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 34
			li a1, GAMEO_1_y
			addi a1, a1, 5 
			lw a2, color_white 
			jal draw_point
			
			li a0, GAMEO_1_x
			addi a0, a0, 35
			li a1, GAMEO_1_y
			addi a1, a1, 6 
			jal draw_point
			
			li a0, GAMEO_1_x
			addi a0, a0, 36
			li a1, GAMEO_1_y 
			addi a1, a1, 5 
			lw a2, color_white 
			jal draw_point
			
			li a0, GAMEO_1_x
			addi a0, a0, 37
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 4
			jal draw_vertical_line	

	# The E
			li a0, GAMEO_1_x
			addi a0, a0, 39
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 40
			li a1, GAMEO_1_y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, GAMEO_1_x
			addi a0, a0, 40
			li a1, GAMEO_1_y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			
			li a0, GAMEO_1_x
			addi a0, a0, 40
			li a1, GAMEO_1_y
			addi a1, a1, 6
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #abajo	

	# The R
			li a0, GAMEO_1_x
			addi a0, a0, 44
			li a1, GAMEO_1_y
			lw a2, color_white 
			addi a3, a1, 6
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 48
			li a1, GAMEO_1_y
			addi a1, a1, 1
			lw a2, color_white
			addi a3, a1, 1
			jal draw_vertical_line
			
			li a0, GAMEO_1_x
			addi a0, a0, 48
			li a1, GAMEO_1_y
			addi a1, a1, 4
			lw a2, color_white
			addi a3, a1, 2
			jal draw_vertical_line #derecha abajo
			
			li a0, GAMEO_1_x
			addi a0, a0, 45
			li a1, GAMEO_1_y
			addi a1, a1, 3
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #medio
			
			li a0, GAMEO_1_x
			addi a0, a0, 45	
			li a1,GAMEO_1_y
			lw a2, color_white
			addi a3, a0, 2
			jal draw_horizontal_line #arriba
			

			
	lw ra, 0(sp)
	addi sp, sp, 4
	
	jr ra 



clear_key_press:
	sw zero, KEY_INPUT_ADDRESS, t0
	jr ra
	

clear_key_status:
	sw zero, KEY_STATUS_ADDRESS, t0
	jr ra


end:

j end
