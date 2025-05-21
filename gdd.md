# Tema
Libertad

# Titulo
American Freedom

# Resumen
El juego parodia a EEUU en perspectiva top-down, donde el jugador tendra que pasar por niveles para liberar a America de sus enemigos gracias a la ayuda de elementos que caracterizan a EEUU como armas de fuego y comida chatarra, todo esto protagonizado por un verdadero patriota.

#TODO Discutir Bossrush
# Mecanicas
## Genero
Bullet Hell

### Inspiracion
- Enter the gungeon

## Seleccion de niveles
Se seleccionan los niveles que el jugador quiere jugar

## Disparar
El jugador usa armas de fuego (como buen estadounidense) para hacerse paso a travez del nivel y vencer los jefes / mini-jefes
El jugador puede llevar maximo 2 armas de fuego
De momento comienza con la M60 y la Escopeta
Cada arma tiene un rango infinito?
Cada arma tiene balas infinitas?

### M60
Alta cadencia de fuego, poco daño.

### Escopeta
Tiene un retroceso con cada disparo, poca cadencia de fuego, y alto daño

## Habilidades Activas
### Fuegos Artificiales
Dispara un unico proyectil que tiene alto rango de explosion y un gran daño

## Consumibles
### Granadas
Proyectil que no hace daño al impactar, rebota entre los enemigos y al cabo de 3 segundos explota
Se puede encontrar en los niveles

### Cerveza
Cura al jugador un 25%

## Movimiento
Aparte de moverse arriba, abajo, izquiera, y derecha el jugador puede "dashear" para esquivar balas con mayor facilidad
#TODO: Decidir si es que el jugador va a recibir invencibilidad en los frames al dashear

## Jugar con el entorno
El jugador podra utilizar el entorno tanto para atacar como para defenderse

### Ejemplos
Atacar:
- Camionetas de petroleo
- Barriles Explosivos
- Torretas

#TODO: Añadir mas ejemplos para defenderse con el entorno
Defenderse:
- Empujar mesas como coberturas

## Comprar en el Walmart
Cada nivel tiene al menos una tienda, donde el jugador podria comprar diferentes items que lo ayuden, los enemigos y bosses derrotados droppean la moneda para comprar

### Items disponibles:
- Fuegos Artificiales (Desbloqueo)
- Granadas
- Cerveza
- Mejoras permanentes de vida

#TODO: Ver que añadir a la tienda. Desbloqueos de armas???

## Coleccionables
En cada nivel hay una cantidad de civiles que hay que liberar de la "Anti-Estados Unidos"

# Historia
EEUU esta siendo invadido por la alianza "Anti-Estados Unidos", nuestro protagonista John Freedom no puede quedarse quieto como destruyen a su pais, asi que decide embarcarse en una clasica epica aventura estadounidense para vencer a la "Anti-Estados Unidos" y salvar la libertad de su amado pais

## Ambiente
La historia ocurre en la epoca actual, con una exageracion absurda de lo bueno que es EEUU, todos los lados de EEUU demuestran un gran orgullo por el pais de la libertad.

#TODO: Decidir si habran dialogos o cinematicas

## Insipiraciones
- Metal Gear Rising: Revengance
- Bro Force

## Protagonista (John Freedom)
- Estadounidense
- Le gustan las cervezas, las armas, y su pais.
- Odia a la "Alianza Anti-Estados Unidos"
- Vive en una casa rodante

## Alianza Anti-Estados Unidos
Grupo de diferentes tipos de personajes que buscan la aniquilacion de Estados Unidos y su gente

### Infiltrados del Servicio Secreto / FBI
Agentes de la alianza se infiltraron en posiciones de poder para corromper a la poblacion y disminuir la moral

### Aliens
La alianza contacto con alienigenas que simpatizan con su causa, ya que es el unico pais que siempre invaden

# Interfaz
## Seleccion de Niveles
### Area 51
#### Jefe Final
- UFO
#### Enemigos
- Alien

### Washington
#### Jefe Final
- Robo-President
#### Enemigos
- Robots
#TODO: Terminar

## Salud
El jugador pierde el nivel y tiene que empezar desde el ultimo checkpoint del stage
Sera una Linea roja en la esquina superior izquiera, con un numero indicando la vida actual del personaje y su vida maxima

## Brujula
Flecha Azul
Le indica al jugador hacia donde debe ir, apunta siempre al proximo checkpoint
Esta en la esquina inferior izquierda, y cambia su rotacion dependiendo de la direccion entre el jugador y el checkpoint
Si no hay checkpoints disponibles (porque esta peleando contra un jefe o esta en el final del nivel) la brujula desaparece hasta que haya otro checkpoint

## Seleccion de Armas
Al inicio de cada nivel el jugador elige que armas llevar en su aventura, no se pueden cambiar hasta que se termine el nivel, se salga del nivel, o pierda el nivel

# Controles
## Movimiento Basico
WASD

## Interactuar
E
Necesita estar cerca del jugador para accionarlo

## Dasheo
Barra Espaciadora

## Disparo
Apuntar: Mouse
Arma Principal: Click Izquierdo
Arma Secundaria: Click Derecho

# Arte
El estilo sera de Pixel Art (32 x 32 para la mayoria de assets como armas y personajes)

## John Freedom
- Musculoso
- Pelirrojo
- Mostacho
- Sin Barba
- Camisa a cuadros sin mangas, sin Polera sin botones
- Cargo Pants Militares / Camuflaje

# Herramientas
- godot 4.4.1-stable
