function ft_plot_axes(object, varargin)

% FT_PLOT_AXES adds three axes of 150 mm and a 10 mm sphere at the origin to the
% present 3-D figure. The axes and sphere are scaled according to the units of the
% geometrical object that is passed to this function. Furthermore, when possible,
% the axes labels will represent the anatomical labels corresponding to the
% specified coordinate system.
%
% Use as
%   ft_plot_axes(object)
%
% Additional optional input arguments should be specified as key-value pairs
% and can include
%   'unit'       = string, plot axes that are suitable for the specified geometrical units (default = [])
%   'axisscale'  = scaling factor for the reference axes and sphere (default = 1)
%   'coordsys'   = string, assume the data to be in the specified coordinate system (default = 'unknown')
%   'transform'  = empty or 4x4 homogenous transformation matrix (default = [])
%   'fontcolor'  = string, color specification (default = [1 .5 0], i.e. orange)
%   'fontsize'   = number, sets the size of the text (default is automatic)
%   'fontunits'  =
%   'fontname'   =
%   'fontweight' =
%   'tag'        = string, the tag assigned to the plotted elements (default = '') 
%
% See also FT_PLOT_SENS, FT_PLOT_MESH, FT_PLOT_ORTHO, FT_PLOT_HEADSHAPE, FT_PLOT_DIPOLE, FT_PLOT_HEADMODEL

% Copyright (C) 2015-2021, Jan-Mathijs Schoffelen
%
% This file is part of FieldTrip, see http://www.fieldtriptoolbox.org
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id$

% get the optional input arguments
axisscale = ft_getopt(varargin, 'axisscale', 1); % this is used to scale the axmax and rbol
unit      = ft_getopt(varargin, 'unit');
coordsys  = ft_getopt(varargin, 'coordsys');
transform = ft_getopt(varargin, 'transform'); % the default is [], which means that no coordinate transformation is done
tag       = ft_getopt(varargin, 'tag', '');
% these have to do with the font
fontcolor   = ft_getopt(varargin, 'fontcolor', [1 .5 0]); % default is orange
fontsize    = ft_getopt(varargin, 'fontsize',   get(0, 'defaulttextfontsize'));
fontname    = ft_getopt(varargin, 'fontname',   get(0, 'defaulttextfontname'));
fontweight  = ft_getopt(varargin, 'fontweight', get(0, 'defaulttextfontweight'));
fontunits   = ft_getopt(varargin, 'fontunits',  get(0, 'defaulttextfontunits'));

% color management
if ischar(fontcolor), fontcolor = colorspec2rgb(fontcolor); end

if ~isempty(object) && ~isempty(unit)
  % convert the object to the specified units
  object = ft_convert_units(object, unit);
elseif ~isempty(object) &&  isempty(unit)
  % take the units from the object
  object = ft_determine_units(object);
  unit = object.unit;
elseif  isempty(object) && ~isempty(unit)
  % there is no object, but the units have been specified
elseif  isempty(object) &&  isempty(unit)
  ft_warning('units are not known, not plotting axes')
  return
end

if ~isempty(object) && ~isfield(object, 'coordsys')
  % set it to unknown, that makes the subsequent code easier
  object.coordsys = 'unknown';
end

if ~isempty(object) && ~isempty(coordsys)
  % check the user specified coordinate system with the one in the object
  assert(strcmp(coordsys, object.coordsys), 'coordsys is inconsistent with the object')
elseif ~isempty(object) &&  isempty(coordsys)
  % take the coordinate system from the object
  coordsys = object.coordsys;
elseif  isempty(object) && ~isempty(coordsys)
  % there is no object, but the coordsys has been specified
elseif  isempty(object) &&  isempty(coordsys)
  % this is not a problem per see
  coordsys = 'unknown';
end

axmax  = 150 * ft_scalingfactor('mm', unit);
radius =   5 * ft_scalingfactor('mm', unit);

% this is useful if the anatomy is from a non-human primate or rodent
axmax  = axisscale*axmax;
radius = axisscale*radius;

ft_info('The axes are %g %s long in each direction\n', axmax, unit);
ft_info('The diameter of the sphere at the origin is %g %s\n', 2*radius, unit);

% get the xyz-axes
xdat  = [-axmax 0 0; axmax 0 0];
ydat  = [0 -axmax 0; 0 axmax 0];
zdat  = [0 0 -axmax; 0 0 axmax];

