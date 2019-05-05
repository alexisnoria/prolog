%Esta línea es para abrir el archivo en OS X.
%consult('/Users/fernando2/Github/SistemaExperto/sistemaexpertocelulars.pl').

/*
        Sistema experto para escoger un celular basado en las necesidades del usuario.
        Basado en el sistema 
         https://github.com/mbobadilla2/SistemaExperto
*/


:- write('Iniciar con "comprar".').
%Predicado final que imprime el resultado.
comprar:- celular(Marca, Modelo, Tipo, Precio, Pantalla, HDD, NombreImg),
        write('El celular que deberia elegir es: '),
        nl,
        write('Marca: '), write(Marca),
        nl,
        write('Modelo: '),write(Modelo),
        nl,
        write('Sistema: '),write(Tipo),
        nl,
        write('Precio: $'),write(Precio),
        nl,
        write('Pantalla (en pulgadas): '),write(Pantalla),
        nl,
        write('Almacenamiento: '),write(HDD),
        nl,
       
        %Muestra la imagen de la celular escogida.
        atom_concat('imagenes/', NombreImg, RutaModelo),
        atom_concat(RutaModelo, '.jpg', RutaModeloExtension),
        new(Img, picture(Modelo)),
        send(Img, width(400)),
        send(Img, height(400)),
        send(Img, open),
        send(Img, display, new(_, bitmap(RutaModeloExtension))),
        limpiaBC.
%Si ninguna celular cumple los requerimientos, mostramos este mensaje :(
comprar:-
        write('Lo sentimos. No contamos con un producto con esas caracteristicas'),
        nl,
        limpiaBC.

%Hipótesis.
%Estructura: Marca, Modelo, Tipo, Precio, Pantalla, HDD

%El ! al final indica un corte. Esto es para que una vez que se llegó al resultado correcto, no se sigan evaluando otras hipótesis.

%Android
celular('Huawei',    'P30 Pro',     'Android',   '20,000',  '6.47"',  '256GB',  'p30pro') :-    p30pro, !.
celular('Samsung',   'S10+',        'Android',   '20,999',  '6.4"',   '128GB',  's10')    :-    s10, !.
celular('Xiaomi',    'MI 9',        'Android',   '12,999',  '6.39"',  '128GB',  'mi9')    :-    xiaomi, !.
celular('Motorola',  'Moto G7',     'Android',   '5,900',   '6,24"',  '64GB',  'motog7') :-    motog7, !.
celular('Samsung',   'J4+',         'Android',   '3,199',   '6"',  '32GB',  'j4') :-    j4, !.

%celular('No se encontro un producto que cubra sus necesidades', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A').
%IOS
celular('Apple',   'Iphone XS MAX',        'IOS',   '30,699',  '6.5"',   '256GB',  'xsmax')    :-    xsMax, !.
celular('Apple',   'Iphone 8 PLUS',        'IOS',   '16,999',  '5.5"',   '64GB',  '8plus')    :-    ochoplus, !.
celular('Apple',   'Iphone 7 PLUS',        'IOS',   '13,999',  '5.5"',   '32GB',  '7plus')    :-    sieteplus, !.

%Reglas que identifican a cada celular (Se deben poner cosas que diferencíen a un modelo del resto).
%Las que no llevan paréntesis son reglas de clasificación.

%%%%%%%%%%%%%%%%%%%%Iphones

xsMax:-                 ios,
                        ram4,
                        almacenamiento256,
                        ultraCaro.

ochoplus:-              ios,
                        ram3,
                        almacenamiento64,
                        medio.

sieteplus:-             ios,
                        ram3,
                        almacenamiento32,
                        medio.

%%%%%%%%%%%%%%%%%%%%Androids

xiaomi:-                android,
                        ram6,
                        almacenamiento64,
                        medio.

s10:-                   android,
                        ram8,
                        almacenamiento128,
                        muyCaro.

p30pro:-                android,
                        ram8,
                        almacenamiento256,
                        muyCaro.

motog7:-                android,
                        ram4,
                        almacenamiento64,
                        economico.

j4:-                    android,
                        ram2,
                        almacenamiento32,
                        muyEconomico.


%Reglas de clasificación (son como características genéricas que pueden tener varios modelos).
%Se puede poner varias veces la misma regla con distinto parámetro en verifica().
%Se puede poner mas de una condición en cada regla, separándolas por comas.
%escritorio:-                   verifica('debe ser de escritorio').



android:-                               verifica('debe ser un Android').
ios:-                                   verifica('debe ser un Iphone').

muyEconomico:-                          verifica('debe ser un equipo muy economico ($4,000 o menos)').
economico:-                             verifica('debe ser un equipo economico ($6,000 o menos)').
medio:-	                                verifica('puede costar entre $9,000 y $17,000 pesos').
caro:-                                  verifica('puede costar más de $16,000 pesos').
muyCaro:-                               verifica('puede costar más de $20,000 pesos').
ultraCaro:-                             verifica('puede costar más de $30,000 pesos').


almacenamiento256:-                     verifica('debe tener un almacenamiento de 256gb').
almacenamiento128:-                     verifica('debe tener un almacenamiento de 128gb').
almacenamiento64:-                      verifica('debe tener un almacenamiento de 64gb').
almacenamiento32:-                      verifica('debe tener un almacenamiento de 32gb').



ram8:-                                  verifica('debe tener al menos 8GB de RAM').
ram6:-                                  verifica('debe tener al menos 6GB de RAM').
ram4:-                                  verifica('debe tener al menos 4GB de RAM').
ram3:-                                  verifica('debe tener al menos 3GB de RAM').
ram2:-                                  verifica('debe tener al menos 2GB de RAM').


%Preguntas al usuario.
pregunta(Caracteristica):-
        write('El celular que busca '),
        write(Caracteristica),
        write('? '),
        read(Respuesta),
        nl,
        ( (Respuesta == si ; Respuesta == s)
                ->
                        assert(si(Caracteristica));
                        assert(no(Caracteristica)), fail).

:- dynamic si/1, no/1.

%Verificar si algo es cierto.
verifica(R):-(si(R) -> true; (no(R) -> fail; pregunta(R))).


%Limpiar la base de conocimientos.
limpiaBC:- retract(si(_)), fail.
limpiaBC:- retract(no(_)), fail.
limpiaBC.
