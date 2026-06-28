
clear; clc;
s = tf('s');
kd = 2.5;
kp = 30;
%% ------------------------------------------------
%  1. Define plant Gθ(s)
% ------------------------------------------------
Gtheta = (45*s^2 + 0.66*s + 5200) / (s^4 + 13*s^3 + 240*s^2 + 1250*s);


%% ------------------------------------------------
%  2. Choose desired closed-loop bandwidth
% ------------------------------------------------
w_target = 3;   % rad/s


%% ------------------------------------------------
%  3. Compute |G(jw)| and Kc
% ------------------------------------------------
[mag, ~] = bode(Gtheta, w_target);
mag = squeeze(mag);
Kc = 1 / mag;         % Gain to force crossover ≈ w_target

fprintf("Chosen proportional gain Kc = %.4f\n", Kc);


%% ------------------------------------------------
%  4. Compute current phase margin with Kc
% ------------------------------------------------
[GM, PM, wcg, wcp] = margin(Kc * Gtheta);

fprintf("Current Phase Margin (deg) = %.2f\n", PM);


%% ------------------------------------------------
%  5. Desired Phase Margin
% ------------------------------------------------
PM_des = 55;                        
phi_needed = PM_des - PM;           % phase differnce

fprintf("Required additional phase (deg) = %.2f\n", phi_needed);


%% ------------------------------------------------
%  6. Compute alpha using formula
% ------------------------------------------------
phi_rad = deg2rad(phi_needed);
alpha = (1 + sin(phi_rad)) / (1 - sin(phi_rad));

fprintf("Alpha = %.4f\n", alpha);


%% ------------------------------------------------
%  7. Find ωm  
% ------------------------------------------------
GdB = -10 * log10(alpha); 

w = logspace(-2, 2, 2000);
[magL, ~] = bode(Kc * Gtheta, w);
magL = squeeze(20 * log10(magL));

[~, idx] = min(abs(magL - GdB));
wm = w(idx);

fprintf("Chosen omega_m = %.4f rad/s\n", wm);


%% ------------------------------------------------
%  8. Compute T 
% ------------------------------------------------
T = 1 / (wm * sqrt(alpha));

fprintf("T = %.4f\n", T);


%% ------------------------------------------------
%  9. Build lead compensator
%    
% ------------------------------------------------
C_lead = (1 + alpha*T*s) / (1 + T*s);


%% ------------------------------------------------
%  10. Final controller 
%      
% ------------------------------------------------
C = Kc * C_lead;

%stability margins
L = C * Gtheta;      % open-loop transfer function

[GM, PM, wcg, wcp] = margin(L);
GM_dB = 20*log10(GM);

GM, GM_dB, PM, wcg, wcp

figure;
margin(L);
grid on


fprintf("\nFINAL CONTROLLER:\n");
C
disp(' ');

fprintf("Numerator coeffs:   [%.4f   1]\n", alpha*T);
fprintf("Denominator coeffs: [%.4f   1]\n", T);
% ---- Open-loop transfer functions -----------------------------
L_uncomp = Kc * Gtheta;      % Uncompensated open-loop
L_comp   = C * Gtheta;       % Compensated open-loop

% ---- Bode Plot ------------------------------------------------
figure;
bode(L_uncomp, 'b', L_comp, 'r--', {0.01, 100});
legend('Uncompensated: K_c G_\theta(s)', ...
       'Compensated: C(s)G_\theta(s)', ...
       'Location', 'best');
grid on;
title('Bode Plot Comparison: Uncompensated vs Compensated Open-Loop');
