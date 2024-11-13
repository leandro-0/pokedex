# Pokédex App

## Descripción del Proyecto

Esta aplicación de Pokédex ofrece una experiencia interactiva y detallada para los entusiastas de Pokémon, proporcionando información exhaustiva sobre diferentes especies. Utiliza datos de la PokéAPI a través de consultas GraphQL para asegurar eficiencia y rapidez en la obtención de información. Los usuarios pueden explorar estadísticas, habilidades y detalles específicos de cada Pokémon, como tipos, peso, altura y evolución.

## Funcionalidades Principales

- **Pantalla de lista de Pokémon**: Una vista de desplazamiento con imágenes y nombres de Pokémon.
- **Pantalla de detalles del Pokémon**: Muestra información detallada, incluidas estadísticas, tipo, peso y altura.
- **Estadísticas de combate**: Desglose de los valores de HP, ataque, defensa, velocidad, etc.
- **Búsqueda Avanzada**: Encuentra rápidamente Pokémon específicos utilizando la función de búsqueda por nombre, facilitando el acceso directo a la información deseada.

## Tecnologías Utilizadas

- **Flutter**: Framework principal para desarrollar la aplicación.
- **GraphQL**: Protocolo para interactuar eficientemente con la PokéAPI.
- **PokéAPI**: Fuente de datos para obtener información sobre Pokémon.

## Configuración e Instalación

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/leandro-0/pokedex.git
   cd pokedex
   
2. Instalar dependencias de Flutter:
   
   ```bash
   flutter pub get
3. Ejecutar la aplicación:

   ```bash
   flutter run
## Uso de la API GraphQL

La aplicación utiliza diversas consultas GraphQL para interactuar de manera eficiente con la PokéAPI y obtener información detallada sobre los Pokémon. A continuación se presentan todas las consultas utilizadas con su respectiva explicación:

### Obtener detalles de un Pokémon
Esta consulta obtiene información detallada de un Pokémon específico, incluyendo su ID, nombre, tipos, altura, peso y estadísticas.

    ```sql
   
      query GetPokemonDetails($name: String!) {
        pokemon(name: $name) {
          id
          name
          types {
            type {
              name
            }
          }
          height
          weight
          stats {
            base_stat
            stat {
              name
            }
          }
        }
      }

### Obtener lista de Pokémon
Esta consulta obtiene una lista de Pokémon con sus nombres e imágenes, permitiendo la paginación mediante los parámetros limit y offset.

    ```sql
   
      query GetPokemonList($limit: Int!, $offset: Int!) {
        pokemons(limit: $limit, offset: $offset) {
          results {
            name
            image
          }
        }
      }

### Obtener habilidades de un Pokémon
Esta consulta obtiene las habilidades que posee un Pokémon específico.

    ```sql
    
    query GetPokemonAbilities($name: String!) {
     pokemon(name: $name) {
       abilities {
         ability {
           name
         }
       }
     }
    }


### Obtener movimientos de un Pokémon

    ```sql
    
    query GetPokemonMoves($name: String!) {
        pokemon(name: $name) {
          moves {
            move {
              name
            }
          }
        }
     }

### Obtener cadena evolutiva de un Pokémon

    ```sql
    
    query GetPokemonEvolution($id: Int!) {
      species: pokemon_v2_pokemonspecies_by_pk(id: $id) {
        evolutionChain: pokemon_v2_evolutionchain {
          species: pokemon_v2_pokemonspecies {
            id
            name
          }
        }
      }
    }
    
### Obtener estadísticas de un Pokémon

    ```sql
    
    query GetPokemonStats($name: String!) {
      pokemon(name: $name) {
        stats {
          base_stat
          effort
          stat {
            name
          }
        }
      }
    }

### Obtener tipo(s) de un Pokémon

    ```sql
    
    query GetPokemonTypes($name: String!) {
     pokemon(name: $name) {
       types {
         type {
           name
         }
       }
     }
    } 
### Obtener descripciones de una especie de Pokémon

    ```sql

    query GetPokemonSpecies($name: String!) {
     species(name: $name) {
       flavor_text_entries {
         flavor_text
         language {
           name
         }
       }
     }
    }

## Decisiones de Diseño
## Componentes de Flutter:

La aplicación Pokédex está compuesta por varias pantallas clave, cada una diseñada cuidadosamente utilizando componentes de Flutter para ofrecer una experiencia de usuario intuitiva y atractiva. A continuación se detallan todas las pantallas y los componentes utilizados:

# Pokédex App

## 1. Pantalla de Lista de Pokémon
**Descripción**: Presenta una lista desplazable de Pokémon con sus imágenes y nombres, permitiendo al usuario explorar y seleccionar un Pokémon para ver más detalles.

