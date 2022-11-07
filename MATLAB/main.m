clear; clf;

DroneSpeed = 15;
sizeX = 40;
sizeY = 20;
numWayPoints = 3;
rng(25);

W_x = WindField(sizeX,sizeY);
W_y = WindField(sizeX,sizeY);

[Xgrid,Ygrid] = meshgrid(0:sizeX,0:sizeY);
hq = quiver(Xgrid,Ygrid,W_x,W_y,'k');
hold on;
xlabel('Units = 100 [m]');
axis equal tight
plot([0 sizeX],[sizeY sizeY]/2,'k.','markersize',16)

%% Add some color to make it more visible
L = (sqrt((Xgrid-sizeX).^2 + (Ygrid-sizeY/2).^2));
Favorability = 0.1.*((sizeX-Xgrid).*W_x +  (sizeY/2-Ygrid).*W_y)./L; 
Favorability(~isfinite(Favorability)) = 0; 

hold on;
h_im = imagesc(Favorability); % This will be the background for the vector field

set(h_im,'Xdata',[0 sizeX],'Ydata',[0 sizeY]);
uistack(h_im,'bottom');

h_colorbar = colorbar;
title(h_colorbar,'Tailwind (km/h)')
xlabel(h_colorbar,'Headwind')
%% Generate a default set of way points
xWayPoints = linspace(0,sizeX,numWayPoints+2)';
yWayPoints = sizeY/2 * ones(numWayPoints+2,1);

h_wp = plot(xWayPoints,yWayPoints,'color','k','linestyle','none','marker','.','markersize',16);

%% Generate a continuous path from the waypoints
Path = WaypointToPath([xWayPoints,yWayPoints],'linear',sizeX,sizeY,101);
h_path = plot(Path(:,1),Path(:,2),'k','linewidth',2);

%% Calculate the time taken:
StraightLineTime = TimeFromPath(Path,W_x,W_y,DroneSpeed);

% Display in Hours/Minutes
fprintf('Straight Line Travel Time: %d hours, %.1f minutes\n',floor(StraightLineTime),rem(StraightLineTime,1)*60);

%% For example, a different set:
% Randomly choose waypoints
xWayPoints = linspace(0,sizeX,numWayPoints+2)' .* (1+0.05*randn(size(xWayPoints)));
yWayPoints = sizeY/2 + (0.1*sizeY*randn(numWayPoints+2,1));
xWayPoints([1 end]) = [0 sizeX];
yWayPoints([1 end]) = sizeY/2;

%Plot them
delete([h_wp h_path]);
h_wp = plot(xWayPoints,yWayPoints,'color','k','linestyle','none','marker','.','markersize',16);

% Generate a continuous path from the waypoints
Path = WaypointToPath([xWayPoints,yWayPoints],'pchip',sizeX,sizeY,101);
h_path = plot(Path(:,1),Path(:,2),'k','linewidth',2);

LineTime = TimeFromPath(Path,W_x,W_y,DroneSpeed);
fprintf('Travel Time: %d hours, %.1f minutes\n',floor(LineTime),rem(LineTime,1)*60);

%% Find an optimal path using FMINCON
% Define Objective Function
% Method was set as pchip as it was shown to be more efficient than spline
% or makima
objectiveFun = @(P) TimeFromPath(P,W_x,W_y,DroneSpeed,sizeX,sizeY,'pchip');

% Set optimization options
% This used for fmincon method with an SQP algorithm
opts = optimset('fmincon');
opts.Display = 'iter';
opts.Algorithm = 'sqp'; % change to interior-point, active-set or sqp-legacy
opts.MaxFunEvals = 2000;

% Initial Conditions
xWayPoints = linspace(0,sizeX,numWayPoints+2)';
yWayPoints = sizeY/2 * ones(numWayPoints+2,1);
ic = [xWayPoints(2:end-1)'; yWayPoints(2:end-1)'];
ic = ic(:);

% Bounds & constraints
lb = zeros(size(ic(:)));
ub = reshape([sizeX*ones(1,numWayPoints); sizeY*ones(1,numWayPoints)],[],1);
nonlincon = @nlcon;

% As follows are both optimisation methods presented, uncomment one or the
% other to run them in the solver !

% Do the optimizaiton for fmincon
optimalWayPoints = fmincon(objectiveFun, ic(:), [],[],[],[],lb,ub,nonlincon,opts);

% Do the optimisation for genetic algorithm
% optimalWayPoints = ga(objectiveFun, 6, [],[],[],[],lb,ub,nonlincon, opts);
%% Plot the optimal solution:
delete([h_wp h_path]);
optimalWayPoints = [0 sizeY/2; reshape(optimalWayPoints,2,[])'; sizeX sizeY/2];

xWayPoints = optimalWayPoints(:,1);
yWayPoints = optimalWayPoints(:,2);
h_wp = plot(xWayPoints,yWayPoints,'color','k','linestyle','none','marker','.','markersize',16);

Path = WaypointToPath([xWayPoints,yWayPoints],'pchip',sizeX,sizeY,101);
h_path = plot(Path(:,1),Path(:,2),'k','linewidth',2);
LineTime = TimeFromPath(Path,W_x,W_y,DroneSpeed);
fprintf('Optimal Travel Time: %d hours, %.2f minutes\n',floor(LineTime),rem(LineTime,1)*60);