% calculate contrast, correlation, energy, homogeneity, entropy and alpha
% Olga, 2014, BMC

close all
clear all

image = imread('C:\Users\Public\Pictures\Sample Pictures\Chrysanthemum.jpg'); % load image
[x y] = size(image); % (image must be cropped before it)
%image = imresize(image, [x x]); % resize image to maka it squared 
image = rgb2gray(image); % convert to gray scale

% calculate parameters
k=graycomatrix(image, 'offset', [0 1; -1 1; -1 0; -1 -1]);
stats = graycoprops(k,{'contrast','homogeneity','Correlation','Energy'});
ent = entropy(image);

[M N] = size(image);
imfft = fftshift(fft2(image));
imabs = abs(imfft);
abs_av=rotavg(imabs);
freq2=0:N/2;
xx=log(freq2(10:10^2));
yy=log(abs_av(freq2(10:10^2)));
p=polyfit(xx',yy,1);
alpha=(-1)*p(1);
% get a result of 6 parameters for 1 image
parameters = [mean(stats.Contrast) mean(stats.Correlation) mean(stats.Energy) mean(stats.Homogeneity) ent alpha]

