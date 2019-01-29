function [bw_img] = binarizeImg(img, method)
    if method == 1
        f_max=max(max(img));
        f_min=min(min(img));
        [lin col]=size(img); % obtém dimensões da imagem
        limiar = f_max - 10; % alto para ajudar a separar dados
        bw_img = img;
        for i=1:lin
            for j=1:col
                if bw_img(i,j)>=limiar
                    bw_img(i,j)=255;
                else
                    bw_img(i,j) = 0;
                end
            end
        end
    else
        bw_img = imbinarize(img,graythresh(img));
    end
end