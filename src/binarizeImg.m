function [bw_img] = binarizeImg(img, limiar)
    if limiar ~= 0
        [lin col]=size(img); % obtém dimensões da imagem
        bw_img = img;
        for i=1:lin
            for j=1:col
                if bw_img(i,j)>=limiar
                    bw_img(i,j)= 255;
                else
                    bw_img(i,j) = 0;
                end
            end
        end
    else
        bw_img = imbinarize(img,graythresh(img));
    end
end