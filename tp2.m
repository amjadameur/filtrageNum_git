close all;
clear;
clc;

fech  = 200e6;

mat1 = load('signal_radar_config1.mat');
x = mat1.x'; 
y = mat1.y'; 

xLength = length(x);
yLength = length(y);


%% QST8

% calculons la puissance du signal, Ps correspond à celle de y et non pas x
% car nous cherchons à bruiter y.

% génération du bruit :
Ps = sum(y.^2)/yLength;
RSB = 0; % en décibel)
sigma = sqrt(Ps*10^(-RSB/10));
noise = sigma*randn(1, yLength);

% on additionne le bruit :
yb = y + noise;

[r, idxMax] = getRadarDist(fech, x, yb);

idxMax

