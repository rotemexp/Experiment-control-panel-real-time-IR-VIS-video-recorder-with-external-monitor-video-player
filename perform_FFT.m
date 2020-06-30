function SIG_pos = perform_FFT(signal)

    SIG = abs(fftshift(fft(signal))); % Performing FFT
    
    if mod(length(SIG),2) == 0 % checks if number of frames to process is even (0) or odd (1)
        SIG_pos = SIG(round(length(SIG)/2 + 1) : end); % taking only the positive frequancies data;
    else % case odd
        SIG_pos = SIG(round(length(SIG)/2) : end); % taking only the positive frequancies data
    end
    
end