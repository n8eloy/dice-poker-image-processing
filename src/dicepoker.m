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
dice_count = [0 0 0 0 0 0];
dice1 = imread('imgs/dice-values/dice-1.jpg');
dice2 = imread('imgs/dice-values/dice-2.jpg');
dice3 = imread('imgs/dice-values/dice-3.jpg');
dice4 = imread('imgs/dice-values/dice-4.jpg');
dice5 = imread('imgs/dice-values/dice-5.jpg');
dice6 = imread('imgs/dice-values/dice-6.jpg');

% Mostrando a imagem original
figure('Name','Roll (Original)'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]),
imshow(roll_img),title('Roll (Original)');

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
props1 = regionprops(rotulada1, 'EulerNumber', 'Centroid', 'BoundingBox');

% Mostrando a imagem com eros�o e n�mero de Euler
figure('Name','Roll (bw)'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]),
imshow(bw_roll), title('Roll (bw)');

for k=1:qtd_regioes1
    thisBB = props1(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
    'EdgeColor','r','LineWidth',2 )
    text(thisBB(1,1) + 3, thisBB(1,2) - 8, num2str(abs(props1(k).EulerNumber) + 1), 'FontSize', 14, 'FontWeight' , 'Bold', 'Color', 'Red', 'HorizontalAlignment', 'Center');
end

% Criando figura para exibir a jogada e mostrar outras informa��es
figure('Name','Result'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]);
for k=1:qtd_regioes1
    result(k) = abs(props1(k).EulerNumber) + 1; % vetor para armazenar valores dos d6 rolados
    dice_count(result(k)) = dice_count(result(k)) + 1; % vetor para armazenar a contagem de cada valor rolado
    
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

% Criando os objetos Hand
jogador1 = Hand(dice_count);

ax = subplot(2, 5, 2);
text(0.5, 0.5, ['Tipo da M�o: ' jogador1.hand_type char(10) 'For�a da m�o: ' num2str(jogador1.hand_strength(1)) ', ' num2str(jogador1.hand_strength(2)) char(10) 'Dados extra: ' num2str(jogador1.extra_dice(1))],...
    'FontSize', 32, 'FontWeight' , 'Bold', 'Color', 'Red');
set ( ax, 'visible', 'off');