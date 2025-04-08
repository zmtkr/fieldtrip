function test_pull2183

% MEM 1gb
% WALLTIME 00:10:00
% DEPENDENCY ft_read_headshape ft_read_headmodel
% DATA private

%%

mshdir = dccnpath('/project/3031000.02/test/pull2183/');

d = dir(fullfile(mshdir, '*.msh'));
for k = 1:numel(d)
  hs = ft_read_headshape(fullfile(d(k).folder, d(k).name), 'meshtype', 'tet');
  hs = ft_read_headshape(fullfile(d(k).folder, d(k).name), 'meshtype', 'tri');
end

%%

filename = dccnpath('/project/3031000.02/test/original/simnibs/v4/ernie.msh');
hm = ft_read_headmodel(filename, 'fileformat', 'simnibs', 'meshtype', 'tet');
hm = ft_read_headmodel(filename, 'fileformat', 'simnibs', 'meshtype', 'tri');

%%

filename = dccnpath('/project/3031000.02/test/original/simnibs/v3/ernie_v3.msh');
hm = ft_read_headmodel(filename, 'fileformat', 'simnibs', 'meshtype', 'tet');
hm = ft_read_headmodel(filename, 'fileformat', 'simnibs', 'meshtype', 'tri');

