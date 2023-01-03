# Reportería Solicitudes de Modificación de Presupuesto

Esta documentación explica cómo utilizar e instalar el sistema de reportería desarrollado durante los meses de Noviembre y Diciembre para la DIRPLAN. 

Se divide en dos secciones: 
- **Guía de Usuario**: dedicada a los analistas, contiene información necesaria para el ingreso de datos, y para la generación y visualización de reportes.
- **Guía Técnica de Instalación**: explica al usuario técnico informático cómo configurar y administrar el ambiente para ejecutar el sistema. 

## Guía de Usuario 

Para complementar esta guía, se recomienda ver el [video tutorial](https://drive.google.com/file/d/1WHZ6JCi0fxejuAg6MF3JqlgZiM_THYfx/view?usp=share_link), donde se explica a los usuarios cómo utilizar el sistema.  

## Ingreso de datos: Excel Decretos


## Generación y actualización de los reportes

## Reporte excel solicitudes por etapa

## Reportes visuales Power BI


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
    
- **Microsoft Power BI Desktop (Community)** 
  
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
Nuestros ETL extraen los datos desde un archivo excel y desde la base de datos de SAFI (si se activa la opción) para luego cargarlos a la base de datos reportería. 

En Pentaho, los grandes procesos ETL se guardan en "jobs" (archivos formato kjb), éstos referencian procesos más simples llamados "transformations" (formato ktr).
El job que extrae los decretos desde el Archivo Decretos (Excel) y los carga en la base de datos Reporteria (MySQL) es [job_decretos](https://github.com/carolahp/MOP/blob/main/ETL/Decretos_Pentaho_to_MySQL/job_decretos.kjb).

Existe un segundo job llamado [job_claudia_to_mysql](https://github.com/carolahp/MOP/blob/main/ETL/Decretos_Claudia_to_MySQL/job_claudia_to_mysql.kjb) que se encarga de cargar los datos desde el archivo excel de Claudia. Este job existe sólo para propósitos de demostración y no debe ser utilizado en producción. Si se ejecuta, la base de datos reporteria contendrá los registros de Claudia y en consecuencia los reportes mostrarán estos datos. Para revertir esta situación y cargar los registros provenientes del Archivo Decretos, deberá ejecutarse nuevamente el job_decretos mencionado en el párrafo anterior.

Existen dos maneras de ejecutar manualmente este u otro job:

- **Desde el Archivo Excel Analistas**: 
El Archivo [Decretos](https://github.com/carolahp/MOP/blob/main/Excel/Decretos_Analistas/Decretos.xlsm) se usa por los analistas para ingresar los datos asociados a solicitudes de modificación del presupuesto y a sus correspondientes documentos y montos. Este archivo contiene un botón etiquetado "Generar Reportes", que ejecutar el ETL necesario. Más detalles sobre este método en la sección "Preparación del Archivo Decretos (Excel)".
  
- **Desde el software Pentaho Data Integration**   
Para ejecutar pentaho se debe abrir el archivo "spoon.bat", ubicado en el directorio de instalación de Pentaho.
Luego se debe abrir el job en cuestión (ya sea [job_decretos](https://github.com/carolahp/MOP/blob/main/ETL/Decretos_Pentaho_to_MySQL/job_decretos.kjb) o [job_claudia_to_mysql](https://github.com/carolahp/MOP/blob/main/ETL/Decretos_Claudia_to_MySQL/job_claudia_to_mysql.kjb)) y presionar el botón verde play.


#### Preparación del Archivo Decretos (Excel)

Como se mencionó anteriormente, el archivo [Decretos](https://github.com/carolahp/MOP/blob/main/Excel/Decretos_Analistas/Decretos.xlsm) se usa por los analistas para ingreso de datos.

Utiliza macros para proveer mecanismos de ingreso de datos predefinidos a través de listas desplegables de selección, y de validaciones de los datos ingresados.

Cuenta con un botón etiquetado "Generar reporte" en la pestaña "Solicitudes" que actualiza los datos del reporte mediante las siguientes acciones:
- Se guarda a sí mismo en formato .xls (único formato compatible con los ETL de Pentaho, el archivo generado es [DecretosPentaho](https://github.com/carolahp/MOP/blob/main/Excel/Decretos_Analistas/DecretosPentaho.xls) y no debe ser modificado por el usuario). 
- Luego ejecuta un archivo .bat ([run_etl.bat](https://github.com/carolahp/MOP/blob/main/Excel/Decretos_Analistas/scripts/runETL.bat)) que se encarga de correr el job_decretos utilizando Pentaho, esto lo hace a través de un comando que se ejecuta en la terminal de windows.


#### Programación de la ejecución automática de procesos ETL

Para mantener los datos de los reportes actualizados, el job_decretos debe ejecutarse automáticamente cada cierto intervalo de tiempo (por ejemplo cada media hora). 
Para lograr esto, el programador encargado deberá usar el scheduler de Windows para programar la ejecución del archivo runETL.bat mencionado en la sección inmediatamente anterior a esta.

Se debe tener en consideración que, tal como el ETL se encuentra programado actualmente, cada vez que el job_decretos se ejecuta, un archivo excel que contiene el reporte de tiempo, estado y etapas es generado. Este archivo se almacena en el directorio [Reportes](https://github.com/carolahp/MOP/tree/main/ETL/Reportes) y se nombra considerando el datetime de cuando se generó del siguiente modo: reporte_solicitudes_por_etapa.xls_AAAMMDD_HHSSmm.xls . Se adjunta un archivo de ejemplo en este repositorio: [reporte_solicitudes_por_etapa.xls_20221230_194841.xls](https://github.com/carolahp/MOP/blob/main/ETL/Reportes/reporte_solicitudes_por_etapa.xls_20221230_194841.xls)

#### Acceso y disponibilización de los reportes Power BI

El archivo [segundo.pbix](https://github.com/carolahp/MOP/blob/main/Reportes_PowerBI/segundo.pbix) contiene los reportes Power BI generados a partir de los datos ingresados por los analistas. 
Este archivo se abre utilizando Power BI Desktop Community, que tiene licencia gratuita, y podría por tanto ser instalado en los PC de los analistas para que ellos lo usen para abrir los reportes localmente. Por otro lado, si se quiere publicar estos reportes en la web de manera privada, se deberá comprar la licencia pro de Power BI.

