# Curso Básico de Programación en Bash

Curso introductorio diseñado para enseñar los fundamentos de programación utilizando Bash como lenguaje principal.

Este curso está orientado a principiantes sin experiencia previa en programación y tiene como objetivo desarrollar pensamiento lógico, comprensión de estructuras de control y capacidad para resolver problemas mediante scripts en entornos Linux.

---

## Objetivo del Curso

El curso tiene como finalidad:

- Introducir los fundamentos de programación.
- Enseñar el uso de Bash como herramienta de automatización.
- Comprender estructuras de control y flujo lógico.
- Implementar algoritmos clásicos de ordenamiento.
- Desarrollar pensamiento computacional desde cero.
- Fomentar buenas prácticas en scripting.

---

## Público Objetivo

- Personas sin experiencia en programación.
- Estudiantes de secundaria o nivel inicial universitario.
- Profesionales técnicos que desean automatizar tareas en Linux.
- Interesados en DevOps, redes o administración de sistemas.

---

## Requisitos Previos

- Conocimientos básicos de uso de terminal.
- Sistema operativo Linux o Windows con WSL.
- Bash instalado (incluido en la mayoría de distribuciones Linux).

Verificar versión:

```bash
bash --version
```

---

## Estructura del Curso

### Módulo 1 – Introducción a Bash

- Qué es Bash.
- Qué es un script.
- Cómo crear un archivo `.sh`.
- Permisos de ejecución.
- Ejecución de scripts.

Ejemplo básico:

```bash
#!/bin/bash
echo "Hola mundo"
```

---

### Módulo 2 – Entrada y Salida

- Comando `echo`
- Comando `printf`
- Lectura de datos con `read`

Ejemplo:

```bash
read -p "Ingresa tu nombre: " nombre
echo "Hola $nombre"
```

---

### Módulo 3 – Variables y Tipos de Datos

- Variables en Bash
- Variables numéricas
- Operaciones aritméticas
- Uso de `expr` y `$(( ))`

Ejemplo:

```bash
a=5
b=3
resultado=$((a + b))
echo $resultado
```

---

### Módulo 4 – Estructuras Condicionales

#### if

```bash
if [ $edad -ge 18 ]; then
    echo "Eres mayor de edad"
else
    echo "Eres menor de edad"
fi
```

#### case

```bash
case $opcion in
    1) echo "Elegiste opción 1" ;;
    2) echo "Elegiste opción 2" ;;
    *) echo "Opción inválida" ;;
esac
```

---

### Módulo 5 – Bucles

#### for

```bash
for i in {1..5}; do
    echo $i
done
```

#### while

```bash
contador=1
while [ $contador -le 5 ]; do
    echo $contador
    contador=$((contador + 1))
done
```

---

## Algoritmos de Ordenamiento en Bash

Uno de los pilares del curso es la implementación manual de algoritmos clásicos para desarrollar lógica y comprensión estructural.

---

### 1. Método Burbuja (Bubble Sort)

Concepto: Comparar elementos adyacentes e intercambiarlos si están en el orden incorrecto.

Complejidad: O(n²)

Ejemplo simplificado:

```bash
for ((i=0; i<n; i++)); do
  for ((j=0; j<n-i-1; j++)); do
    if [ ${arr[j]} -gt ${arr[j+1]} ]; then
      temp=${arr[j]}
      arr[j]=${arr[j+1]}
      arr[j+1]=$temp
    fi
  done
done
```

---

### 2. Método de Inserción (Insertion Sort)

Concepto: Construye la lista ordenada insertando cada elemento en su posición correcta.

Complejidad: O(n²)

---

### 3. Método de Selección (Selection Sort)

Concepto: Selecciona el menor elemento y lo coloca en su posición correcta en cada iteración.

Complejidad: O(n²)

---

### 4. Radix Sort

Concepto: Ordenamiento no comparativo basado en los dígitos de los números.

Complejidad: O(nk)

Nota: En Bash su implementación es más compleja debido a la manipulación de cadenas y arreglos.

---

## Metodología de Enseñanza

- Enfoque práctico.
- Scripts desarrollados paso a paso.
- Retos progresivos.
- Mini juegos de lógica.
- Competencias entre alumnos.
- Explicación conceptual antes de implementación.

---

## Competencias Desarrolladas

- Pensamiento lógico
- Análisis de problemas
- Uso eficiente de terminal
- Automatización básica
- Comprensión de algoritmos clásicos
- Depuración de errores

---

## Ejecución de los Scripts

1. Crear archivo:

```bash
nano script.sh
```

2. Dar permisos:

```bash
chmod +x script.sh
```

3. Ejecutar:

```bash
./script.sh
```

---

## Buenas Prácticas Enseñadas

- Uso correcto del shebang `#!/bin/bash`
- Indentación consistente
- Comentarios claros
- Validación de entradas
- Evitar código redundante
- Uso de funciones para modularidad

---

## Proyecto Final del Curso

El curso puede culminar con un proyecto que incluya:

- Menú interactivo
- Uso de `case`
- Uso de bucles
- Validación de entradas
- Implementación de al menos un algoritmo de ordenamiento
- Manejo de arreglos

---

## Limitaciones de Bash como Lenguaje

- No está diseñado para aplicaciones complejas.
- Manejo limitado de estructuras avanzadas.
- No es óptimo para grandes volúmenes de datos.
- Es ideal para scripting y automatización.

---

## Evolución Natural Después del Curso

Este curso prepara al alumno para:

- Python
- Automatización DevOps
- Administración de sistemas Linux
- Desarrollo backend básico
- Fundamentos de estructuras de datos

---

## Autor

Curso desarrollado por Ulises Amezcua.

---

## Licencia

Material educativo de uso libre para enseñanza y formación técnica.