classdef Hand
   properties
      hand_rank % ranking da mão, baseado no hand_type
      hand_type % tipo da mão (Pair, Two Pairs, Three-of-a-kind etc...)
      hand_strength % força da mão (vetor que guarda o valor dos dados da mão
                    % forem [2 2 4 4 5 1], o hand_type será Two Pairs a e a
                    % hand_strength será [4 2], pois o par mais forte é o
                    % de 4 e o segundo par mais forte é o de 2.
                    % Essa variável será usada no caso de haverem duas mãos
                    % hand_types iguais entre os jogadores, para determinar
                    % o vencedor
      extra_dice % extra_dice são os dados extra rolados, ou seja, que não
                 % fazem parte da hand_type, ordenados por força.
                 % Usando o exemplo anterior, extra_dice seria [5 1], 
                 % Pode ser necessário verificar os extra_dice no caso de
                 % até a hand_strength ser igual
   end
   methods
      function obj = Hand(dice_count)
          % Determinando qual foi a mão do jogador
            obj.hand_type = '';
            obj.hand_strength = [0 0];
            obj.extra_dice = [0 0 0 0 0]
            three = 0;
            pairs = [0 0];
            five_str = 0;
            six_str = 0;      
            i = 1;
            for k=1:6

               if dice_count(k) == 1 % para verificar five high straight ou six high straight
                   obj.extra_dice(i) = k;
                   i = i + 1;
                   if k == 1
                       five_str = 1;
                   elseif k == 2
                       if five_str == 0
                            six_str = 1;
                       end
                   end
               else
                   if (k ~= 6)
                        five_str = 0;
                   end
                   six_str = 0;

                   if dice_count(k) == 5
                        obj.hand_type = 'Five-of-a-Kind'; % five-of-a-kind
                        obj.hand_strength(1) = k;
                        obj.hand_rank = 8;
                        break;
                   elseif dice_count(k) == 4
                        obj.hand_type = 'Four-of-a-Kind'; % four-of-a-kind
                        obj.hand_strength(1) = k;
                        obj.hand_rank = 7;
                   elseif dice_count(k) == 3
                       three = k;
                       if pairs(1) ~= 0
                           obj.hand_type = 'Full House'; % full house
                           obj.hand_strength = [k, pairs(1)];
                           obj.hand_rank = 6;
                           break;
                       end
                   elseif dice_count(k) == 2
                       if pairs(1) == 0
                           pairs(1) = k;
                       else
                           pairs(2) = k;
                       end      
                       
                       if three ~= 0
                           obj.hand_type = 'Full House'; % full house
                           obj.hand_strength = [three, pairs(1)];
                           obj.hand_rank = 6;
                           break;
                       elseif pairs(2) ~= 0
                           obj.hand_type = 'Two Pairs'; % two pairs
                           obj.hand_strength = [pairs(1), pairs(2)];
                           obj.hand_rank = 2;
                       end
                   end
               end
            end
           
            obj.extra_dice = sort(obj.extra_dice, 'descend'); % Ordenando os dados extra pela força
            obj.hand_strength = sort(obj.hand_strength, 'descend');
            
            if strcmp(obj.hand_type, '') % Se a mão ainda não foi determinada no loop
                if six_str == 1 % Six High Straight
                    obj.hand_type = 'Six High Straight';
                    obj.extra_dice = [0 0 0 0 0];
                    obj.hand_rank = 5;
                elseif five_str == 1 % Five High Straight
                    obj.hand_type = 'Five High Straight';
                    obj.extra_dice = [0 0 0 0 0];
                    obj.hand_rank = 4;
                elseif three ~= 0 % Three-of-a-Kind
                    obj.hand_type = 'Three-of-a-Kind';
                    obj.hand_strength(1) = three;
                    obj.hand_rank = 3;
                elseif pairs(1) ~= 0 % Pair
                    obj.hand_type = 'Pair';
                    obj.hand_strength(1) = pairs(1);
                    obj.hand_rank = 1;
                else % Nothing
                    obj.hand_type = 'Nothing';
                    obj.hand_strength = obj.extra_dice;
                    obj.hand_rank = 0;
                end 
            end
          
      end
   end
end