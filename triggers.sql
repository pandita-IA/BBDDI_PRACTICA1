use Clinic;

# TRIGGERS

# Evitar la asignación de una cita a un miembro del personal si ya tiene una cita programada para la misma fecha y hora.
DELIMITER //
create trigger no_cita_si_ya_esta_ocupado before insert on cita
for each row
begin
	if (select count(*) from cita ci where ci.fecha_y_hora = NEW.fecha_y_hora) > 0
		then 
        SIGNAL SQLSTATE '02000'
        set message_text = 'El personal se encuentra ocupado a esta hora';
    end if;
	
end //
delimiter ;


# Evitar que se pueda eliminar un tratamiento si hay alguna cita programada que lo incluya.
DELIMITER //
create trigger tratamiento_eliminacion_todas_las_citas before delete on Tratamiento
for each row
begin
	if (select count(*) from cita where id_tratamiento = OLD.id_tratamiento) > 0
		then 
        SIGNAL SQLSTATE '02001'
        set message_text = 'Este tratamiento todavía sigue asociado a diversas citas, por favor elimine las citas antes de eliminar el tratamiento';
    end if;    
end //
delimiter ;

select *
from Tratamiento;

delete from Tratamiento where id_tratamiento = 1;

select * from cita;

insert into cita
values (2, 1, '9671-12-26 13:44:00', 1)
