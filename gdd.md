# American Freedom: Game Design Document

---

# Tema
Libertad

---

# Título
American Freedom

---

# Índice

-   [1. Visión General del Juego](#1-visión-general-del-juego)
    -   [1.1. Género](#11-género)
-   [2. Mecánicas de Juego](#2-mecánicas-de-juego)
    -   [2.1. Navegación y Selección de Nivel](#21-navegación-y-selección-de-nivel)
    -   [2.2. Movimiento](#22-movimiento)
    -   [2.3. Combate con Armas de Fuego](#23-combate-con-armas-de-fuego)
    -   [2.4. Habilidades Activas](#24-habilidades-activas)
    -   [2.5. Consumibles](#25-consumibles)
    -   [2.6. Interacción con el Entorno](#26-interacción-con-el-entorno)
    -   [2.7. Compras en Walmart](#27-compras-en-walmart)
    -   [2.8. Coleccionables: Liberando Civiles](#28-coleccionables-liberando-civiles)
    -   [2.9. Enemigos Básicos](#29-enemigos-básicos)
    -   [2.10. Mini-Jefes](#210-mini-jefes)
    -   [2.11. Jefes Finales](#211-jefes-finales)
-   [3. Historia y Ambientación](#3-historia-y-ambientación)
    -   [3.1. Trama Principal](#31-trama-principal)
    -   [3.2. Ambiente](#32-ambiente)
    -   [3.3. Inspiraciones](#33-inspiraciones)
    -   [3.4. Protagonista: John Freedom](#34-protagonista-john-freedom)
    -   [3.5. La Alianza Anti-Estados Unidos](#35-la-alianza-anti-estados-unidos)
-   [4. Interfaz de Usuario (UI)](#4-interfaz-de-usuario-ui)
    -   [4.1. Pantalla de Selección de Nivel](#41-pantalla-de-selección-de-nivel)
    -   [4.2. Indicador de Salud](#42-indicador-de-salud)
    -   [4.3. Brújula](#43-brújula)
    -   [4.4. Selección de Armas](#44-selección-de-armas)
    -   [4.5. Consumible Activo](#45-consumible-activo)
-   [5. Controles](#5-controles)
    -   [5.1. Movimiento Básico](#51-movimiento-básico)
    -   [5.2. Interacción](#52-interacción)
    -   [5.3. Dasheo](#53-dasheo)
    -   [5.4. Disparo](#54-disparo)
-   [6. Dirección de Arte](#6-dirección-de-arte)
    -   [6.1. Diseño de Personaje: John Freedom](#61-diseño-de-personaje-john-freedom)
-   [7. Herramientas de Desarrollo](#7-herramientas-de-desarrollo)

---

# 1. Visión General del Juego

**American Freedom** es un juego de acción de perspectiva top-down que *parodia* la cultura narcisista de Estados Unidos. El jugador, encarnando a un verdadero patriota, deberá abrirse paso por distintos niveles para liberar a América de la "Alianza Anti-Estados Unidos" (AAEEUU). Para ello, contará con la ayuda de elementos icónicos del país, como potentes armas de fuego, comida chatarra, entre otros.

## 1.1. Género
**Accion/Bullet Hell**

### Inspiración de gameplay
-   *Enter the Gungeon*

---

# 2. Mecánicas de Juego

## 2.1. Navegación y Selección de Nivel
Los niveles se seleccionan desde un **mapa central**. El jugador elige qué nivel desea jugar, una vez los complete se desbloquea el final.

## 2.2. Movimiento
El jugador puede moverse en las cuatro direcciones cardinales (arriba, abajo, izquierda, derecha). Además, cuenta con la habilidad de **dashear** para esquivar proyectiles enemigos con mayor facilidad.

### Consideración de Diseño
-   **Invencibilidad durante el *dash*:** Se debe decidir si el jugador será invencible durante los *frames* del *dash*.

## 2.3. Combate con Armas de Fuego
El protagonista utiliza un arsenal de armas de fuego para enfrentar a hordas de enemigos y vencer a jefes y mini-jefes. El jugador puede equipar un **máximo de 2 armas simultáneamente**.

### Armas
El jugador solo puede llevar 2 armas a la vez durante un nivel.
Las armas tienen rango infinito y municion infinita, las balas que disparan desaparecen al impactar con un:
- Obstaculo
- Pared
- Jugador (si fue desparada por un enemigo)
- Enemigo (si fue desparada por el jugador)

### Lista de armas
-   **Minigun:** Alta cadencia de fuego, bajo daño por impacto.
-   **M60:** Cadencia de fuego moderada, daño equilibrado.
-   **Escopeta:** Alto retroceso con cada disparo, baja cadencia de fuego, alto daño por impacto.

## 2.4. Habilidades Activas
Además de las armas, el jugador dispondrá de habilidades especiales que se activan con un *cooldown*.
Solo se puede llevar una habilidad activa por nivel.

### Fuegos Artificiales
-   **Descripción:** Dispara un único proyectil con un gran radio de explosión y un daño considerable.

## 2.5. Consumibles
Objetos de un solo uso que proporcionan beneficios.

### Granadas
-   **Descripción:** Proyectil que no causa daño al impactar, sino que rebota entre los enemigos. Explota después de un tiempo, causando daño de área.
-   **Obtención:** Se pueden encontrar distribuidas por los niveles.

### Cerveza
-   **Descripción:** Restaura salud del jugador.

## 2.6. Interacción con el Entorno
El entorno del juego puede ser utilizado tácticamente, tanto para ataque como para defensa.

### Ejemplos de Interacción Ofensiva
-   **Barriles explosivos:** Al recibir daño explotan, causando daño en area
-   **Torretas:** Estructuras defensivas enemigas que pueden ser usadas

### Ejemplos de Interacción Defensiva
-   **Empujar mesas:** Objetos del escenario que pueden ser movidos para crear coberturas temporales.
-   **Bloques de hormigón/Muros parciales:** Elementos destructibles progresivamente que ofrecen cobertura limitada.

## 2.7. Walmart
Los niveles pueden tener una tienda (Walmart), donde pueden comprar usando el dinero conseguido al derrotar enemigos:

### Items Disponibles
-   **Activas:** Desbloqueo para seleccionarlo al inicio del proximo nivel.
-   **Consumibles:** Compra de unidades adicionales.
-   **Mejoras permanentes de vida:** Aumentan la salud máxima del personaje.
-   **Desbloqueo de armas:** El jugador desbloquea esa arma para poder seleccionarla al entrar al siguiente nivel

## 2.8. Coleccionables
### Civiles Encarcelados
En cada nivel, el jugador deberá encontrar y liberar a una cantidad específica de civiles retenidos por la AAEEUU.

## 2.9. Enemigos Básicos
Enemigos comunes que aparecen a lo largo de todos los *stages*. Están diseñados para ser derrotados con relativa facilidad individualmente.

### Enemigo Básico (FBI Agent)
-   **Comportamiento:** Apunta y dispara constantemente al jugador, manteniendo una distancia prudente.

## 2.10. Mini-Jefes
Encuentros con enemigos más poderosos que aparecen a mitad de los niveles. Utilizan patrones de ataque.

### R.O.B.O.T.
-   **Descripción:** Una máquina de guerra con dos ataques principales:
    -   **Carga:** Corre hacia el jugador, infligiendo daño considerable al contacto.
    -   **Disparo Cuadruple:** Realiza 4 disparos en sucesion dirigidos al jugador.

### U.F.O.
-   **Descripción:** Una nave de transporte alienígena:
    -   **Ráfaga de Balas:** Dispara una ráfaga concentrada de proyectiles hacia el jugador.
    -   **Pendiente:** Añadir más ataques para este mini-jefe.

## 2.11. Jefes Finales
Cada área culminará con un jefe final único y desafiante.

### Pendiente
Añadir a Trump

---

# 3. Historia y Ambientación
Habran muy pocas cinematicas cortas sin dialogo, para mantener la historia simple.

## 3.1. Trama Principal
Estados Unidos está siendo invadido por la "Alianza Anti-Estados Unidos" (AAEEUU). John Freedom, no puede quedarse de brazos cruzados mientras su nación es atacada, por lo que decide embarcarse en una épica aventura estadounidense para derrotar a la AAEEUU y salvar la **LIBERTAD** de su amado país.
Una vez el jugador pasa todos los niveles John Freedom muere sabiendo que libero a America de la AAEEUU.

## 3.2. Ambiente
La historia se desarrolla en la **época actual**, con una exageración absurda y cómica del narcisismo estadounidense.
Cada nivel debe demostrar lo orgullosos que son los estadounidenses de vivir en el "pais de la libertad"

## 3.3. Inspiraciones de la narrativa
-   *Broforce* (tono paródico y acción frenética)
-   *Terminator* (acción, elementos futuristas/militares)

## 3.4. Protagonista: John Freedom
-   **Nacionalidad:** Estadounidense de pura cepa.
-   **Personalidad:** Amante de las cervezas, las armas de fuego y su país.
-   **Motivación:** Odia fervientemente a la "Alianza Anti-Estados Unidos".
-   **Residencia:** Vive en una casa rodante, fiel a su estilo de vida libre.

## 3.5. La Alianza Anti-Estados Unidos
Una coalición heterogénea de personajes y facciones con el objetivo común de aniquilar a Estados Unidos y a sus ciudadanos.

### Facciones dentro de la AAEEUU
-   **Infiltrados del Servicio Secreto / FBI:** Agentes de la alianza que se han infiltrado en posiciones de poder, trabajando para corromper a la población y minar la moral.
-   **Aliens:** La alianza ha contactado con razas alienígenas que simpatizan con su causa. Al parecer, EE. UU. es el único país al que invaden constantemente.

---

# 4. Interfaz de Usuario (UI)

## 4.1. Pantalla de Selección de Nivel
Un mapa de los estados unidos, el jugador hace click en un estado y saldra por quien esta siendo atacado dicho lugar.

### Áreas (Ejemplos de Niveles)
-   **Área 51:**
    -   **Jefe Final:** UFO.
    -   **Enemigos Comunes:** Alienígenas.
-   **Washington D.C.:**
    -   **Jefe Final:** Robo-President.
    -   **Enemigos Comunes:** Robots.

## 4.2. Indicador de Salud
Línea esquina superior izquierda de la pantalla, muestra la vida actual del personaje y su vida máxima en formato numérico.
Si la salud llega a cero, el jugador pierde el nivel y debe reiniciar desde el último *checkpoint* del *stage*.

## 4.3. Brújula
Flecha azul en la esquina inferior izquierda de la pantalla, indica al jugador la dirección del próximo *checkpoint* u objetivo principal.
Su rotación cambia en tiempo real para apuntar al destino. Desaparece cuando no hay *checkpoints* disponibles (ej. durante peleas contra jefes o al final del nivel), reapareciendo al iniciar un nuevo segmento con objetivo.

## 4.4. Selección de Armas
Al inicio de cada nivel, el jugador elige qué dos armas llevará consigo en la aventura.
Las armas seleccionadas no se pueden cambiar durante el nivel. Solo se pueden modificar al terminar, salir o perder el nivel.

## 4.5. Consumible Activo
Muestra el consumible que el jugador tiene actualmente seleccionado para usar en la esquina superior derecha de la pantalla.
El jugador puede cambiar el consumible activo en cualquier momento. Si no hay consumibles disponibles, el espacio se mostrará vacío.

---

# 5. Controles

## 5.1. Movimiento Básico
-   **Moverse:** WASD
-   **Dasheo:** Barra Espaciadora

## 5.2. Interacción
-   **Tecla:** E
-   **Requisito:** El jugador debe estar cerca del objeto o personaje para activarlo.

## 5.4. Disparo
-   **Apuntar:** Movimiento del Ratón
-   **Arma Principal:** Clic Izquierdo del Ratón
-   **Arma Secundaria:** Clic Derecho del Ratón

## 5.5. Consumibles
-   **Usar Consumible:** Q
-   **Cambiar Consumible:** R

---

# 6. Dirección de Arte

El estilo visual del juego será **Pixel Art**, con la mayoría de los *assets* (armas, personajes, etc.) diseñados en una resolución de **32x32 píxeles**.

## 6.1. Diseño de Personaje: John Freedom
-   **Físico:** Musculoso.
-   **Cabello:** Pelirrojo.
-   **Vello Facial:** Bigote hasta la mandibula, sin barba.
-   **Ropa:** Camisa a cuadros sin mangas desabotonada y sin camiseta debajo. Pantalones de carga militares o de camuflaje.

---

# 7. Herramientas de Desarrollo

-   **Motor de Juego:** Godot Engine 4.4.1-stable
