function [signal_filt]=HighPassFilter(signal)
%High-pass filter: Butterworth filter
%Signal: single-vector ephys data
%Signal_filt: filtered data

Fs = 2000;  % Sampling Frequency
Fstop = 10;  % Stopband Frequency
Fpass = 30;  % Passband Frequency
Astop = 80;  % Stopband Attenuation (dB)
Apass = 1;   % Passband Ripple (dB)

% Calculate the order from the parameters using BUTTORD.
[N,Fc] = buttord(Fpass/(Fs/2), Fstop/(Fs/2), Apass, Astop);

% Calculate the butterworth filter params using the BUTTER function.
[B,A] = butter(N, Fc, 'high');

signal_filt=filtfilt(B,A,signal);