% get the xyz-axes dotted
xdatdot = (-axmax:(axmax/15):axmax);
xdatdot = xdatdot(1:floor(numel(xdatdot)/2)*2);
xdatdot = reshape(xdatdot, [2 numel(xdatdot)/2]);
n       = size(xdatdot,2);
ydatdot = [zeros(2,n) xdatdot zeros(2,n)];
zdatdot = [zeros(2,2*n) xdatdot];
xdatdot = [xdatdot zeros(2,2*n)];

if ~isempty(transform)
  % apply the transformation to the elements that make the axes prior to plotting
  tmp = ft_warp_apply(transform, [xdat(:) ydat(:) zdat(:)]);
  xdat(:) = tmp(:,1);
  ydat(:) = tmp(:,2);
  zdat(:) = tmp(:,3);
  tmp = ft_warp_apply(transform, [xdatdot(:) ydatdot(:) zdatdot(:)]);
  xdatdot(:) = tmp(:,1);
  ydatdot(:) = tmp(:,2);
  zdatdot(:) = tmp(:,3);
end

if ~isempty(transform)
  xcolor = 0.4*[1 0 0] + 0.4*[1 1 1]; % somewhat red
  ycolor = 0.4*[0 1 0] + 0.4*[1 1 1]; % somewhat green
  zcolor = 0.4*[0 0 1] + 0.4*[1 1 1]; % somewhat blue
else
  xcolor = [1 0 0]; % red
  ycolor = [0 1 0]; % green
  zcolor = [0 0 1]; % blue
end

% everything is added to the current figure
holdflag = ishold;
if ~holdflag
  hold on
end

% plot axes
hl = line(xdat, ydat, zdat);
set(hl(1), 'linewidth', 1, 'color', xcolor, 'tag', tag);
set(hl(2), 'linewidth', 1, 'color', ycolor, 'tag', tag);
set(hl(3), 'linewidth', 1, 'color', zcolor, 'tag', tag);
hld = line(xdatdot, ydatdot, zdatdot);
for k = 1:n
  set(hld(k    ), 'linewidth', 3, 'color', xcolor, 'tag', tag);
  set(hld(k+n*1), 'linewidth', 3, 'color', ycolor, 'tag', tag);
  set(hld(k+n*2), 'linewidth', 3, 'color', zcolor, 'tag', tag);
end

% create the sphere at the origin
[sphere.pos, sphere.tri] = mesh_sphere(42);
sphere.pos = sphere.pos.*radius;

if ~isempty(transform)
  % apply the transformation to the sphere prior to plotting
  sphere.pos = ft_warp_apply(transform, sphere.pos);
end

ft_plot_mesh(sphere, 'edgecolor', 'none', 'tag', tag);

% create the labels that are to be plotted along the axes
[labelx, labely, labelz] = coordsys2label(coordsys, 3, 1);

% add the labels to the axis
text(xdat(1,1), ydat(1,1), zdat(1,1), labelx{1}, 'linewidth', 2, 'color', fontcolor, 'fontunits', fontunits, 'fontsize', fontsize, 'fontname', fontname, 'fontweight', fontweight, 'tag', tag);
text(xdat(1,2), ydat(1,2), zdat(1,2), labely{1}, 'linewidth', 2, 'color', fontcolor, 'fontunits', fontunits, 'fontsize', fontsize, 'fontname', fontname, 'fontweight', fontweight, 'tag', tag);
text(xdat(1,3), ydat(1,3), zdat(1,3), labelz{1}, 'linewidth', 2, 'color', fontcolor, 'fontunits', fontunits, 'fontsize', fontsize, 'fontname', fontname, 'fontweight', fontweight, 'tag', tag);
text(xdat(2,1), ydat(2,1), zdat(2,1), labelx{2}, 'linewidth', 2, 'color', fontcolor, 'fontunits', fontunits, 'fontsize', fontsize, 'fontname', fontname, 'fontweight', fontweight, 'tag', tag);
text(xdat(2,2), ydat(2,2), zdat(2,2), labely{2}, 'linewidth', 2, 'color', fontcolor, 'fontunits', fontunits, 'fontsize', fontsize, 'fontname', fontname, 'fontweight', fontweight, 'tag', tag);
text(xdat(2,3), ydat(2,3), zdat(2,3), labelz{2}, 'linewidth', 2, 'color', fontcolor, 'fontunits', fontunits, 'fontsize', fontsize, 'fontname', fontname, 'fontweight', fontweight, 'tag', tag);

if ~holdflag
  hold off
end

if isfield(object, 'coordsys')
  % add a context sensitive menu to change the 3d viewpoint to top|bottom|left|right|front|back
  menu_viewpoint(gca, object.coordsys)
end
