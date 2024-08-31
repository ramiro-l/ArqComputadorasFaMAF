# ArqDeComputadoras - PRACTICOS

## Descripcion

Para los practicos se programo en vscode y se utilizo el programa de simulacion _Quartus_, en la version 20.1 con los siguientes parametros: "Cyclone IV E" y "EP4CE22F17C6".

## Estrutura de directorios

Cada carpeta _PracticoN_ es un proyecto de quartus el cual tiene los archivos de configuracion `.qpf` y `.qsf`. Luego en la carpeta `modules` se encuentran los modulos de verilog y en la carpeta `test-bench` se encuentran los archivos de simulacion.
Se tiene la convencion que el nombre de los test-bench es `<nombre_modulo>_tb.sv`.

## Consideraciones

Cuando agregamos un nuevo test-bench en **Quartus** lo mejor es agregar no solo el archivo `*_tb.sv` sino tambien todos los modulos involucrados y los `*_tv.bin` si es que se utilizan.
