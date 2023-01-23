# DIC_Fayad
This code performs a full-field motion measurement, in 2D. This technique is called digital image correlation.

YouTube tutorial:


User Input:

subset size: diameter of the window of pixels used to measure the motion of each individual point. This should be large enough to encapsulate 3 to 5 features (speckles). A typical number is 21 to 35.
step size: the number of pixels between each data point. This variable highly effects the computation time. Typical value is ~1/3 the subset size.

