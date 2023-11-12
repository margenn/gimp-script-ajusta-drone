(script-fu-register
	"script-fu-ajusta-cores"                                           ;function name
	"Ajusta Cores"                                                     ;menu label
	"Ajusta as cores das imagens que estiverem na pasta designada"     ;description
	"Marcelo Gennari"                                                  ;author
	"Marcelo Gennari"                                                  ;copyright notice
	"2023-11-12"                                                       ;date created
	""                                                                 ;image type that the script works on
	SF-DIRNAME "Pasta Entrada" "/home/ma/Desktop"
	SF-DIRNAME "Pasta Saida"   "/home/ma/Desktop"
)

(script-fu-menu-register "script-fu-ajusta-cores" "<Image>/File/Batch")

(define (script-fu-ajusta-cores direntrada dirsaida)        ; define o script com os dois parametros que sao as pastas de entrada e saida
	(set! direntrada (string-append direntrada "/*.JPG"))     ; define o pattern de procura, ou seja todos os arquivos .jpg
	(let* ((filelist (cadr (file-glob direntrada 1))))        ; define a lista de arquivos a serem tratados
		(while (not (null? filelist))                           ; loopa os arquivos
			(let*
				(
					(arquivoentrada (car filelist)) ; car retorna o primeiro elemento da lista
					(image (car (gimp-file-load RUN-NONINTERACTIVE arquivoentrada arquivoentrada)))
					(drawable (car (gimp-image-get-active-layer image)))
					(imageshortname (car (reverse (strbreakup arquivoentrada "/")))) ; extrai somente o nome do arquivo
					(arquivosaida (string-append (string-append dirsaida "/") imageshortname))
				)
				; inicio das alteracoes na imagem
				(plug-in-normalize RUN-NONINTERACTIVE image drawable)
				(plug-in-color-enhance RUN-NONINTERACTIVE image drawable)
				;(gimp-drawable-curves-spline drawable HISTOGRAM-VALUE 8 #(0 0  1 51  55 63  255 255))
				; fim das alteracoes na imagem
				(gimp-file-save RUN-NONINTERACTIVE image drawable arquivosaida arquivosaida)
				(gimp-image-delete image)
			)
			(set! filelist (cdr filelist)) ;cdr retorna a lista sem o primeiro elemento
		)
	)
)


