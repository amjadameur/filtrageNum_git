function [r, idxMax] = getRadarDist(fech, x, y)

xLength = length(x);
yLength = length(y);

%%  filtre optimal hopt :
hopt = fliplr(x);


%% filtrage (corrélation) :

correl = conv(hopt, y);

% let's correct correl offset
correlLength = length(correl);
correl2 = [correl(xLength/2 : correlLength)];
correl2Length = length(correl2);

[correlMax, idxMax] = max(correl2);
t0 = idxMax/fech;
r  = (3e8*t0)/2; % on divise par 2 car le signal y(t) avait fait un aller-retour


%% Displaying resultats :
figure;
xPadding = [x,  zeros(1, yLength - xLength)]; % to make x have the same length as y
subplot(3, 1, 1); plot(xPadding); 
ylim([0 1.5]); title('x(t)'); xlabel('t'); ylabel('x(t)');

subplot(3, 1, 2); plot(y);
ylim([0 1.5]); title('y(t)'); xlabel('t'); ylabel('y(t)');

n = linspace(0, correl2Length-1, correl2Length);
subplot(3, 1, 3); plot(n, correl2, idxMax, correlMax, 'rx'); 
title('Corrélation entre x et y'); xlabel('t'); ylabel('Rxy(t)');
