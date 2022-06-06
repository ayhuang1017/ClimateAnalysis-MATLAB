function [mr, tv, ytinf, ytinfm] = reg_coef(xtin, ytin)
% REG_COEF is a function to calculate regression coefficient whether
% simple or multiple (partial) regression.
%
% Syntax and Desctription
% [mr, tv, ytinf, ytinfm] = REG_COEF(xtin, ytin)
% 
% INPUTS:
%   xtin   - independent variables (can be single or multiple, X)
%   ytin   - dependent variable (response variable, Y)
% 
%   simple linear regression:   Y = a + bX + res.
%   multiple linear regression: Y = a + b1X1 + b2X2 + ... + res.
% 
% Outputs:
%   mr     - regression coefficients
%   tv     - t-value (by Student's t-test)
%   ytinf  - dependent variable predicted by each xtin
%   ytinfm - dependent variable predicted by xtin (multiple prediction)
%
% Example:
%   Simple linear regression of AUSMI against Nino3.4 index
%   [mr, tv, ytinf] = REG_COEF(n34, ausmi)
%
%   n34    - Nino3.4 Index
%   ausmi  - AUStralian Monsoon Index
%
%   Multiple linear regression of AUSMI against Nino3.4 & IOD index
%   [mr, tv, ytinf, ytinfm] = REG_COEF( [n34, iod] , ausmi)
%
%   n34    - Nino3.4 Index
%   iod    - Indian Ocean Diople Index
%   ausmi  - AUStralian Monsoon Index
%
% See also REGRESS, FITLM, TTEST
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

% input
nt = size(xtin,1);
nd = size(xtin,2);
din = 1:1:nd;

% single or multiple regression determination
xtinr = nan(size(xtin));
if nd > 1
    %disp('Multiple Linear Regression Process: Y = a + b1X1 + b2X2 + ... + res.');

    % remove indices from each other
    for id = 1:1:nd
        xin0 = [ones(nt,1), xtin(:,din~=id)];
        yin0 = xtin(:,id);
        xp0 = xin0\yin0;
        yin0f = xin0*xp0;
        xtinr(:,id) = xtin(:,id)-yin0f;
    end
else
    %disp('Single Linear Regression Process: Y = a + bX + res.');

    xtinr = xtin;
end

% single regression function
ytinf = nan(size(xtin));
mr = nan(nd,1);
tv = nan(nd,1);
for id=1:1:nd
    xtind(:,1) = xtinr(:,id);
    xin = [ones(nt,1), xtind];
    yin = ytin;
    xp = xin\yin;
    yinf = xin*xp;

    % t-test (two-tail)
    xs = sum(xtind);
    x2s = sum(xtind.^2);

    SSE = sum((ytin-yinf).^2); % sum square error
    MSE = SSE/(nt-2); % mean square error = S^2 = SSE/(n-2)
    S = sqrt(MSE); % S = sqrt(S^2) = sqrt(SSE/(n-2));
    Sb = S/sqrt(x2s-xs.^2/nt);
    t = abs(xp(2,1)/Sb);
    %df = nt-2;

    % output
    ytinf(:,id) = yinf;
    mr(id,1) = xp(2,1);
    tv(id,1) = t;
end

% multiple regression function
if nd>1
    xtim = [ones(nt,1),xtin];
    ytim = ytin;
    xpm = xtim\ytim;
    ytimf = xtim*xpm;
    ytinfm = ytimf;
else
    ytinfm = [];
end
