# BBDDI_PRACTICA1
Repositorio de la práctica 1 de la asignatura de bases de datos I


### Diagrama Modelo Entidad - Relación

![DIAGRAMA E-R](https://github.com/pandita-IA/BBDDI_PRACTICA1/blob/main/Diagrama%20E-R.png)


#### Diseño de la base de datos

El diagrama de la base de datos se corresponde al archivo Diagrama E-R.png
El paso a tablas se corresponde al archivo Paso a tablas.png

#### Pasando los datos...

El archivo create_table.sql contiene el código sql para crear el schema y las tablas
El archivo load_data.sql contiene tanto el código de creación del schema como la carga de datos del archivo vet-scroll.csv a cada una de las correspondientes tablas

#### Ejecuciones

El archivo Consultas_sql.sql contiene las 16 consultas propuestas como ejercicio
El archivo triggers.sql contiene los 2 triggers propuestos como ejercicio
El archivo procedimientos.sql contiene 1 de los ejercicios propuestos mientras que codificacicion_1.py contiene el otro

##### Explicación de la carga de datos

La carga de datos se hizo con wizard desde mysql workbench y para ello hemos empleado código en python usando pandas. 

##### Explicación de codificacion_1.py

Este script acepta un archivo llamado prueba.csv que venga en el mismo formato que vet-scroll pero solo con las columnas de criatura y la enfermedad que esta tenga.
Se agrega a la criatura si esta no estaba en la base de datos y tenemos funciones para recuperar los indices que vayamos a necesitar.
Se elige al azar un doctor (en esta clinica se hace a piedra papel o tijera obviamente) y tomando en cuenta la hora y el día actual se le asigna la primera fecha disponible, en caso de estar ocupado se le asigna la fecha más próxima posible (cada cita hemos supuesto que dura 5 minutos porque somos eficientes y si resulta que tu doctor tiene cita hasta el año que viene pues lo siento, te toca esperar un año XD)

##### Explicación de porque existe la tabla enfermo

Hemos creado la tabla de enfermo en el caso de que surja una nueva enfermedad que no tenga un tratamiento todavía.



This dataset, along with the questions, was created by our database teacher.
