function varargout = plot(f, varargin)
%surf3(x,y,z,varargin)
%PLOT   Plots a CHEBFUN3 object.
%   Plot(F) creates six contour plots at boundary cross sections 
%   of the domain of F.
% 
%   If F is complex-valued, then plot(F) plots six phase portraits at 
%   boundary cross sections.
%
%   PLOT(X,Y,Z,F) where X, Y, Z, and F are all CHEBFUN3 objects, plots F as
%   above but also allows for domains that are more general than the cube.
%
%   PLOT(X,Y,Z) puts F = Z, i.e., colors the plot according to the
%   Z-values. This is analogous to MATLAB's surf(x,y,z).
%
%   Example: 
%   plot(chebfun3(@(x,y,z) sin(i*x+z)+cos(y))); campos([-10 -11 -8])
%
% See also CHEBFUN3/SLICE, CHEBFUN3/SCAN, CHEBFUN3/ISOSURFACE, and 
% CHEBFUN3/SURF.

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

holdState = ishold;

% if nargin > 1
%     f = varargin{1};
%elseif nargin <= 2
if nargin <= 2
    h = plot3(f);
elseif nargin == 3
    x = f;
    y = varargin{1};
    z = varargin{2};
    h = surf3(x,y,z,f);
elseif nargin == 4
    x = f;
    y = varargin{1};
    z = varargin{2};
    f = varargin{3};
    h = surf3(x,y,z,f);
elseif nargin >= 5
    x = f;
    y = varargin{1};
    z = varargin{2};
    f = varargin{3};
    h = surf3(x,y,z,f);
end


if ( ~holdState )
    hold off
end
if ( nargout > 0 )
    varargout = {h};
end

end

function h = plot3(f)

dom = f.domain;
numpts = 151;
[xx, yy, zz] = meshgrid(linspace(dom(1), dom(2), numpts), ...
    linspace(dom(3), dom(4), numpts), linspace(dom(5), dom(6), numpts));
v = feval(f, xx, yy, zz);

% Slices are at the bounds of the cube:
xSlices = [dom(1) dom(2)];
ySlices = [dom(3) dom(4)];
zSlices = [dom(5) dom(6)];

if ( isreal(v) )
    h = slice(xx, yy, zz, v, xSlices, ySlices, zSlices); 
    shading interp
    colorbar
    axis(gca, 'tight')
else
    % Phase portraits if F is complex-valued:
    h = slice(xx, yy, zz, angle(-v), xSlices, ySlices, zSlices);
    set(h, 'EdgeColor','none')
    caxis([-pi pi])
    colormap('hsv')
    axis('equal') 
end

end
    
function h = surf3(x,y,z,f)
% d = x.domain;
% surf(x(d(1),:,:), y(d(1),:,:), z(d(1),:,:), f(d(1),:,:))
% hold on
% surf(x(d(2),:,:), y(d(2),:,:), z(d(2),:,:), f(d(2),:,:))
% surf(x(:,d(3),:), y(:,d(3),:), z(:,d(3),:), f(:,d(3),:))
% surf(x(:,d(4),:), y(:,d(4),:), z(:,d(4),:), f(:,d(4),:))
% surf(x(:,:,d(5)), y(:,:,d(5)), z(:,:,d(5)), f(:,:,d(5)))
% h = surf(x(:,:,d(6)), y(:,:,d(6)), z(:,:,d(6)), f(:,:,d(6)))
d = x.domain; d1 = d(1); d2 = d(2); d3 = d(3); d4 = d(4); d5 = d(5); 
d6 = d(6); 
feval(x,d1,:,:)

surf(feval(x,d1,:,:), feval(y,d1,:,:), feval(zd1,:,:), feval(f,d1,:,:))
hold on
surf(feval(x,d2,:,:), feval(y,d2,:,:), feval(z,d2,:,:), feval(f,d2,:,:))
surf(feval(x,:,d3,:), feval(y,:,d3,:), feval(z,:, d3, :), feval(f,:,d3,:))
surf(feval(x,:,d4,:), feval(y,:,d4,:), feval(z,:,d4,:), feval(f,:,d4,:))
surf(feval(x,:,:,d5), feval(y,:,:,d5), feval(z,:,:,d5), feval(f,:,:,d5))
h = surf(feval(x,:,:,d6), feval(y,:,:,d6), feval(z,:,:,d6), feval(f,:,:,d6))
hold off
end