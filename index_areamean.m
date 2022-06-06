function index = index_areamean(data, lon, lat, sw, ne)
% INDEX_AREAMEAN is a simple function to calculate time series by averaging
% values in a specific area (e.g. Nino3, Nino3.4, Nino4, ...).
% 
% Syntax and Description
% index = INDEX_AREAMEAN(data, lon, lat, sw, ne)
%
% INPUTS:
%   data  - 3D data: lon x lat x time
%   lon   - longitude grid (must be 0E~360E)
%   lat   - latitude grid
%   sw    - south-west [lon, lat]
%   ne    - north-east [lon, lat]
%
% OUTPUTS:
%   index - one-dimension time series
%
% Example:
%   Nino3.4 as an example (170W-120W, 5S-5N)
%   index = INDEXAY(ssta, lon, lat, [190 -5], [240 5])
% 
%   ssta  - 180 (longitude) x 89 (latitude) x 2004 (monthly)
%   lon   - [0,2,4,6,8,...,358]
%   lat   - [-88,-86,-84,...,86,88]
%   data  - ERSST-v5 (monthly sea surface temperature anomaly, ssta, from
%           1854/1 to 2020/12)
%
% See also MEAN, NANMEAN
%
% Testing version
% Date          : Feb. 18, 2022
% Matlab version: 9.11.0.1769968(R2021b)
% Flat          : CentOS Linux release 8.5.2111
% 
% Written by
% A.-Y. HUANG
% Email: b810641@gmail.com
% ORCiD: https://orcid.org/0000-0003-2872-2294

st=size(data);
if length(st)>3
    error('data input must be 3D: lon x lat x time');
end

nlon=length(data(:,1,1));
nlat=length(data(1,:,1));
if (nlon~=size(lon,1)) || (nlat~=size(lat,1))
    error('data size must be same as lon and lat');
end
nt=length(data(1,1,:));

nsw=size(sw,2);
if (nsw~=2)
    error('SW must be southwestern corner of [lon, lat]');
end
nne=size(ne,2);
if (nne~=2)
    error('NE must be northeastern corner of [lon, lat]');
end

[swv,nswlon]=min(abs(lon-sw(1))); %disp(nswlon);
[swv,nswlat]=min(abs(lat-sw(2))); %disp(nswlat);
[nev,nnelon]=min(abs(lon-ne(1))); %disp(nnelon);
[nev,nnelat]=min(abs(lat-ne(2))); %disp(nnelat);

index=nan(nt,1);
for it=1:1:nt
    if nnelat>nswlat
        index(it,1)=mean(mean(data(nswlon:nnelon,nswlat:nnelat,it),1,'omitnan'),2,'omitnan');
        % NANMEAN function for older version of MATLAB
        % index(it,1)=nanmean(nanmean(data(nswlon:nnelon,nswlat:nnelat,it),1),2);
        % NANMEAN_OLD function for the oldest version of MATLAB
        % index(it,1)=nanmean_old(data(nswlon:nnelon,nswlat:nnelat,it));
        if it==1
            dfn=['LON: ',num2str(lon(nswlon,1)),' to ',num2str(lon(nnelon,1)),',  LAT: ',...
                num2str(lat(nswlat,1)),' to ',num2str(lat(nnelat,1))];
            disp(dfn);
        end
    else
        index(it,1)=mean(mean(data(nswlon:nnelon,nnelat:nswlat,it),1,'omitnan'),2,'omitnan');
        % NANMEAN function for older version of MATLAB
        % index(it,1)=nanmean(nanmean(data(nswlon:nnelon,nswlat:nnelat,it),1),2);
        % NANMEAN_OLD function for the oldest version of MATLAB
        % index(it,1)=nanmean_old(data(nswlon:nnelon,nswlat:nnelat,it));
        if it==1
            dfn=['LON: ',num2str(lon(nswlon,1)),' to ',num2str(lon(nnelon,1)),',  LAT: ',...
                num2str(lat(nswlat,1)),' to ',num2str(lat(nnelat,1))];
            disp(dfn);
        end
    end
end
