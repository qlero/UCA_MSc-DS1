#Task to be done after class:
- Reserve two GPUs: **oarsub -p "gpu='YES' and gpucapability>='5.0'" -l /gpunum=2,walltime=1 -I -t besteffort**
- Set the pytorch environment
- Modify the codes that rank 1 broadcasts its value 
- Run **python Spawn.py --size 2 --func "broadcast"**
- Run **python -m torch.distributed.launch --nproc_per_node=2 Launch.py --func "broadcast" --backend nccl**

Send the screenshots of returns from the prompt after executing the above commands.   
