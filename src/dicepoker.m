% --------------------------------------------- %
% Nome: Nathan Eloy, RA: 726575
% Nome: Vitor Fogaça, RA: 726597
% --------------------------------------------- %

% Limpando a área
clear;
close all;
clc;

% Carregando as imagens
roll_img1 = imread('imgs/dice-rolls/dice-roll-1.jpg');
roll_img2 = imread('imgs/dice-rolls/dice-roll-2.jpg');
result = [0 0 0 0 0];
dice_count = [0 0 0 0 0 0];
dice1 = imread('imgs/dice-values/dice-1.jpg');
dice2 = imread('imgs/dice-values/dice-2.jpg');
dice3 = imread('imgs/dice-values/dice-3.jpg');
dice4 = imread('imgs/dice-values/dice-4.jpg');
dice5 = imread('imgs/dice-values/dice-5.jpg');
dice6 = imread('imgs/dice-values/dice-6.jpg');

% Mostrando a imagem original
figure('Name','Rolls (Original)'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]),
subplot(1,2,1),imshow(roll_img1),title('Roll 1 (Original)'),title('Roll 1');
subplot(1,2,2),imshow(roll_img2),title('Roll 2 (Original)'),title('Roll 2');

% Converte as imagens se necessário (mais de um canal de cores na imagem)
[r1, c1, canais1] = size(roll_img1);
[r2, c2, canais2] = size(roll_img2);
if canais1 > 1 
    roll_img1 = rgb2gray(roll_img1); 
end
if canais2 > 1
    roll_img2 = rgb2gray(roll_img2);
end
%roll_img = im2double(roll_img);

% Aplicando o filtro da mediana para eliminar ruídos
% roll_img_smooth = medfilt2(roll_img);

% Binariza as imagens e as trata para reconhecer cada dado individualmente
bw_roll1 = binarizeImg(roll_img1, 0);
bw_roll2 = binarizeImg(roll_img2, 0);
% segundo argumento é o limiar. Se for 0, aplicará imbinarize com
% graythresh, se for algum número entre 1 e 254, realizará a binarização
% considerando esse limiar. Para capturar corretamente os rolls 3 e 5,
% recomendo 120 de limiar.

[rotulada1, qtd_regioes1, bw_roll_eroded1, bw_roll_smaller1, bw_roll_filled1, bw_roll_final1] = isolateDices(bw_roll1, 5);
[rotulada2, qtd_regioes2, bw_roll_eroded2, bw_roll_smaller2, bw_roll_filled2, bw_roll_final2] = isolateDices(bw_roll2, 5);
% o segundo argumento é o raio da sphere utilizada na primeira erosão.
% Aumente ou diminua caso não tenha o resultado esperado, normalmente será
% um valor entre 3 e 7, dependendo do estado da imagem.
% Recomendo reduzir para 3 ou 4 nas imgs dice-roll-test.

% Regionprops
props1 = regionprops(rotulada1, 'EulerNumber', 'Centroid', 'BoundingBox');
props2 = regionprops(rotulada2, 'EulerNumber', 'Centroid', 'BoundingBox');

figure('Name','Roll 1 (bw_roll)'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]),
subplot(1,5,1),imshow(bw_roll1), title('Roll 1 (bw)');
subplot(1,5,2),imshow(bw_roll_eroded1), title('Roll 1 (eroded)');
subplot(1,5,3),imshow(bw_roll_smaller1), title('Roll 1 (smaller dots)');
subplot(1,5,4),imshow(bw_roll_filled1), title('Roll 1 (filled dots and regions defined)');
subplot(1,5,5),imshow(bw_roll_final1), title('Roll 1 (AND operation)');

for k=1:qtd_regioes1
    thisBB = props1(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
    'EdgeColor','r','LineWidth',2 )
    text(thisBB(1,1) + 3, thisBB(1,2) - 10, num2str(abs(props1(k).EulerNumber) + 1), 'FontSize', 14, 'FontWeight' , 'Bold', 'Color', 'Red', 'HorizontalAlignment', 'Center');
end

figure('Name','Roll 2 (bw_roll)'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]),
subplot(1,5,1),imshow(bw_roll2), title('Roll 2 (bw)');
subplot(1,5,2),imshow(bw_roll_eroded2), title('Roll 2 (eroded)');
subplot(1,5,3),imshow(bw_roll_smaller2), title('Roll 2 (smaller dots)');
subplot(1,5,4),imshow(bw_roll_filled2), title('Roll 2 (filled dots and regions defined)');
subplot(1,5,5),imshow(bw_roll_final2), title('Roll 2 (AND operation)');

for k=1:qtd_regioes2
    thisBB = props2(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
    'EdgeColor','r','LineWidth',2 )
    text(thisBB(1,1) + 3, thisBB(1,2) - 10, num2str(abs(props2(k).EulerNumber) + 1), 'FontSize', 14, 'FontWeight' , 'Bold', 'Color', 'Red', 'HorizontalAlignment', 'Center');
end

