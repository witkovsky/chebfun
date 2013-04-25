function varargout = chebpolyplot(f, varargin)
%CHEBPOLYPLOT   Display Chebyshev coefficients graphically.
%
%   CHEBPOLYPLOT(F) plots the Chebyshev coefficients of a CHEBTECH F on a
%   semilogy scale. A horizontal line at the EPSLEVEL of F is also plotted. If F
%   is a vectorised CHEBTECH then a curve is plotted for each component (column)
%   of F.
%
%   CHEBPOLYPLOT(F, S) allows further plotting options, such as linestyle,
%   linecolor, etc, in the standard MATLAB manner. If S contains a string
%   'LOGLOG', the coefficients will be displayed on a log-log scale. If S
%   contains a string 'NOEPSLEVEL', the EPSLEVEL is not plotted.
%
%   H = CHEBPOLYPLOT(F) returns a column vector of handles to lineseries
%   objects. The final entry is that of the EPSLEVEL plot.
%
% See also CHEBPOLY, PLOT.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Deal with an empty input:
if ( isempty(f) )
    if ( nargout == 1 )
        varargout{1} = plot([]);
    end
    return
end

% Set defaults:
loglogPlot = false;
plotEpsLevel = true;

% Copy input arguments:
args = varargin;

% Check inputs for 'loglog' or 'noepslevel'.
j = 1;
while ( j <= length(args) )
    if ( strcmpi(args{j},'loglog') )
        loglogPlot = true; 
        args(j) = [];
    elseif ( strcmpi(args{j},'noepslevel') )
        plotEpsLevel = false; 
        args(j) = [];
    else
        j = j + 1;
    end
end

% Store the hold state of the current axis:
holdState = ishold;

% The coefficients:
absc = abs(f.coeffs);

% Add a tiny amount to zeros to make plots look nicer:
% absc(~absc) = eps*max(absc(:));
absc(~absc) = f.epslevel*min(f.vscale);

% Get the size:
[n, m] = size(absc);

if ( plotEpsLevel )
    % Plot the coeffs AND the epslevel:
    h = semilogy(n-1:-1:0, absc, args{:});
    hold on
    h2 = semilogy([0 n-1], repmat(f.vscale, 2, 1)*f.epslevel, args{:});
    h = [h ; h2];
    for k = 1:m
        c = get(h(k), 'color');
%         set(h(m+k), 'linestyle', ':', 'linewidth', 2, 'marker', 'none', 'color', c);
        set(h(m+k), 'marker', 'none', 'color', c);
    end
else
    % Plot just the coefficients:
    h = semilogy(n:-1:1, absc, args{:});
end

% For constant functions, plot a dot:
if ( n == 1 )
    set(h, 'marker', 'o');
end

% Do a loglog plot:
if ( loglogPlot )
    set(gca, 'XScale', 'log')
end

% Return hold state to what it was before:
if ( ~holdState )
    hold off
end

% Give an output if one was requested:
if ( nargout > 0 )
    varargout{1} = h;
end

end