# Apuntes primera reunion con Juan José

## Estructura presupuestaria general 
- **Año** : 
- **Partida** : Ministerio - Ej: MOP = 12  
- **Capítulo** : Subdivisión de un ministerio - Ej: Dirección General de Obras Públicas = 02
- **Programa** : Servicio - Ej: Vialidad = 04
- **Subtítulo** : Clasificación de gasto - Ej: Iniciativas de inversión = 31(proyectos) 
- **Ítem** : Clasificación de gasto - Ej: Estudios de inversión = 01 , Proyecto = 02
- **Asiganción** : Clasificación de gasto

## Organismos relevantes
- MDS Ministerio de Desarrollo Social y Familia (ex Mideplan)
- Hacienda (DIPRES)
- Contraloría
- MOP > DCyF

## Proyectos
### Tipos de Proyecto
- **Nuevos**
    - ojo: cuando un proyecto pasa de etapa pasa a ser nuevo
- **De Arrastre**
- **De Conservación** 
    - se presenta junto con el nuevo proyecto
    - tiene condiciones distintas al proyecto nuevo, ej: no puede costar más que el 20% del proyecto nuevo

### Nomenclatura Proyectos
Objeto + Verbo + Localización o complemento ***Buscar ejemplos***

### Etapas (***MDS?***) de un Proyecto
1. Inscripción en MDS -> Obtención de "pro_clave", ***no hay BIP aun?***
2. Prefactibilidad y factibilidad
3. Diseño
4. Ejecución y conservación
5. Operación y Explotación

Estas etapas estan registradas en SAFI pero tambien en el sistema MDS
Cuando llega un decreto, el servicio hace una resolución de apertura donde redistribuye las platas

### Evaluación de un Proyecto
Los servicios postulan un conjunto de proyectos a financiamiento. 
Para cada proyecto, en cada etapa y ***también en cada año?*** los servicios le piden al MDSF su opinión, quien responde con un **RATE** (recomendación técnica económica),  

El RATE puede ser:
- *RS*: recomienda 
- *FI*: falta info
- *OT*: no recomienda

Sobre el RATE:
- Todos los proyectos llevan RATE excepto los de Conservación y los de prioridad presidencial
- RS es requisito para pedir asignar presupuesto al proyecto (el presupuesto se asigna a través de decretos)
- Los proyectos de arrastre obtienen RS automaticamente, siempre y cuando los gastos hayan sido cargados el año anterior

## Presupuesto
- Ley: aprobado en un decreto ***inicial?***
- Vigente: se reparte (asigna) entre los proyectos a través de decretos

- Identificación del presupuesto: es el presupuesto inicial por proyecto
- 19 Bis : saldo para años posteriores que queda registrado en un decreto

## Vistas relevantes
- SA_ es el prefijo de las vistas que nos interesan
- **SA_ROTMONTOFUTURO**: 
    - Se usa para sacar el 19bis, la idea es sacar solo una linea por cada bip, seleccionando aquella cuyo decreto tiene mayor fecha
    - Considerar los bip terminados en -9 deben mergearse con su correspondiente -0
    - Antes había un proyecto por servicio, pero en covid inventaron servicio ej 54 (0204 vialidad y 0254 vialidad covid)
    - Otro problema es con las asignaciones, normalmente son 00x pero algunas son 70x ... en este caso hay que ***reemplazarla, renombrarla?*** por su version con 00x
- **SA_RPTLIBROPRESUPUESTOGASTO**
    - PK es id_classIFPRESS (combina subtitulo, asignacion, etc)
    - Falta incluir el campo el monto ley 
    - Falta incluir los proyectos sin presupuesto (que tienen solo monto ley)
    - ***Subasignación es el BIP***
    - Falta región, provincia, comuna
- **RPTLibro** : tabla local de Juan José
- **SA_VM_FichaProyectos**
    - PK es Pro_clave porque no todos tienen codigo bip
    - Sirve para sacar el "programa" y la región
- **SA_VN_INV_ProyProVCom** 
    - Sirve para provincias y comunas
- **SA_HIST_Anexo5Hacienda** y **SA_FICHA_contratos**
    - Para sacar por ejemplo contratos por licitar y además contratos adjuntidacos el mes pasado

## Objetivos
- Automatizar libro presupuesto y gasto MOP 
    - Tanto por asignación como por bip
    - Crear 1 PA para cada uno
- Guardar respaldo de reportes generados en el servidor
    
## Problemas
- Presupuesto no lleva la etapa MDS (antiguamente el decreto contenia el codigo de la asignacion?)
- Esta etapa es necesaria para entender el Rate

## Links relevantes
### Web
- [MDS](https://bip.ministeriodesarrollosocial.gob.cl/)
- [Reportes Juan José](https://planeamiento.mop.gob.cl/) > Información de Presupuesto MOP
