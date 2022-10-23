function [X, cnn] = prox_cnn(Lnn,Y,rho)

[n1,n2,n3] = size(Y);
X = zeros(n1,n2,n3);
cnn = 0;
[W1, W2, W3, core_tensor] = tucker(Y);
for i = 1 : n3
    [U,S,V] = svd(core_tensor(:,:,i),'econ');
    S = diag(S);
    r = length(find(S>rho));
    if r >= 1
        S = S(1:r)-rho;
        X(:,:,i) = U(:,1:r)*diag(S)*V(:,1:r)';
        cnn = cnn+sum(S);
    end
end
X = tmprod(X, W1, 1);
X = tmprod(X, W2, 2);
X = tmprod(X, W3, 3);
