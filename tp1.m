close all;
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Etape 1

%%  Calcul des coefficients de la fonction de transfert
R      = 0.95; % influe sur le gain de résonnance et la sélectivité de fultre
theta = pi/3; % influe sur la fréquence de résonnance du filtre, theta étant la pulsation normalisée, elle vartie entre -pi et pi

b1 = 1;

a1 = 1;
a2 = -2*R*cos(theta);
a3 = R^2;

%% Construction de la fonction de transfert
b = [b1      ];
a = [a1 a2 a3];

%% Affichage des pôles et les zéros
figure
subplot(2, 1, 1); zplane(b, a); title('pôles et zéros');
% on constate qu'il y a 2 zéros et 2 pôles
% on peut utiliser zplane(poles, zeros) à conditions que poles et zeros
% soient des vecteur colonne.


% Diagramme de bode
N = 255;
f = linspace(-1/2, 1/2-1/N,N); % frequence normalisée

h = freqz(b, a, 2*pi*f); % si l'on travaille avec des pulsation, la visualisation serait incohérente

subplot(2, 1, 2), plot(f, abs(h)); title('module de la fonction de transfert') % on trace le module
xlabel('frequence normalisée');
ylabel('module de H(f)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Etape 2
% un bruit blanc est naturellement à moyenne nulle et à DSP constante

%% construction du bruit
sigma = 1;
noise = sigma*randn(1, N);

%% Filtrage du bruit
y = filter(b, a, noise);

%% Calcul du spectre de puissance  
% nous devons pas utiliser pwelch ou pspectrum vu que nous n'avons qu'une
% seule réalisation finie, ces fonction font le moyennage puis la DSP de
% chaque trame moyenne

noiseFftSquare = abs(fft(noise)).^2;
noiseFftSquare = fftshift(noiseFftSquare);

pSpectreNoise = noiseFftSquare/N;

yFft = abs(fft(y)).^2/N;
yFft = fftshift(yFft);

pSpectreY = yFft/N;


%% DSP :
noiseDSP = noiseFftSquare;
yDSP     = abs(h).^2 * sigma^2; % DSP indépendante de la réalisation y
 

%% Tracés :
figure
% Temporelles : 
subplot(3, 2, 1); plot(noise); title('Temporelle : Bruit avant fitrage'); xlabel('t'); ylabel('bruit');
subplot(3, 2, 2); plot(y); title('Temporelle : Bruit après filtrage'); xlabel('t'); ylabel('bruit');

% Spectre de puissance
subplot(3, 2, 3); plot(f, pSpectreNoise); title('Spectre de puissance du signal d"entree'); xlabel('f'); ylabel('spectre de puissance');
subplot(3, 2, 4); plot(f, pSpectreY); title('Spectre de puissance du signal de sortie'); xlabel('f'); ylabel('spectre de puissance');

% DSP
subplot(3, 2, 5); plot(f, noiseDSP); title('DSP du signal d"entree'); xlabel('f'); ylabel('DSP_x(f)');
subplot(3, 2, 6); plot(f, yDSP); title('DSP du signal de sortie'); xlabel('f'); ylabel('DSP_y(f)');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% étape 3 :

% Construction de H2(z) :
r2 = 0.95;
theta2 = pi/3;
R2 = 0;

b2 = [1 -2*r2*cos(theta2) r2^2];
a2 = [1 ];

%% Affichage des pôles et les zéros
figure
subplot(2, 1, 1); zplane(b2, a2); title('pôles et zéros');
% on constate qu'il y a 2 zéros et 2 pôles
% on peut utiliser zplane(poles, zeros) à conditions que poles et zeros
% soient des vecteur colonne.


% Diagramme de bode
N = 255;
f = linspace(-1/2, 1/2-1/N,N); % frequence normalisée

h2 = freqz(b2, a2, 2*pi*f); % si l'on travaille avec des pulsation, la visualisation serait incohérente

subplot(2, 1, 2), plot(f, abs(h2)); title('module de la fonction de transfert') % on trace le module
xlabel('frequence normalisée');
ylabel('module de H(f)');

% on remarque bien une réjection à +fech/6 et -fech/6

%% Filtrage du bruit
y2 = filter(b2, a2, noise);

%% Calcul du spectre de puissance :
yFft2 = abs(fft(y2)).^2/N;
yFft2 = fftshift(yFft2);

pSpectreY2 = yFft2/N;


%% DSP :
yDSP2 = abs(h2).^2 * sigma^2; % DSP indépendante de la réalisation y
 

%% Tracés :
figure
% Temporelles : 
subplot(3, 2, 1); plot(noise); title('Temporelle : Bruit avant fitrage'); xlabel('t'); ylabel('bruit');
subplot(3, 2, 2); plot(y2); title('Temporelle : Bruit après filtrage'); xlabel('t'); ylabel('bruit');

% Spectre de puissance
subplot(3, 2, 3); plot(f, pSpectreNoise); title('Spectre de puissance du signal d"entree'); xlabel('f'); ylabel('spectre de puissance');
subplot(3, 2, 4); plot(f, pSpectreY2); title('Spectre de puissance du signal de sortie'); xlabel('f'); ylabel('spectre de puissance');

% DSP
subplot(3, 2, 5); plot(f, noiseDSP); title('DSP du signal d"entree'); xlabel('f'); ylabel('DSP_x(f)');
subplot(3, 2, 6); plot(f, yDSP2); title('DSP du signal de sortie'); xlabel('f'); ylabel('DSP_y(f)');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Partie 1.5
R = 0.99; % pole
r = 0.95; % zéro
theta = pi/3;

unitaire = [1 ];
numZeros = [1 -2*r*cos(theta) r^2];
denPoles = [1 -2*R*cos(theta) R^2];

figure,
% H1(z) :
h1 = freqz(unitaire, denPoles, 2*pi*f); 
subplot(3, 2, 1); zplane(unitaire, denPoles); title('H1 : pôles et zéros');
subplot(3, 2, 2), plot(f, abs(h1)); title('H1 : module de la fonction de transfert') 

% H2(z) :

h2 = freqz(numZeros, unitaire, 2*pi*f);
subplot(3, 2, 3); zplane(numZeros, unitaire); title('H2 : pôles et zéros');
subplot(3, 2, 4), plot(f, abs(h2)); title('H2 : module de la fonction de transfert') 

% H3(z) :
% combiner poles et zéros permet de rendre le filtre plus sélectif
subplot(3, 2, 5); zplane(numZeros, denPoles); title('H3 : pôles et zéros');
subplot(3, 2, 6), plot(f, abs(h1.*h2)); title('H3 : module de la fonction de transfert') 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Partie 1.6

%% Génération de la partition musicale :
close all;

fech = 8000;

partition = [1 1 1 2 3 2 1 3 2 2 1 ; ...
             1 1 1 1 2 2 1 1 1 1 1.5];

song = [];

partitionSize = size(partition);
noteNbr = partitionSize(2);

for ii = 1 : 1 : noteNbr 
    note = noteGen(fech, partition(1, ii), partition(2, ii));
    song = cat(2, song, note);
end

%soundsc(song, fech)


         
         