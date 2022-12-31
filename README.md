# Reportería Solicitudes de Modificación de Presupuesto

Esta documentación explica cómo utilizar e instalar el sistema de reportería desarrollado durante los meses de Noviembre y Diciembre para la DIRPLAN. 

Se divide en dos secciones: 
- **Guía de Usuario**: dedicada a los analistas, contiene información necesaria para el ingreso de datos, generación de reportes, etc.
- **Guía Técnica de Instalación**: explica al usuario técnico informático cómo configurar y administrar el ambiente para ejecutar el sistema. 

## Guía de Usuario 

Para complementar esta guía, se recomienda ver este [video](https://drive.google.com/file/d/1WHZ6JCi0fxejuAg6MF3JqlgZiM_THYfx/view?usp=share_link), donde se explica a los usuarios cómo utilizar el sistema.  

## Ingreso de datos: Excel Decretos

## Procesos ETL

## Reporte solicitudes por etapa

## Guía técnica de instalación 

### Software y Licencias Requeridas
- **Pentaho Data Integration** (Community Edition)
  
  version 9.3
  general availability release 9.3.0.0-428
  build date: abril 12, 2022
  
  Licencia open source gratuita, no se requiere adquirir licencia pagada.
    - [GNU Library General Public License, version 2.0](https://www.gnu.org/licenses/old-licenses/lgpl-2.0.en.html)
    - [GNU General Public License, version 2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
    - [Mozilla Public License Version 1.1](https://www.mozilla.org/en-US/MPL/1.1/)
    
- **Microsoft Power BI Desktop** (Community)
  
  Versión: 2.110.1161.0 64-bit (octubre de 2022)
  Se utilizó la Licencia gratuita, sin embargo ésta licencia impide la publicación de reportes de manera privada en la web, haciéndolos forzosamente públicos y accesibles por usuarios no autorizados.
  
  Una forma de evitar este problema sin tener que adquirir una licencia pagada es instalar Power BI Desktop con licencia gratuita en cada uno de los PC de los usuarios que verán los reportes, y publicar el archivo del panel (formato pbix) en una carpeta compartida. 
  
  No obstante, si se quiere publicar reportes de manera privada en la web con otros usuarios, se deberá adquirir una licencia.   
  [Aquí](https://learn.microsoft.com/en-us/power-bi/consumer/end-user-license) está la explicación de los tipos de licencia ofrecidos para Microsoft Power BI (en inglés).
  
- **MySQL** 
  
  Version 8.0.31 for Win64 on x86_64 (MySQL Community Server - GPL)
  [Community License](https://www.mysql.com/products/community/)
  
    
### Configuración del ambiente de producción
Las siguientes subsecciones explican secuencialmente los pasos a seguir para configurar el ambiente.

#### Restauración base de datos **reporteria MySQL**
El dump de la base de datos "reporteria" se encuentra en [reporteria](https://github.com/carolahp/MOP/tree/main/DB/reporteria). 
Restaurar todas las tablas y no olvidar incluir los procedimientos almacenados (hay sólo uno).


#### Ejecución manual de procesos ETL
Un proceso ETL extrae datos desde una o varias fuentes de datos, los transforma y luego los carga en otra fuente de datos.
Nuestros ETL extraen los datos desde un archivo excel y desde la base de datos de SAFI para luego cargarlos a la base de datos reportería. 

En Pentaho, los grandes procesos ETL se guardan en "jobs" (archivos formato kjb), los cuales referencian procesos más simples llamados "transformations" (formato ktr).
El job que extrae los decretos desde el Archivo Decretos (Excel) y los carga en la base de datos Reporteria (MySQL) es [job_decretos](https://github.com/carolahp/MOP/blob/main/ETL/Decretos_Pentaho_to_MySQL/job_decretos.kjb).

Existe un segundo job llamado [job_claudia_to_mysql](https://github.com/carolahp/MOP/blob/main/ETL/Decretos_Claudia_to_MySQL/job_claudia_to_mysql.kjb) que se encarga de cargar los datos desde el archivo excel de Claudia. Este job existe sólo para propósitos de demostración y no debe ser utilizado en producción. Si se ejecuta, la base de datos reporteria contendrá los registros de Claudia y en consecuencia los reportes mostrarán estos datos. Para revertir esta situación y cargar los registros provenientes del Archivo Decretos, deberá ejecutarse nuevamente el job_decretos mencionado en el párrafo anterior.

Existen dos maneras de ejecutar manualmente este u otro job:

- Desde el Archivo Excel Analistas

  Se presiona un botón para ejecutar el ETL. Más detalles sobre este método en la siguiente sección.
  
- Desde el software Pentaho Data Integration 
  
  Para ejecutar pentaho se debe abrir el archivo "spoon.bat", ubicado en el directorio de instalación de Pentaho.
  Luego se debe abrir el job en cuestión y presionar play.


#### Preparación del Archivo Decretos (Excel) **reporteria MySQL**
Este archivo se usa por los analistas para ingresar todos los datos asociados a solicitudes de modificación del presupuesto y a sus correspondientes documentos y montos.
Este excel utiliza macros para proveer mecanismos de ingreso de datos fijos y de validaciones. 
También cuenta con un botón en la pestaña "Solicitudes" que se guarda a sí mismo en formato .xls (único formato compatible con los ETL de Pentaho), y luego corre un archivo .bat (ubicado en la misma carpeta que el archivo excel en cuestión) que se encarga de ejecutar el 


#### Programación de la ejecución automática de procesos ETL

