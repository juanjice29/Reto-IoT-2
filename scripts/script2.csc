set ant 999
set ite 0  // Inicialización de la variable ite
battery set 100  // Inicialización de la batería al 100%
set temp 0

atget id id
getpos2 lonSen latSen

loop
wait 100
read mens
rdata mens tipo valor

inc ite  // Incrementa la variable ite en cada iteración
print ite

// Condición de parada al llegar a 1000 iteraciones
if (ite >= 1000)
	stop
end

// Si se recibe un mensaje "stop", el sensor detiene su actividad
if (tipo=="stop")
	data mens "stop"
	send mens * valor
	cprint "Para sensor: " id
	wait 1000
	stop
end

// Si recibe un mensaje "hola" y ant es 999, guarda el valor y lo envía
if((tipo=="hola") && (ant == 999))
   set ant valor
   data mens tipo id
   send mens * valor
end

// Si recibe una alerta, envía un mensaje usando el valor de ant
if(tipo=="alerta")
   send mens ant
end
delay 1000

// Comprobación de la batería
battery bat
if(bat < 5)
	data mens "critico" lonSen latSen
	send mens ant
end

// Lectura del sensor de temperatura y envío de alerta si es necesario
areadsensor tempSen
rdata tempSen SensTipo idSens temp

if (temp > 30)
   data mens "alerta" lonSen latSen
   send mens ant
end
