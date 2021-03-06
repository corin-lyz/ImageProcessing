function [ res ] = JBF( I, p, rad, deltaS, deltaR)
% ----------------------
% Author : smh
% Date   : 2017.12.18
% Description:
%   This file includes the implementation of Joint Bilateral Filtering
%   (JBF) based on 'Guided image filter' and 'Rolling Guidance Filter'.
%   Inputs: 
%       I : The iuput guided image, single channel
%       p : The input filtering image
%       rad : the radius of neighbour size
%       deltaS : control the spartial similarity
%       deltaR : control the color similarity
%   Outputs:
%       res : the output of rolling guidance filter
% ----------------------

[M, N] = size(p);
res = zeros(M, N);

if nargin < 2
    error('Too few inputs parameters');
end

if ~exist('rad', 'var')
    rad = 2;
end

if ~exist('deltaS', 'var')
    deltaS = 1.2;
end

if ~exist('deltaR', 'var')
    deltaR = 0.25;
end

if isa(I, 'uint8')
    I = im2double(I);
end

if isa(p, 'uint8')
    p = im2double(p);
end

% pad the input guidance image
img = padarray(I, [rad, rad], 'replicate', 'both');
imgP = padarray(p, [rad, rad], 'replicate', 'both');

divS = 2 * deltaS * deltaS;     % The division of spartial similarity.
divR = 2 * deltaR * deltaR;     % The division of color similarity.
for i = rad + 1 : rad + M
    for j = rad + 1 : rad + N
        sumExp = 0.0;
        sumColor = 0.0; 
        for m = -rad : rad
            for n = -rad : rad
                expVal = exp(-(m * m + n * n) / divS - (img(i, j) - img(i + m, j + n))^2 / divR);
                sumExp = sumExp + expVal;
                sumColor = sumColor + expVal * imgP(i + m , j + n);
            end
        end
        res(i - rad, j - rad) = sumColor / sumExp;
    end
end

end

% % spatial-domain weights.
% [X,Y] = meshgrid(-w:w,-w:w);
% gs = exp(-(X.^2+Y.^2)/(2*sigma1^2));
% 
% %normalize images
% if isa(image1,'uint8')==1
%     image1=double(image1)/255;
% end
% 
% if isa(image2,'uint8')==1
%     image2=double(image2)/255;
% end

% %intialize img_out
% img_out=zeros(size(image1,1),size(image1,2),size(image1,3));
% %padd both iamges
% image1=padarray(image1,[w w],'replicate','both');
% image2=padarray(image2,[w w],'replicate','both');
% for i=ceil(n/2):size(image1,1)-w
%     for j=ceil(n/2):size(image1,2)-w
%         patch1(:,:,:)=image1(i-w:i+w,j-w:j+w,:);
%         patch2(:,:,:)=image2(i-w:i+w,j-w:j+w,:);
%         d=(repmat(image2(i,j,:),[n,n])-patch2).^2;
%         % intensity-domain weights. (range weights)
%         gr=exp(-(d)/(2*sigma2^2));
%         for c=1:size(image1,3)
%             g(:,:,c)=gs.*gr(:,:,c); %bilateral filter
%             normfactor=1/sum(sum(g(:,:,c))); %normalization factor
%             %apply equation:
%             %out[i]=normfactor*sum (kernel * image)
%             img_out(i-ceil(n/2)+1,j-ceil(n/2)+1,c)=...
%                 sum(sum(g(:,:,c).*patch1(:,:,c)))*normfactor;
%          %   imshow(img_out,[]);
%         end
%         
%     end
% end

