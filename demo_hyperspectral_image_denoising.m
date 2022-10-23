% Tensor robust principal component analysis based on core nuclear norm 
%
% min_{L,S} ||L||_*c+lambda*||S||_1, s.t. X=L+S
%
% ---------------------------------------------
% Input:
%       X       -    d1*d2*d3 tensor
%       lambda  -    >0, parameter
% Hyperparameters:
%       tol        -   termination tolerance
%       max_iter   -   maximum number of iterations
%       mu         -   stepsize for dual variable updating in ADMM
%       max_mu     -   maximum stepsize
%       rho        -   rho>=1, ratio used to increase mu
%       DEBUG      -   0 or 1

addpath(genpath(cd))
clear

load('hyperspectral_image_denoising/toys.mat')
L = double(permute(orig,[3 1 2])) /255.;
maxP = max(abs(L(:)));
[n1,n2,n3] = size(L);
X = L;
rhos = 0.3;
ind = find(rand(n1*n2*n3,1)<rhos);
X(ind) = rand(length(ind),1);
lambda = 1/sqrt(max(n1,n2));

tol = 1e-4;
max_iter = 500;
DEBUG = 1;
max_mu = 1e10;
mu=4e-4; 
rho = 1.3;

Lnn = zeros(size(X));
Y = zeros(size(X));
Sparse = zeros(size(X));
for iter = 1 : max_iter
    Lk = Lnn;
    Sk = Sparse;
    % update L
    [Lnn,tnnL] = prox_cnn(Lnn, -Sparse+X-Y/mu,1/mu);

    % update S
    Sparse = prox_l1(-Lnn+X-Y/mu,lambda/mu);

    dY = Lnn+Sparse-X;
    chgL = max(abs(Lk(:)-Lnn(:)));
    chgS = max(abs(Sk(:)-Sparse(:)));
    chg = max([ chgL chgS max(abs(dY(:))) ]);
    if DEBUG
        if iter == 1 || mod(iter, 10) == 0
            obj = tnnL+lambda*norm(Sparse(:),1);
            err = norm(dY(:));
            psnr = PSNR(L, Lnn, maxP);
            disp(['iter ' num2str(iter) ', mu=' num2str(mu) ...
                    ', obj=' num2str(obj) ', err=' num2str(err) ', psnr=' num2str(psnr)]);
        end
    end

    if chg < tol
        break;
    end 
    Y = Y + mu*dY;
    mu = min(rho*mu,max_mu);
end
obj = tnnL+lambda*norm(Sparse(:),1);
err = norm(dY(:));
