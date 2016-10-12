#!/bin/bash
#--------------------------------------------------
# Nombre: Automatizador de Backup de Aplicaciones
# Autor:  José Alejandro Gago @jalejandrogago
# Fecha:  03-02-2013
#--------------------------------------------------
# Testeado en Debian 6
# Para el sistema Operativo Debian Gnu/Linux
# y Distribucion terciarias como: Ubuntu, Kubuntu.
#--------------------------------------------------

clear

function FunArgs() {

	if [ ${#args[@]} = 0 ]; then 

	    FunMenu

	elif [ ${args[0]} = "-b" ]; then

	    FunBackup

        elif [ ${args[0]} = "-r" -a -s ${args[1]} ]; then

            FunRestore ${args[1]}

        else
            clear
            echo -e "\n\n - Usted ha digitado mal los parámetros \n\n - A continuación se listan las opciones de uso . . .\n\n"
            sleep 5
            FunMenu

	fi	
}

function FunMenu {
clear
echo -e "\n\n* Descripción:

  Este shell script permite realizar un archivo backup de todas las aplicaciones que están en el sistema actualmente, también permite restaurar el backup en la misma maquina u otra con el mismo sistema operativo, arquitectura y versión.

* Uso: 

./bash.sh -h               Muestra información y ayuda sobre el uso del script.
./bash.sh -b               Realiza el Backup de aplicaciones del sistema.
./bash.sh -r [path]        Restaura desde el Backup las aplicaciones.

* Developer: José Alejandro Gago.

* Blog: http://gagonotes.blogspot.com \n\n"
	
}
 
function FunBackup() {

        folder=Backup_Log
        mkdir $folder

	if [ -d $folder ]; then

	   cd $folder
	   tiempo=`date +H-%H%M%S_F-%d%m%Y`
	   dpkg --get-selections > Backup_$tiempo.log

           if [ -s Backup_$tiempo.log ]; then

	       clear
	       echo -e "\n\n- Backup creado con éxito en $folder/Backup_$tiempo.log\n\n- A continuación se listan las aplicaciones . . .\n\n"
	       sleep 5

	       while read linea 
	       do 
		 sleep 0.01
		 echo -e "$linea\n"
	       done < Backup_$tiempo.log
           else

               clear
               echo -e "\n\n- Hubo un error el log Backup_$tiempo.log no se pudo crear.\n\n"
               sleep 5

          fi
       else

	   clear
           echo -e "\n\n- Hubo un error, el directorio ${folder} no se pudo crear.\n\n"
           sleep 5

       fi
}

function FunRestore() {
clear
echo -e "\n\n [+] Se procederá ha restaurar el Backup: " $1"\n\n" 

sudo apt-get update
sudo apt-get dist-upgrade
sudo dpkg --set-selections < $1
sudo apt-get install dselect
sudo dselect install

}

#--------------------------------------------------
# main
#--------------------------------------------------

args=("$@")

FunArgs $args 

exit
