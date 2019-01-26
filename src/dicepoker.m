% --------------------------------------------- %
% Nome: Nathan Eloy, RA: 726575
% Nome: Vitor Foga�a, RA: 726597
% --------------------------------------------- %

% Limpando a �rea
clear;
close all;
clc;

% Carregando as imagens
roll_img = imread('imgs/dice-rolls/dice-roll-test-1.png');
result = [0 0 0 0 0];
dice1 = imread('imgs/dice-values/dice-1.jpg');
dice2 = imread('imgs/dice-values/dice-2.jpg');
dice3 = imread('imgs/dice-values/dice-3.jpg');
dice4 = imread('imgs/dice-values/dice-4.jpg');
dice5 = imread('imgs/dice-values/dice-5.jpg');
dice6 = imread('imgs/dice-values/dice-6.jpg');

% Mostrando a imagem original
figure('Name','Roll (Original)'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]),
subplot(1,2,1),imshow(roll_img),title('Roll (Original)');

% Converte as imagens se necess�rio (mais de um canal de cores na imagem)
[r1, c1, canais1] = size(roll_img);
if canais1 > 1 
    roll_img = rgb2gray(roll_img); 
end
roll_img = im2double(roll_img);

% Binariza as imagens
bw_roll = imbinarize(roll_img,graythresh(roll_img));
bw_roll = imdilate(bw_roll, strel('sphere', 2));
% Label
[rotulada1, qtd_regioes1] = bwlabel(bw_roll);

% Regionprops
props1 = regionprops(rotulada1, 'EulerNumber', 'Centroid');

% Mostrando a imagem com eros�o e n�mero de Euler
subplot(1,2,2), imshow(bw_roll), title('Roll'),

% Criando figura para exibir a jogada e mostrar outras informa��es
figure('Name','Result'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]);
for k=1:qtd_regioes1
    result(k) = abs(props1(k).EulerNumber) + 1; % vetor para armazenar valores dos d6 rolados
    
    % If para exibir a jogada
    if result(k) == 1
        subplot(2,5,k+5),imshow(dice1),title('1');
    elseif result(k) == 2
        subplot(2,5,k+5),imshow(dice2),title('2');
    elseif result(k) == 3
        subplot(2,5,k+5),imshow(dice3),title('3');
    elseif result(k) == 4
        subplot(2,5,k+5),imshow(dice4),title('4');
    elseif result(k) == 5
        subplot(2,5,k+5),imshow(dice5),title('5');
    elseif result(k) == 6
        subplot(2,5,k+5),imshow(dice6),title('6');
    end
end