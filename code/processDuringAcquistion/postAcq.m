function postAcq
% default post acquisition function for syncAndCrunch
%
% function postAcq
%
% Purpose
% This is the default function that runs when syncAndCrunch finishes.
% The function performs two tasks:
% 1) Looks for missing tiles if this was a TissueCyte experiment.
% 2) Stitches all data from the current experiment.
%
% This is an example function, you may write your own version of it and 
% have it run by changing the postAcqFun variable in the INI file. Your
% function should take no input arguments. Place your post-acquisition 
% function file in your MATLAB path but *not* in the StitchIt install path, 
% or you will run into problems pulling changes. 
%
% Do not edit this file unless you know what you're doing.
%
%
% Rob Campbell - Basel 2015


M=readMetaData2Stitchit;

%check for and fix missing tiles if this was a TissueCyte acquisition
if strcmp(M.System.type,'TissueCyte')
    missingTiles=identifyMissingTilesInDir('rawData',0);
else
    missingTiles = -1;
end

if iscell(missingTiles) && ~isempty(missingTiles)
    fname='missingTiles.mat';
    fprintf('Found and fixed %d missing tiles. Saving missing tile list to %s\n', ...
        length(missingTiles), fname);
    save(fname,'missingTiles')
elseif iscell(missingTiles) && isempty(missingTiles)
    fprintf('Searched for missing tiles but did not find any\n')
elseif ~iscell(missingTiles) && missingTiles == -1
    %nothing happens. No TissueCyte.
end


%-----------------------------------------------------
%attempt to stitch all the data
collateAverageImages % Ensure all are collated
stitchAllChannels
%-----------------------------------------------------

