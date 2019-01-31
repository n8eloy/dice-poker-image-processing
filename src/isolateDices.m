function [rotulada, qtd_regioes, bw_roll, bw_roll_smaller, bw_roll_filled, bw_roll_final] = isolateDices(bw_roll, radius)
    bw_roll = imerode(bw_roll, strel('sphere', radius));
    % A primeira erosão tem o objetivo de eliminar ruídos na imagem e 
    % eliminar reflexão de luz nos pontos dos dados, se houver. 
    
    % bw_roll_smaller guarda os dados com os pontos menores dentro deles
    % Isso é interessante caso a primeira erosão cause uma junção dos pontos nos dados
    bw_roll_smaller = ~bw_roll;
    bw_roll_smaller = imerode(bw_roll_smaller, strel('sphere', radius+1));
    bw_roll_smaller = ~bw_roll_smaller;

    % bw_roll_filled guarda os dados com os pontos preenchidos, precisamos
    % disso para fazer o tratamento final que divide os dados quando eles estão
    % muito juntos.
    bw_roll_filled = imfill(bw_roll, 'holes');
    bw_roll_filled = imerode(bw_roll_filled, strel('sphere', radius));

    % bw_roll_final é o resultado da operação lógica AND, com os dados
    % devidamente separados
    bw_roll_final = bw_roll_smaller & bw_roll_filled;
    
    % Label
    [rotulada, qtd_regioes] = bwlabel(bw_roll_final);
end
