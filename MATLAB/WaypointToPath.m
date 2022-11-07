function Path = WaypointToPath(p,METHOD,sizeX,sizeY,fineness)
% Interpolate the curve based on the discrete waypoints to generate a continuous path.

nP = size(p,1);
Path = [interp1(1:nP,p(:,1),linspace(1,nP,fineness)',METHOD,'extrap') interp1(1:nP,p(:,2),linspace(1,nP,fineness)',METHOD,'extrap')];

% This constrains the points to stay within the initial boundaries
Path(:,1) = min(Path(:,1),sizeX);
Path(:,1) = max(Path(:,1),0);
Path(:,2) = min(Path(:,2),sizeY);
Path(:,2) = max(Path(:,2),0);