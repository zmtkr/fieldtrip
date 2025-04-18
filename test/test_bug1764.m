function test_bug1764

% MEM 1gb
% WALLTIME 00:10:00
% DEPENDENCY ft_prepare_singleshell ft_prepare_mesh
% DATA public

% This test is inspired by test test_tutorial_beamformer20120321 which uses
% a call to ft_prepare_singleshell without specifying any cfg options. The
% idea is of course to get a singleshell headmodel based on the brain. This
% should not take long. If it does, it might be because ft_prepare_mesh is
% meshing the complex gray, white and csf segmentations rather than the
% simple brain.

load(dccnpath('/project/3031000.02/external/download/tutorial/beamformer/segmentedmri.mat'));

stopwatch = tic;

cfg = [];
cfg.method = 'singleshell';
headmodel = ft_prepare_headmodel(cfg, segmentedmri);

elapsed = toc(stopwatch);

if elapsed>60
  error('ft_prepare_headmodel took too long, probably due to ft_prepare_mesh');
end
