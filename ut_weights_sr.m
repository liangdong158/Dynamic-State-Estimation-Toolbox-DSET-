% Modified "ut_weights" in ekfukf toolbox for the square-root UKF method
% The square-root UKF can be found in 
% Junjian Qi, Kai Sun, Jianhui Wang, and Hui Liu,
% "Dynamic State Estimation for Multi-Machine Power System by 
% Unscented Kalman Filter with Enhanced Numerical Stability,"
% IEEE Trans. Smart Grid, in press. DOI: 10.1109/TSG.2016.2580584 
% and the references therein
% Junjian Qi
% 2015

%UT_WEIGHTS - Generate unscented transformation weights
%
% Syntax:
%   [WM,WC,c] = ut_weights(n,alpha,beta,kappa)
%
% In:
%   n     - Dimensionality of random variable
%   alpha - Transformation parameter  (optional, default 0.5)
%   beta  - Transformation parameter  (optional, default 2)
%   kappa - Transformation parameter  (optional, default 3-n)
%
% Out:
%   WM - Weights for mean calculation
%   WC - Weights for covariance calculation
%    c - Scaling constant
%
% Description:
%   Computes unscented transformation weights.
%
% See also UT_MWEIGHTS UT_TRANSFORM UT_SIGMAS
% 

% Copyright (C) 2006 Simo S�rkk�
%
% $Id: ut_weights.m 467 2010-10-12 09:30:14Z jmjharti $
%
% This software is distributed under the GNU General Public 
% Licence (version 2 or later); please refer to the file 
% Licence.txt, included with the software, for details.

function [WM,WC,c] = ut_weights_sr(n,alpha,beta,kappa)

%
% Check which arguments are there
%
if nargin < 1
  error('At least dimensionality n required.');
end
if nargin < 2
  alpha = [];
end
if nargin < 3
  beta = [];
end
if nargin < 4
  kappa = [];
end

%
% Apply default values
%
if isempty(alpha)
%   alpha = 1;
  alpha = 0.5;
%   alpha = sqrt(3);
end
if isempty(beta)
%   beta = 0;
  beta = 2;
end
if isempty(kappa)
%   kappa = 3 - n;
end
	  
%
% Compute the normal weights 
%
% lambda = alpha^2 * (n + kappa) - n;
lambda = n*(alpha^2 - 1);

WM = zeros(2*n+1,1);
WC = zeros(2*n+1,1);
for j=1:2*n+1
  if j==1
    wm = lambda / (n + lambda);
    wc = lambda / (n + lambda) + (1 - alpha^2 + beta);
  else
    wm = 1 / (2 * (n + lambda));
    wc = wm;
  end
  WM(j) = wm;
  WC(j) = wc;
end

c = n + lambda;
