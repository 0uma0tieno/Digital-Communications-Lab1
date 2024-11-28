clear all;
close all;
clc;

tot=1;      %sampling duration
td=0.002;   %sampling period
t=0:td:tot; %time vector from 0 to 1 with steps 0.002
x=sin(2*pi*t)-sin(6*pi*t);  %input signal

%plot input signal
figure;
plot(t,x,'LineWidth',2); 
xlabel('Time(s)');
ylabel('Amplitude');
title('Input Message Signal');
grid on;

%compute input signal spectrum & plotting it
L=length(x);            %lenght of the signal
Lfft=2^nextpow2(L);     %optimal fft size
fmax=1/(2*td);          %nyquist freq
Faxis=linspace(-fmax,fmax,Lfft);
xfft=fftshift(fft(x,Lfft)); %shifting the 0 freq to the centre

figure;
plot(Faxis,abs(xfft));
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('Spectrum of Input Message Signal');
grid on;

%sampling the signal & plotting it
ts=0.02;
n=0:ts:tot;     %sampled time vector
x_sampled=sin(2*pi*n)-sin(6*pi*n);

figure;
stem(n,x_sampled,'LineWidth',2);
xlabel('Time(s)');
ylabel('Amplitude');
title('Sampled Signal');
grid on;

%upsampling and computing the spectrum of the sampled signal
x_sampled_upsampled=upsample(x_sampled,round(ts/td)); %upsample the original signal by adding zeros between the original samples 
Lfftu=2^nextpow2(length(x_sampled_upsampled));
fmaxu=1/(2*td);
Faxisu=linspace(-fmaxu,fmaxu,Lfftu);
Xfftu=fftshift(fft(x_sampled_upsampled,Lfftu));

%plotting the spectrum of the sampled signal
figure;
plot(Faxisu, abs(Xfftu));
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('Spectrum of sampled signal');
grid on;
% Define quantization levels
levels = 16;
x_min = min(x_sampled);
x_max = max(x_sampled);
step = (x_max - x_min) / levels;
% Quantize the sampled signal
x_quantized = step * round((x_sampled - x_min) / step) + x_min;
% Plot quantized vs. sampled signal
figure;
stem(n, x_sampled, 'r', 'LineWidth', 1.5); hold on;
stem(n, x_quantized, 'b--', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sampled Signal vs. Quantized Signal');
legend('Sampled Signal', 'Quantized Signal');

grid on;
% Quantization error
quantization_error = x_sampled - x_quantized;
figure;
stem(n, quantization_error, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Error');
title('Quantization Error');
grid on;