if qtd_regioes1 ~= 5
    error('Imagem 1 não reconhecida adequadamente.');
end

if qtd_regioes2 ~= 5
    error('Imagem 2 não reconhecida adequadamente.');
end

% Exibindo o resultado final
figure('Name','Final Result'),set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]);

% JOGADOR 1
j = 1;
for k=1:qtd_regioes1
    result(k) = abs(props1(k).EulerNumber) + 1; % vetor para armazenar valores dos d6 rolados
    dice_count(result(k)) = dice_count(result(k)) + 1; % vetor para armazenar a contagem de cada valor rolado
    
    % If para exibir a jogada
    if result(k) == 1
        subplot(5,4,j),imshow(dice1),title('1');
    elseif result(k) == 2
        subplot(5,4,j),imshow(dice2),title('2');
    elseif result(k) == 3
        subplot(5,4,j),imshow(dice3),title('3');
    elseif result(k) == 4
        subplot(5,4,j),imshow(dice4),title('4');
    elseif result(k) == 5
        subplot(5,4,j),imshow(dice5),title('5');
    elseif result(k) == 6
        subplot(5,4,j),imshow(dice6),title('6');
    end
    
    j = j + 4;
end

% Criando o objeto Hand
jogador1 = Hand(dice_count);

% JOGADOR 2
dice_count = [0 0 0 0 0 0];
j = 4;
for k=1:qtd_regioes2
    result(k) = abs(props2(k).EulerNumber) + 1; % vetor para armazenar valores dos d6 rolados
    dice_count(result(k)) = dice_count(result(k)) + 1; % vetor para armazenar a contagem de cada valor rolado
    
    % If para exibir a jogada
    if result(k) == 1
        subplot(5,4,j),imshow(dice1),title('1');
    elseif result(k) == 2
        subplot(5,4,j),imshow(dice2),title('2');
    elseif result(k) == 3
        subplot(5,4,j),imshow(dice3),title('3');
    elseif result(k) == 4
        subplot(5,4,j),imshow(dice4),title('4');
    elseif result(k) == 5
        subplot(5,4,j),imshow(dice5),title('5');
    elseif result(k) == 6
        subplot(5,4,j),imshow(dice6),title('6');
    end
    
    j = j + 4;
end

% Criando o objeto Hand
jogador2 = Hand(dice_count);

% Impressão de dados extras
if isvector(jogador1.extra_dice) && length(jogador1.extra_dice) > 1
    extra1 = '';
    for extra = jogador1.extra_dice
        extra1 = [extra1 ' ' num2str(extra)];
    end
    %extra1 = [num2str(jogador1.extra_dice(1)) ', ' num2str(jogador1.extra_dice(2)) ', ' num2str(jogador1.extra_dice(3)) ', ' num2str(jogador1.extra_dice(4)) ', ' num2str(jogador1.extra_dice(5))];
else
    extra1 = 'Não há';
end

if isvector(jogador2.extra_dice) && length(jogador1.extra_dice) > 1
    extra2 = '';
    for extra = jogador2.extra_dice
        extra2 = [extra2 ' ' num2str(extra)];
    end
    %extra2 = [num2str(jogador2.extra_dice(1)) ', ' num2str(jogador2.extra_dice(2)) ', ' num2str(jogador2.extra_dice(3)) ', ' num2str(jogador2.extra_dice(4)) ', ' num2str(jogador2.extra_dice(5))];
else
    extra2 = 'Não há';
end

ax = subplot(5, 4, 2);
text(0, 0, ['Jogador 1:' newline 'Tipo da Mão: ' jogador1.hand_type newline 'Força da mão: ' num2str(jogador1.hand_strength(1)) ', ' num2str(jogador1.hand_strength(2)) newline 'Dados extra: ' extra1],...
    'FontSize', 16, 'FontWeight' , 'Bold', 'Color', 'Blue');
set ( ax, 'visible', 'off');

ax = subplot(5, 4, 3);
text(0, 0, ['Jogador 2:' newline 'Tipo da Mão: ' jogador2.hand_type newline 'Força da mão: ' num2str(jogador2.hand_strength(1)) ', ' num2str(jogador2.hand_strength(2)) newline 'Dados extra: ' extra2],...
    'FontSize', 16, 'FontWeight' , 'Bold', 'Color', 'Red');
set ( ax, 'visible', 'off');

vencedor = 0;
% Definindo o vencedor
if jogador1.hand_rank > jogador2.hand_rank
    vencedor = 1;
elseif jogador2.hand_rank > jogador1.hand_rank
    vencedor = 2;
