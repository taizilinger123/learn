#!/bin/sh

# BKC selection for densetnet161

# --subgraph
# --bs <list>
# --data-thread <list>
while [ $# -gt 0 ]
do
    case "$1" in
        -s|--subgraph)
            subgraph=on
            #shift
            ;;
        -b|--bs)
            batches_list=$2
            shift
            ;;
        -d|--data-thread)
            data_threads_list=$2
            shift
            ;;
        -ds|--dataset)
            batch_size_list=$2
            shift
            ;;
    esac
    shift
done

echo "Subgraph is: " $subgraph

export KMP_AFFINITY=granularity=fine,noduplicates,compact,1,0

if [ "$subgraph" == "on" ]; then
    echo "Subgraph enabled"
    export MXNET_SUBGRAPH_BACKEND=MKLDNN
else
    echo "Subgraph disbabled"
    unset MXNET_SUBGRAPH_BACKEND
fi

batches_list=(${batches_list//,/ })
data_threads_list=(${data_threads_list//,/ })
batch_size_list=(${batch_size_list//,/ })

for _index in $(seq ${#batches_list[@]})
do
    index=$((${_index}-1))
    echo "BS set to ${batch_size_list[$index]}"
    export OMP_NUM_THREADS=$((28-${data_threads_list[$index]}))
    echo "OMP is " $OMP_NUM_THREADS
    echo numactl --physcpubind=0-27 --membind=0 python imagenet_inference.py --symbol-file=./model/densenet161-symbol.json --param-file=./model/densenet161-0000.params --num-inference-batches=${batches_list[$index]} --dataset=~/dataset/299/valset.rec  --batch-size=${batch_size_list[$index]} --data-nthreads=${data_threads_list[$index]} --ctx=cpu
done