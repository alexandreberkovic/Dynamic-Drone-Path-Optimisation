 function [h1,g1,g2,g3,g4] = nlcon(V_wind)
%  those are the linear and non-linear constraints useful tout our
%  optimisation problem
    h1 = ((V_wind(1)).^2 + (V_wind(2)).^2).^0.5 - 30 ;
    g1 = V_wind(1) - 20;
    g2 = V_wind(2) - 20;
    g3 = V_wind(1) + 20;
    g4 = V_wind(2) + 20;
end
