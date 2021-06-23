# Frequency Logarithmic Perturbation on β₂

This code was used to generate perturbation models for optical fiber communication. 

Some results that used this code can be found on 

[1] V. Oliari, G. Liga, E. Agrell, and A. Alvarado, "**Frequency logarithmic perturbation on the group-velocity dispersion parameter with applications to passive optical networks**", available at https://arxiv.org/abs/2103.05972.

The code compare 5 different models in terms of normalized square deviation. Those models are

 - Regular pertubation (RP) on gamma
 - Enhanced RP on gamma
 - Logarithmic perturbation on gamma
 - RP on β₂
 - Frequency LP on β₂

Running the file entitled "NSD_models.m" will generate the results of Fig. 3 of [1], excluding the curves relative to FLP on gamma and LP on β₂.

Gaussian weights and positions were obtained from https://pomax.github.io/bezierinfo/legendre-gauss.html.