**Componentes Utilizados**:
- `Scaffold`: Estructura básica de la pantalla.
- `AppBar`: Barra superior con el título y opciones de navegación.
- `GridView.builder`: Crea una cuadrícula desplazable que muestra los Pokémon en un formato de tarjetas.
- `Card`: Envuelve cada elemento de la cuadrícula para darles un aspecto de tarjeta.
- `CachedNetworkImage`: Carga y almacena en caché las imágenes de los Pokémon para mejorar el rendimiento.
- `GestureDetector` o `InkWell`: Detecta toques en cada tarjeta para navegar a la pantalla de detalles.
- `FutureBuilder`: Maneja y muestra datos asincrónicos obtenidos de la API.

## 2. Pantalla de Detalles del Pokémon
**Descripción**: Muestra información detallada del Pokémon seleccionado, incluyendo su imagen, tipos, estadísticas, habilidades y movimientos.

**Componentes Utilizados**:
- `Scaffold` con `AppBar` personalizado: Incluye el nombre del Pokémon y un botón de regreso.
- `SingleChildScrollView`: Permite el desplazamiento vertical del contenido cuando excede la pantalla.
- `Column`: Organiza los elementos principales verticalmente.
- `Row` y `Wrap`: Distribuyen elementos horizontalmente y se ajustan automáticamente al espacio disponible.
- `Image`: Muestra la imagen del Pokémon.
- `Chip`: Representa visualmente los tipos y habilidades con etiquetas estilizadas.
- `TabBar` y `TabBarView`: Implementa pestañas para navegar entre secciones como "Estadísticas", "Movimientos" y "Evolución".
- `StatBar` (Widget Personalizado): Visualiza las estadísticas del Pokémon con barras de progreso y colores representativos.
- `CircularProgressIndicator`: Indica la carga de datos mientras se esperan las respuestas de la API.

## 3. Pantalla de Estadísticas
**Descripción**: Detalla las estadísticas de combate del Pokémon, como HP, ataque, defensa, velocidad, etc.

**Componentes Utilizados**:
- `ListView`: Permite el desplazamiento vertical de las estadísticas.
- `ListTile`: Muestra cada estadística con su nombre y valor.
- `LinearProgressIndicator`: Visualiza las estadísticas como barras de progreso horizontales.
- `Padding` y `SizedBox`: Ajustan el espaciado y diseño entre los elementos.

## 4. Pantalla de Movimientos
**Descripción**: Lista todos los movimientos que el Pokémon puede aprender, proporcionando información adicional sobre cada uno.

**Componentes Utilizados**:
- `ListView.builder`: Crea una lista optimizada y desplazable de movimientos.
- `ExpansionPanelList` y `ExpansionPanel`: Permite expandir cada movimiento para mostrar detalles adicionales.
- `Text`: Muestra el nombre y las características de cada movimiento.
- `Icon`: Representa el tipo de movimiento con iconografías específicas.

## 5. Pantalla de Evolución
**Descripción**: Muestra la cadena evolutiva del Pokémon, permitiendo al usuario entender cómo evoluciona y acceder a detalles de sus evoluciones.

**Componentes Utilizados**:
- `Row` y `Column`: Organizan las etapas evolutivas horizontal y verticalmente.
- `Image`: Muestra las imágenes de cada forma evolutiva.
- `TextButton` o `GestureDetector`: Permite al usuario tocar una forma evolutiva para navegar a sus detalles.
- `Divider` y `Icon` (e.g., flechas): Visualizan la progresión entre etapas evolutivas.

## 6. Pantalla de Habilidades
**Descripción**: Presenta las habilidades del Pokémon con descripciones detalladas.

**Componentes Utilizados**:
- `ListView`: Lista de habilidades desplazable.
- `Card` o `Container` con estilos: Destaca cada habilidad.
- `Text`: Muestra el nombre y la descripción de la habilidad.
- `Icon`: Puede representar visualmente el efecto o categoría de la habilidad.

## 7. Pantalla de Búsqueda
**Descripción**: Permite a los usuarios buscar Pokémon por nombre o número, facilitando el acceso directo a un Pokémon específico.

**Componentes Utilizados**:
- `AppBar` con `TextField`: Campo de búsqueda integrado en la barra superior.
- `IconButton`: Botón para iniciar la búsqueda o limpiar el campo.
- `ListView`: Muestra los resultados de búsqueda en tiempo real.
- `StreamBuilder` o `FutureBuilder`: Gestiona las entradas de búsqueda y actualiza los resultados dinámicamente.

## App flow

![Flow](flow.png)

## Avances y Mejoras Futuras

- Implementación de Favoritos: Permitir a los usuarios marcar Pokémon como favoritos.

## Créditos y Contribuciones

Proyecto desarrollado por Leandro y Steven
