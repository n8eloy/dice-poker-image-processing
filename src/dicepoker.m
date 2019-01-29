% --------------------------------------------- %
% Nome: Nathan Eloy, RA: 726575
% Nome: Vitor Fogaça, RA: 726597
% --------------------------------------------- %

% Limpando a área
clear;
close all;
clc;

% Carregando as imagens
roll_img = imread('imgs/dice-rolls/dice-roll-test-4.png');
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

% Converte as imagens se necessário (mais de um canal de cores na imagem)
[r1, c1, canais1] = size(roll_img);
if canais1 > 1 
    roll_img = rgb2gray(roll_img); 
end
%roll_img = im2double(roll_img);

% Binariza as imagens e as trata para reconhecer cada dado individualmente
bw_roll = binarizeImg(roll_img, 1);

% Erosão aplicada para eliminar as laterais dos dados
bw_roll = imerode(bw_roll, strel('sphere', 3));

% bw_roll_smaller guarda os dados com os pontos menores dentro deles
bw_roll_smaller = ~bw_roll;
bw_roll_smaller = imerode(bw_roll_smaller, strel('sphere', 5));
bw_roll_smaller = ~bw_roll_smaller;

% bw_roll_filled guarda os dados com os pontos preenchidos, precisamos
% disso para fazer o tratamento final que divide os dados quando eles estão
% muito juntos.
bw_roll_filled = imfill(bw_roll, 'holes');
bw_roll_filled = imerode(bw_roll_filled, strel('sphere', 4));

% bw_roll_final é o resultado da operação lógica AND, com os dados
% devidamente separados
bw_roll_final = bw_roll_smaller & bw_roll_filled;

% Label
[rotulada1, qtd_regioes1] = bwlabel(bw_roll_final);

% Regionprops
props1 = regionprops(rotulada1, 'EulerNumber', 'Centroid', 'BoundingBox', 'PixelIdxList');

figure('Name','Roll (bw_roll)'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]),
subplot(1,3,1),imshow(bw_roll_smaller), title('Roll (smaller dots)');
subplot(1,3,2),imshow(bw_roll_filled), title('Roll (filled dots and regions defined)');
subplot(1,3,3),imshow(bw_roll_smaller&bw_roll_filled), title('Roll (AND operation)');

for k=1:qtd_regioes1
    thisBB = props1(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
    'EdgeColor','r','LineWidth',2 )
    text(thisBB(1,1) + 3, thisBB(1,2) - 8, num2str(abs(props1(k).EulerNumber) + 1), 'FontSize', 14, 'FontWeight' , 'Bold', 'Color', 'Red', 'HorizontalAlignment', 'Center');
end

% Criando figura para exibir a jogada e mostrar outras informações
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
text(0.5, 0.5, ['Tipo da Mão: ' jogador1.hand_type char(10) 'Força da mão: ' num2str(jogador1.hand_strength(1)) ', ' num2str(jogador1.hand_strength(2)) char(10) 'Dados extra: ' num2str(jogador1.extra_dice(1)) ', ' num2str(jogador1.extra_dice(2)) ', ' num2str(jogador1.extra_dice(3)) ', ' num2str(jogador1.extra_dice(4)) ', ' num2str(jogador1.extra_dice(5))],...
    'FontSize', 32, 'FontWeight' , 'Bold', 'Color', 'Red');
set ( ax, 'visible', 'off');