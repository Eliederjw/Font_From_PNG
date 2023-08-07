extends Control
# Esse script contém exemplos de métodos manipulando os glyphs da imagem carregada
# Glyph aqui se refere à representação gráfica dos characteres (ou letras), nesse caso, os números de 0-9
# Não confundir charactere com glyph!

# Esse script vai abordar os scripts:
#	- get_glyph_list()
#	- set_glyph_size()
#	- set_glyph_offset()

#================================================

@export_category("Nodes and Resources")
# Carregue a imagen PNG com a font no node contendo esse script utilizando o Inspector
@export var font_file:FontFile
@export var font_label:Label

@export_category("All Glyphs Size")
# Altere o tamanho da font no Inspector
@export var font_size:int = 70

@export_category("Specific Glyph Size")
# Escolha um glyph específico no Inspector. Valor padrão é 55, que representa o número 7
@export_range(48, 57, 1) var specific_glyph:int = 55
# Escolha o tamanho da font no Inspector
@export var specific_font_size:int = 70

@export_category("Glyphs Kerning")
# Escolha os glyphs A e B no Inspector para terem o kerning entre eles definido
# Valores padrões, 52 e 53, corespondem aos números 2 e 3
@export_range(48, 57, 1) var glyph_A:int = 50
@export_range(48, 57, 1) var glyph_B:int = 51
# Escolha o valor do kerning no Inspector
@export var kerning:int = -50

func _ready() -> void:
	# Esse método vai alterar o tamanho de um glyph específico
	_set_specific_glyph_size()
	# Esse método vai alterar o tamanho de todos os glyphs relacionados ao font_file
	_set_all_glyphs_size()
	# Esse médoto vai gerar um valor aleatório para a posição vertical (ou "altura") de cada glyph
#	_set_random_vertical_offset()
	
	_set_A_and_B_glyphs_kerning()
	
	# Linhas para contornar um bug da Godot de não atualizar o kerning da label. 
	# Se a label estiver sendo atualizada constantemente, talvez as linhas a seguir não sejam necessarias
	font_label.uppercase = true	
	font_label.uppercase = false

# ===============================================

# MÉTODO PARA SETAR O TAMANHO DE UM GLYPH ESPECÍFICO
func _set_specific_glyph_size() -> void:
	# cache_index se refere ao índice do 'Character Ranges' definido ao fazer o import 
	var cache_index:int = 0 
	# mysterious_size se refere ao parâmetro 'size' exigido nos métodos set_glyph_*. Vai ser sempre Vector2i(1, 0). Não me pergunte porquê.
	var mysterious_size:Vector2i = Vector2i(1,0)
	# specific_glyph_size se refere ao tamanho do glyph (ou letra)
	var specific_glyph_size:Vector2 = Vector2(font_size, font_size)

	# Looping percorrendo cada glyph da imagem e alterando o tamanho com set_glyph_size
	font_file.set_glyph_size(cache_index, mysterious_size, specific_glyph, specific_glyph_size)
		
	# Printa no console os códigos ASCII d glyph específico.
	print("Specific glyph ASCII code is: "  + str(specific_glyph))
	
# ===============================================	

# MÉTODO PARA SETAR O TAMANHO DE TODOS OS GLYPHS DA IMAGEM
func _set_all_glyphs_size() -> void:
	# cache_index se refere ao índice do 'Character Ranges' definido ao fazer o import 
	var cache_index:int = 0 
	# mysterious_size se refere ao parâmetro 'size' exigido nos métodos set_glyph_*. Vai ser sempre Vector2i(1, 0). Não me pergunte porquê.
	var mysterious_size:Vector2i = Vector2i(1,0)
	# glyph_size se refere ao tamanho do glyph (ou letra)
	var glyph_size:Vector2 = Vector2(font_size, font_size) 	
	# get_glyph_list pega todos os glyphs da imagem em font_file
	var glyphs = font_file.get_glyph_list(0, Vector2(1,0))
		
	# Looping percorrendo cada glyph da imagem e alterando o tamanho com set_glyph_size
	for glyph in glyphs:
		font_file.set_glyph_size(cache_index, mysterious_size, glyph, glyph_size)
		
	# Printa no console os códigos ASCII de cada glyph.
	# Nesse caso, os números de 0-9 que correspondem às entradas 48-57 da tabela ASCII
	print("Glyphs ASCII codes are: "  + str(glyphs))

# ===============================================

# MÉTODO PARA SETAR UM OFFSET VERTICAL ALEATÓRIO EM TODOS OS GLYPHS
func _set_random_vertical_offset() -> void:	
	# cache_index se refere ao índice do 'Character Ranges' definido ao fazer o import 
	var cache_index:int = 0 
	# mysterious_size se refere ao parâmetro 'size' exigido nos métodos set_glyph_*. Vai ser sempre Vector2i(1, 0). Não me pergunte porquê.
	var mysterious_size:Vector2i = Vector2i(1,0)
	# get_glyph_list pega todos os glyphs da imagem em font_file
	var glyphs = font_file.get_glyph_list(0, Vector2(1,0))
	# Cria um seed diferente para valores aleatórios
	randomize()
	
	# Percorre todos os glyphs da imagem e seta o valor do offset
	for glyph in glyphs:	
		# Define um valor aleatório para o offset vertical do glyph
		var random_vertical_offset:int = randi_range(-60, 0)
		var glyph_offset:Vector2 = Vector2(0, random_vertical_offset)
	
		font_file.set_glyph_offset(cache_index, mysterious_size, glyph, glyph_offset)
	
# ===============================================

# METODO PARA SETAR O KERNING ENTRE DOIS GLYPHS ESPECÍFICOS
# O kerning se refere ao espaçamento entre duas letras. 
# Cada combinação de letras podem ter um kerning diferentes dentro do texto.
func _set_A_and_B_glyphs_kerning() -> void:
	# cache_index se refere ao índice do 'Character Ranges' definido ao fazer o import 
	var cache_index:int = 0 
	# mysterious_size se refere ao parâmetro 'size' exigido nos métodos set_glyph_*. Vai ser sempre Vector2i(1, 0). Não me pergunte porquê.
	var mysterious_size:int = 1
	var glyph_pair:Vector2i = Vector2i(glyph_A, glyph_B)
	font_file.set_kerning(cache_index, mysterious_size, glyph_pair, Vector2(kerning, 0))
	print(font_file.get_kerning(cache_index, mysterious_size, glyph_pair))

	
