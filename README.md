# mono-lake
Determining the fate of water level in Mono Lake, California using differences between Qin and Qout

%% Mono Lake Final Model --- created by Josh Himmelstein, March 3rd 2016
%% A model (either deterministic or stochastic, depending on users choice)
%% of the recovery of Mono Lake post 1994 for comparison with observed recovery in order 
%% to determine whehter the expected recovery given in court by Los Angeles was a fair expecation.
%% This model uses varying diversion values based on the elevation of Mono Lake

%% This program will read excel data, transform water level into a volume 
%% based on a given equation and determine the change in this volume
%% through time, using read data on inflows and outflows (calculated based on lake elevation and surface area)
%% This script refers to three functions: elev2vol.m to convert a given initial elevation into a volume of 
%% the lake, and vol2area.m to convert this volume into a surface area of Mono Lake for use in calculation
%% of Precipitation and Evapotranspiration quantities, and divers.m to determine diversion allowance.
