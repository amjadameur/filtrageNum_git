function note = noteGen(fech, fIdx, duree)

% liste des notes prédéfinies
fNotes = [261.6 293.7 329.7 349.2 392 440 493.9];
noteLength = 0.4;
songLength = noteLength*duree;

N = ceil(songLength*fech); % nombre d'échantillons d'une note
f = linspace(-1/2, 1/2-1/N,N); % frequence normalisée


% génération du bruit
sigma = 1;
noise = sigma*randn(1, N);


% génération de la pulsation (normalisée) de coupure
f0 = fNotes(fIdx); 
theta = 2*pi*f0/fech;


% filtre réjecteur de bande pour isoler la fréquence f0 :
R = 0.9999; % pole, trèèèès sélectif sinon ça ne marcherait pas
r = 0; % pas de zéros

numZeros = [1 -2*r*cos(theta) r^2];
denPoles = [1 -2*R*cos(theta) R^2];
H = freqz(numZeros, denPoles, 2*pi*f);

note = filter(numZeros, denPoles, noise);

%noteDSP = abs(H).^2 * sigma^2;

%figure; plot(f*fech, noteDSP); title('DSP du signal de sortie'); xlabel('f'); ylabel('DSP_y(f)');
%soundsc(note, fech)