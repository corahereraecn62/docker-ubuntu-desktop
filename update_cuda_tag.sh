#!/bin/bash

ubuntu18_cuda_tags=(11.0.3 11.1.1 11.2.2)
ubuntu20_cuda_tags=(11.0.3 11.1.1 11.2.2 11.3.1 11.4.3 11.5.2 11.6.2 11.7.1)
ubuntu22_cuda_tags=(11.7.1 11.8.0 12.0.1 12.1.1 12.2.2 12.3.2 12.4.1 12.5.1)
ubuntu24_cuda_tags=(12.5.1 12.6.2)

for value in ${ubuntu18_cuda_tags[@]}
do
    git tag 18.04-cu$value -f
    git push origin 18.04-cu$value -f
done

for value in ${ubuntu20_cuda_tags[@]}
do
    git tag 20.04-cu$value -f
    git push origin 20.04-cu$value -f
done

for value in ${ubuntu22_cuda_tags[@]}
do
    git tag 22.04-cu$value -f
    git push origin 22.04-cu$value -f
done

for value in ${ubuntu24_cuda_tags[@]}
do
    git tag 24.04-cu$value -f
    git push origin 24.04-cu$value -f
done

exit 0
