# Preanalysis – Análisis de datos de pinzas ópticas

Este proyecto corresponde a un trabajo real desarrollado como parte de mi Trabajo Fin de Máster (TFM) en biología computacional. Su objetivo es el preprocesamiento, análisis y visualización de datos de pinzas ópticas, para estudiar propiedades mecánicas y dinámicas de partículas a nivel microscópico.

Principales funcionalidades:

Importación y corrección de datos experimentales de pinzas ópticas.

Filtrado y procesamiento de señales (low-pass y high-pass FIR, remuestreo).

Análisis de fuerza y desplazamiento en múltiples traps y beads, incluyendo cálculo de fuerza máxima (fmax) y desplazamiento máximo (xmax).

Transformadas de Fourier para amplitud y fase de la fuerza.

Cálculo de propiedades mecánicas: módulo elástico (G'), módulo viscoso (G'') y viscosidad.

Visualización: gráficos de fuerza y desplazamiento, histogramas y comparación de datos filtrados vs sin filtrar.

Automatización de patrones y análisis temporal: detección de beads, cálculo de retardos temporales (time-lag) y derivadas.

Guardado de resultados para análisis posterior.

El proyecto permite estudiar de manera reproducible los experimentos con pinzas ópticas y facilita la interpretación de las propiedades mecánicas de partículas a escala micro.

