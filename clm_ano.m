function [data_clm, data_ano] = clm_ano(data, din, yrs, yrcs, yrcd)
% CLM_ANO is a simple function to calculate Climatology and Anomaly (remove 
% annual cycle)
%
% Syntax and Description
% [data_clm, data_ano] = CLM_ANO(data, din, yrs, yrcs, yrcd)
%
% INPUTS:
%   data     - monthly data
%   din      - time dimension of data for calculation
%   yrs      - year (time) of first monthly data point
%   yrcs     - first year of period for calulating climatology
%   yrcd     - last year of period for calulating climatology
%
% OUTPUTS:
%   data_clm - climatology of each months
%   data_ano - anomaly of original data
%
% Example:
%   Monthly sea surface temperature as an example
%   index = CLM_ANO(sst, 3, 1854, 1981, 2010)
% 
%   sst      - 180 (longitude) x 89 (latitude) x 2004 (monthly)
%   sstc     - 180 (longitude) x 89 (latitude) x 12 (months)
%   ssta     - same as sst, but for anomaly
%   data     - ERSST-v5 (monthly sea surface temperature, sst, from
%              1854/1 to 2020/12)
%
% See also MEAN
%
% Testing version
% Date          : May. 3, 2022
% Matlab version: 9.11.0.1769968(R2021b)
% Flat          : CentOS Linux release 8.5.2111
% 
% Written by
% A.-Y. HUANG
% Email: b810641@gmail.com
% ORCiD: https://orcid.org/0000-0003-2872-2294

% data input examination
nt = size(data, din);
if mod(nt, 12) ~= 0
    error('Length of the time dimension must be multiples of 12 (monthly).');
end

% dimensions
nd = size(data);
ndt = nd; ndt(:) = 1; ndt(din) = nt/12;
ndc = nd; ndc(din) = 12;
cnd = repmat({':'}, 1, ndims(data));
cndc = cnd;

% monthly climatology
data_clm = nan(ndc);
for imn = 1:1:12
    cnd{din} = (yrcs-yrs)*12+imn : 12 : (yrcd-yrs+1)*12;
    cndc{din} = imn;
    data_clm( cndc{:} ) = mean( data( cnd{:} ), din, 'omitnan');
end

% monthly anomaly
data_ano = nan(nd);
for imn = 1:1:12
    cnd{din} = imn:12:nt;
    cndc{din} = imn;
    dcin = repmat(data_clm( cndc{:} ), ndt);
    data_ano( cnd{:} ) = data( cnd{:} ) - dcin;
end






