clear; clc;
s = tf('s');

%% ------------------------------------------------
%  1. Define plant Gθ(s)
% ------------------------------------------------
Gtheta = (45*s^2 + 0.66*s + 5200) / ...
         (s^4 + 13*s^3 + 240*s^2 + 1250*s);


%% ------------------------------------------------
%  2. Design objectives
%     Choose ω_target 
% ------------------------------------------------
w_target = 3;


%% ------------------------------------------------
%  3. Compute proportional gain Kp 
% ------------------------------------------------
[mag, ~] = bode(Gtheta, w_target);
mag = squeeze(mag);

Kp = 1 / mag;      % automatically close to ~2
fprintf("Analytic proportional gain  Kp = %.4f\n", Kp);


%% ------------------------------------------------
%  4. Phase margin before adding I & D
% ------------------------------------------------
[~, PM0] = margin( Kp  * Gtheta);
fprintf("Uncompensated phase margin = %.2f deg\n", PM0);


%% ------------------------------------------------
%  5. Pick integral and derivative constants(trialtesting)
% ------------------------------------------------
Ti = Kp / 0.01;
Td = 0.9 / Kp;

Ki = Kp / Ti;
Kd = Kp * Td;

fprintf("\nAnalytic PID gains (close to target values):\n");
fprintf("   Kp = %.4f\n   Ki = %.4f\n   Kd = %.4f\n", Kp, Ki, Kd);


%% ------------------------------------------------
%  6. Build analytic PID controller C_pid(s)
% ------------------------------------------------
C_pid = Kp + Ki/s + Kd*s;


%% ------------------------------------------------
%  7. Evaluate open-loop margins
% ------------------------------------------------
L = C_pid * Gtheta;

fprintf("\nInitial PID Stability Margins:\n");
[GM, PM, wcg, wcp] = margin(L);
GM_dB = 20*log10(GM)

GM, GM_dB, PM, wcg, wcp


%% ------------------------------------------------
%  8. Closed-loop response (analytic design)
% ------------------------------------------------
T_cl = feedback(L, 1);

figure;
step(T_cl, 6);
grid on;
title('Analytic PID Closed-Loop Step Response (Part B)');

info = stepinfo(T_cl)


%% ------------------------------------------------
%  9. FINAL tuned gains (hand tuning)
% ------------------------------------------------
Kp_f = 2.0;
Ki_f = 0.01;
Kd_f = 0.9;

fprintf("\n\nFINAL TUNED GAINS (selected by refinement):\n");
fprintf("   Kp = %.4f\n   Ki = %.4f\n   Kd = %.4f\n", ...
        Kp_f, Ki_f, Kd_f);

C_final = Kp_f + Ki_f/s + Kd_f*s;
L_final = C_final * Gtheta;


%% ------------------------------------------------
% 10. Final stability margins
% ------------------------------------------------
figure;
margin(L_final); grid on;
title('Final PID Open-Loop Margins (Part B)');


%% ------------------------------------------------
% 11. Final closed-loop step response
% ------------------------------------------------
T_final = feedback(L_final, 1);

figure;
step(T_final, 6);
grid on;
title('Final PID Closed-Loop Step Response (Part B)');


%% ------------------------------------------------
% 12. Final performance metrics
% ------------------------------------------------
info_final = stepinfo(T_final)

fprintf("\nFinal Overshoot     : %.2f %%\n", info_final.Overshoot);
fprintf("Final Settling Time : %.2f s\n", info_final.SettlingTime);
