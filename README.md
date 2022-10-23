# Tensor robust PCA (TRPCA) via c-SVD

### Introduction

we propose a new tensor decomposition framework named core-SVD. The main idea of this method is to apply the matrix-SVD to the core matrix yield from Tucker decomposition. 

<p align="center">
	<a href="https://github.com/AnonymousStudy/c-SVD">
    <img class="page-image" src="https://github.com/AnonymousStudy/c-SVD/figure/csvd.pdf" >
	</a>
</p>

### Contents
- [Demo](#Demo)
- [References](#references)


### Demo 
1. run the hyperspectral image denoising demo using:
```
matlab -nosplash -nodesktop < demo_hyperspectral_image_denoising.m
```
2. run the simultation on phase Transition in rank and sparsity using:
```
matlab -nosplash -nodesktop < demo_simulation.m
```



### References
<ol>
<li> L. D. Lathauwer, B. D. Moor and J. Vandewalle, A multilinear singular value decomposition, SIAM J. Matrix Analysis and Applications, 21(4):1253-1278, 2000
<li> Canyi Lu, Jiashi Feng, Yudong Chen, Wei Liu, Zhouchen Lin, Shuicheng Yan. Tensor Robust Principal Component Analysis with A New Tensor Nuclear Norm. TPAMI. 2019


