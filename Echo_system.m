%****getting the input audio****%
[x,FS] = audioread('Example.mp3');
%since the audio is stored in two columns to reperesnets the two channels
%so we take only one column i.e. channel and transpose
x=transpose(x);
x=[x(1,:)];
%get the length of the audio after transpose 
xlen = length(x);
%get the period of the audio in seconds to use it later
T = xlen/FS;
%****designing the echo system****%
delay1 = 0.3*FS;
mag1 = 0.8;
delay2 = 0.3*FS;
mag2 = 0.5;
delay3 = 0.5*FS;
mag3 = 0.3;
%getting the impulse train
%h = [1,zeros(1,delay1),mag1,zeros(1,delay2),mag2,zeros(1,delay3),mag3];

%Choose the strength of the echo and then get the impulse train
prompt = ['Enter the strength\n 1. strong. 2.medium. 3.weak.\n'];
strength = input(prompt);
switch(strength)
    case(1)
        h = [1,zeros(1,delay1),mag1,zeros(1,0.2*FS),mag3];
    case(2)
        h = [1,zeros(1,delay2),mag2];
    case(3)
        h = [1,zeros(1,delay3),mag3];
    otherwise
        disp('Invalid choice, choosing Strong');
        strength = 1;
        h = [1,zeros(1,delay1),mag1];
end

%****getting the echo****%
hlen = length(h);
%getting the length of the impulse train
Lout = xlen+hlen-1;
%getting the fourier transform of input and the impulse train
X = fft(x,Lout);
H = fft(h,Lout);
%apply the convolution in frequency domain
Y = X.*H;
%getting the inverse transform of the output
y = ifft(Y);
%play and save the audio output
sound(y,FS);
switch(strength)
    case(1)
        audiowrite('Strong_Echo.wav',y,FS);
    case(2)
        audiowrite('medium_Echo.wav',y,FS);
    case(3)
        audiowrite('weak_Echo.wav',y,FS);     
end
%pause the system for a period equals the audiofile to prevenet
%interference 
pause(T);

%****getting the deEcho*****%
%getting the inverse of the transfer function in frequency domain
H_inv = 1./H;
%getting the deconvolution in frequency domain to restore the input
W = Y.*H_inv;
%getting the inverse fourier transform of the output
w = ifft(W);
%play and save the audio output
sound(w,FS);
switch(strength)
    case(1)
        audiowrite('Strong_deEcho.wav',w,FS);
    case(2)
        audiowrite('medium_deEcho.wav',y,FS);
    case(3)
        audiowrite('weak_deEcho.wav',y,FS);     
end