# Automatizar el proceso de registro de una nueva criatura en la base de datos y asignarle un primer tratamiento, incluyendo la creación de su primera cita.
import pandas as pd
import datetime
import random
import mysql.connector

def indice_usuario(nombre_criatura, sexo, especie):
    
    cursor.execute(f"SELECT * from Criatura where nombre_criatura = '{nombre_criatura}' and sexo = '{sexo}' and especie = '{especie}'")
    resultado_criatura = cursor.fetchall()
    if len(resultado_criatura) > 0:
        return resultado_criatura[0][0] # Devolvemos el id de la criatura
    else:
        try:
            cursor.execute(f"INSERT INTO Criatura (nombre_criatura, sexo, especie) VALUES ('{nombre_criatura}', '{sexo}', '{especie}')")
            conexion.commit()
            return indice_usuario(nombre_criatura, sexo, especie)
        except Exception as e:
            print("Error al insertar la criatura:", e)
            return None
        
        

def indice_tratamiento(nombre_tratamiento, descripción_tratamiento = '', id_enfermedad = 0):
    
    cursor.execute(f"SELECT * from Tratamiento where nombre_tratamiento = '{nombre_tratamiento}'")
    resultado_criatura = cursor.fetchall()
    if len(resultado_criatura) > 0:
        return resultado_criatura[0][0] # Devolvemos el id de la criatura
    else:
        try:
            cursor.execute(f"INSERT INTO Tratamiento (nombre_tratamiento, descripcion_tratamiento, id_enfermedad) VALUES ('{nombre_tratamiento}', '{descripción_tratamiento}', '{id_enfermedad}')")
            conexion.commit()
            return indice_tratamiento(nombre_tratamiento, descripción_tratamiento, id_enfermedad)
        except Exception as e:
            print("Error al insertar la criatura:", e)
            return None
        

def indice_enfermedad(nombre_enfermedad):
    
    cursor.execute(f"SELECT * from Enfermedad where nombre_enfermedad = '{nombre_enfermedad}'")
    resultado_criatura = cursor.fetchall()
    if len(resultado_criatura) > 0:
        return resultado_criatura[0][0] # Devolvemos el id de la criatura
    else:
        try:
            cursor.execute(f"INSERT INTO Enfermedad (nombre_enfermedad) VALUES ('{nombre_enfermedad}')")
            conexion.commit()
            return indice_tratamiento(nombre_enfermedad)
        except Exception as e:
            print("Error al insertar la criatura:", e)
            return None
        


def get_tratamiento(id_enfermedad):
    cursor.execute(f"select id_tratamiento from Tratamiento where id_enfermedad = {id_enfermedad}")
    res = cursor.fetchall()
    if len(res) > 0:
        return res[0][0]
    else:
        return indice_tratamiento(nombre_tratamiento='No hay pa ti', descripción_tratamiento = 'Mala suerte muchacho, todavía no hay tratamientoo para tu enfermedad', id_enfermedad=id_enfermedad)



def cita(id_usuario, id_tratamiento, fecha_actual=None):
    if fecha_actual is None:
        fecha_actual = datetime.datetime.now()
    
    # Genera un intervalo de 5 minutos para reprogramar la cita si ya está ocupada
    intervalo = datetime.timedelta(minutes=5)

    fecha_y_hora = fecha_actual.strftime('%Y-%m-%d %H:%M') + ":00"

    cursor.execute("SELECT id_personal FROM Personal")
    id_personal = random.choice(cursor.fetchall())[0]

    cursor.execute("SELECT COUNT(*) FROM cita WHERE id_personal = %s AND fecha_y_hora = %s", (id_personal, fecha_y_hora))

    try:
        cursor.execute("INSERT INTO cita (id_criatura, id_personal, id_tratamiento, fecha_y_hora) VALUES (%s, %s, %s, %s)", (id_usuario, id_personal, id_tratamiento, fecha_y_hora))
        print(f'Cita agregada a las {fecha_y_hora}')
        return cursor
    except Exception as e:
        print(e)
        # Reprograma la cita si ya está ocupada
        print('Reprogramando cita')
        nueva_fecha = fecha_actual + intervalo
        return cita(id_usuario, id_tratamiento, fecha_actual=nueva_fecha)



df = pd.read_csv('./prueba.csv',  delimiter=';')


conexion = mysql.connector.connect(
    host="localhost",
    user="root",
    database="Clinic"
)

cursor = conexion.cursor(buffered=True)

for index, row in df.iterrows():
    id_enfermedad = indice_enfermedad(row['enfermedad'])
    id_tratamiento = get_tratamiento(id_enfermedad)
    id_criatura = indice_usuario('nombre_criatura', row['sexo'], row['especie'])
    conexion.commit()
    cita(id_criatura, id_tratamiento)
    conexion.commit()
cursor.close()
conexion.close()    