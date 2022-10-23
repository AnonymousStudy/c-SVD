function [W1, W2, W3, core_tensor] = tucker(X)

[n1, n2, n3] = size(X);
[U, V, W1] = svd(reshape(permute(X, [2 3 1]), n2 * n3, n1), 'econ');
[U, V, W2] = svd(reshape(permute(X, [1 3 2]), n1 * n3, n2), 'econ');
[U, V, W3] = svd(reshape(permute(X, [1 2 3]), n1 * n2, n3), 'econ');
core_tensor = X;
core_tensor = tmprod(core_tensor, W1', 1);
core_tensor = tmprod(core_tensor, W2', 2);
core_tensor = tmprod(core_tensor, W3', 3);
