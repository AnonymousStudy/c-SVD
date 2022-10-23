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
close all

n = 100;
L_err_res = zeros(55,55);
S_err_res = zeros(55,55);
row_i = 1;
for rank_ratio = 0.05 : 0.05: 0.50
    col_i = 1;
    for sparse_ratio = 0.05 : 0.05: 0.50
        disp(rank_ratio)
        disp(sparse_ratio)    
        r = int32(rank_ratio*n); % tucker rank
        

        transform.L = eye(n); transform.l = 1;
        W1 = RandOrthMat(n);
        W2 = RandOrthMat(n);
        W3 = RandOrthMat(n);
        
        C = randn(r,r,r);
        L = C;
        L = permute(reshape(reshape(permute(L, [2 3 1]), r * r, r) * W1(1:r, :), r, r, n), [3, 1, 2]);
        L = permute(reshape(reshape(permute(L, [1 3 2]), n * r, r) * W2(1:r, :), n, r, n), [1, 3, 2]);
        L = permute(reshape(reshape(permute(L, [1 2 3]), n * n, r) * W3(1:r, :), n, n, n), [1, 2, 3]);
        
        m = int32(sparse_ratio*n*n*n);
        temp = rand(n*n*n,1);
        [B,I] = sort(temp);
        I = I(1:m);
        Omega = zeros(n,n,n);
        Omega(I) = 1;
        E = sign(rand(n,n,n)-0.5);

        S = Omega.*E; % sparse part, or noises. S = P_Omega(E)

        Xn = L+S;
        lambda = 1/sqrt(max(n,n));

        opts.tol = 1e-6;
        opts.mu = 4e-4;
        opts.rho = 1.3;
        opts.DEBUG = 1;

        [Lhat,Shat] = trpca_cnn(Xn,lambda,opts);

        Lr = norm(L(:)-Lhat(:))/norm(L(:))
        Sr = norm(S(:)-Shat(:))/norm(S(:))
        L_err_res(row_i, col_i) = Lr;
        S_err_res(row_i, col_i) = Sr;  
        col_i = col_i + 1;
    end
    row_i = row_i + 1;
end

save(['./log/' datestr(datetime('now'),'yy-mm-dd-HH-MM-SS') '_L_tuckercnn.mat'], 'L_err_res')
save(['./log/' datestr(datetime('now'),'yy-mm-dd-HH-MM-SS') '_S_tuckercnn.mat'], 'S_err_res')


