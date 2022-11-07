function TravelTime = TimeFromPath(Path,W_x,W_y,AirSpeed,sizeX,sizeY,METHOD)
% This is the main function (objective function for the optimizer) that 
% actually calculates the line integral along the path. 

% If we are called from the optimization routine (caller = 'optimizer')
% then we need to interpolate the fine path from the input control points.
if isvector(Path)
    Path = [0 sizeY/2; reshape(Path,2,[])'; sizeX sizeY/2];
    Path = WaypointToPath(Path,METHOD,sizeX,sizeY,101);
end

% calculates differences between adjacent elements of Path along the first array dimension whose size does not equal 1:
dP = diff(Path);

% Interpolate the wind vector field at all the points in Path.
% interp2 performs the interpolation for 2-D gridded data in meshgrid
% The method is formulated as: Vq = interp2(V,Xq,Yq)
% The default grid points cover the rectangular region, X=1:n and Y=1:m, where [m,n] = size(V)
% Interpolation method used here is linear
V_wind = [interp2(W_x,Path(1:end-1,1)+1,Path(1:end-1,2)+1,'linear') interp2(W_y,Path(1:end-1,1)+1,Path(1:end-1,2)+1,'*linear')];

% Dot product the wind (Vwind) with the direction vector (dP) to get
% the tailwind/headwind contribution
V_add = (sum(V_wind.*dP,2))./sqrt(sum(dP.^2,2));
dx = sqrt(sum(dP.^2,2)); %dx is the length of each subinterval in Path
dt = dx./(10*AirSpeed+V_add);  %dT = dP/dV
TravelTime = sum(abs(dt));