elseif strcmp(jogador1.hand_type, 'Five High Straight') == false &&...
       strcmp(jogador1.hand_type, 'Six High Straight') == false 
       % Hand rank/type é o mesmo, então devemos checar os números dos dados
       % Já checamos se a mão não é five high ou six high, pois se for, não
       % é necessário checar o resto, pois é empate.
    for i=1:2
        if jogador1.hand_strength(i) > jogador2.hand_strength(i)
            vencedor = 1;
            break;
        elseif jogador2.hand_strength(i) > jogador1.hand_strength(i)
            vencedor = 2;
            break;
        end  
    end
    
    if vencedor == 0 
        % Se até os números dos dados do tipo da mão forem
        % iguais, precisaremos checar os dados extra, ou seja,
        % os dados que não fazem parte da hand type
        for i=1:5
            if jogador1.extra_dice(i) > jogador2.extra_dice(i)
                vencedor = 1;
                break;
            elseif jogador2.extra_dice(i) > jogador1.extra_dice(i)
                vencedor = 2;
                break;
            elseif jogador1.extra_dice(i) == 0
                break;
            end
        end
    end
end

% Exibindo o vencedor
if vencedor ~= 0
    ax = subplot(5, 4, 6);
    text(0.5, 0, ['O vencedor é o jogador ' num2str(vencedor) '!'],...
    'FontSize', 16, 'FontWeight' , 'Bold', 'Color', 'Black');
    set ( ax, 'visible', 'off');
else
    ax = subplot(5, 4, 6);
    text(0.5, 0, 'Houve um empate!',...
    'FontSize', 16, 'FontWeight' , 'Bold', 'Color', 'Black');
    set ( ax, 'visible', 'off');
end

% Exibindo recomendação de jogadas
if strcmp(jogador1.hand_type, 'Nothing')
    textoJogador1 = ['Jogador 1 não tem nada! A melhor jogada seria rolar todos os dados' newline 'novamente, ou rodar um dado restante novamente para conseguir Straight (16,70%)'];
elseif strcmp(jogador1.hand_type, 'Pair')
    textoJogador1 = ['Jogador 1 tem One Pair. A melhor jogada seria rolar os três dados restantes' newline 'novamente para conseguir Two Pairs (27,80%), Three of a Kind (27,70%)' newline 'ou Full House (9,29%), Four-of-a-Kind (6,95%), Five-of-a-Kind (0,46%)'];
elseif strcmp(jogador1.hand_type, 'Two Pairs')
    textoJogador1 = ['Jogador 1 tem Two Pairs. A melhor jogada seria rolar o dado restante' newline 'novamente para conseguir Full House (33,30%)'];
elseif strcmp(jogador1.hand_type, 'Three-of-a-Kind')
    textoJogador1 = ['Jogador 1 tem Three-of-a-Kind. A melhor jogada seria rolar os dois dados' newline 'restantes novamente para conseguir Four-of-a-Kind (27,80%),' newline 'Full House (13,90%) ou Five-of-a-Kind (2,76%)'];
elseif strcmp(jogador1.hand_type, 'Four-of-a-Kind')
    textoJogador1 = ['Jogador 1 tem Four-of-a-Kind. A melhor jogada seria rolar o dado restante' newline 'novamente para conseguir Five-of-a-Kind (16,7%)'];
else
    textoJogador1 = 'A mão do Jogador 1 já é boa o suficiente! Qualquer jogada é perigosa';
end

if strcmp(jogador2.hand_type, 'Nothing')
    textoJogador2 = ['Jogador 2 não tem nada! A melhor jogada seria rolar todos os dados' newline 'novamente, ou rodar um dado restante novamente para conseguir Straight (16,70%)'];
elseif strcmp(jogador2.hand_type, 'Pair')
    textoJogador2 = ['Jogador 2 tem One Pair. A melhor jogada seria rolar os três dados restantes' newline 'novamente para conseguir Two Pairs (27,80%), Three of a Kind (27,70%)' newline 'ou Full House (9,29%), Four-of-a-Kind (6,95%), Five-of-a-Kind (0,46%)'];
elseif strcmp(jogador2.hand_type, 'Two Pairs')
    textoJogador2 = ['Jogador 2 tem Two Pairs. A melhor jogada seria rolar o dado restante' newline 'novamente para conseguir Full House (33,30%)'];
elseif strcmp(jogador2.hand_type, 'Three-of-a-Kind')
    textoJogador2 = ['Jogador 2 tem Three-of-a-Kind. A melhor jogada seria rolar os dois dados' newline 'restantes novamente para conseguir Four-of-a-Kind (27,80%),' newline 'Full House (13,90%) ou Five-of-a-Kind (2,76%)'];
elseif strcmp(jogador2.hand_type, 'Four-of-a-Kind')
    textoJogador2 = ['Jogador 2 tem Four-of-a-Kind. A melhor jogada seria rolar o dado restante' newline 'novamente para conseguir Five-of-a-Kind (16,7%)'];
else
    textoJogador2 = 'A mão do Jogador 2 já é boa o suficiente! Qualquer jogada é perigosa';
end

ax = subplot(5, 4, 10);
text(0, 0, textoJogador1,...
    'FontSize', 14, 'FontWeight' , 'Bold', 'Color', 'Blue');
set ( ax, 'visible', 'off');

ax = subplot(5, 4, 14);
text(0, 0, textoJogador2,...
    'FontSize', 14, 'FontWeight' , 'Bold', 'Color', 'Red');
set ( ax, 'visible', 'off');