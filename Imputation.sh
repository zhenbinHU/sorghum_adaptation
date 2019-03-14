#!/bin/bash
#SBATCH --job-name=imp
#SBATCH --output=imp.txt
#SBATCH --time=13-00:00:00
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=4
#SBATCH --partition=killable.q
#SBATCH --mem-per-cpu=20GB
#SBATCH --mail-user=zhenbin@ksu.edu
cd /bulk/zhenbin/sorghum_adaptation/origin_data
module load Java
beagle="java -Xmx100g -jar /homes/zhenbin/packages/beagle.22Feb16.8ef-2.jar"
vcf2hmp="/homes/zhenbin/tassel-5-standalone/run_pipeline.pl -Xms150g -Xmx200G -fork1"
# to faster the imputation, I split the genome to ten chromosomes and impute one by one
for i in {1..10}
do
$beagle gt=chr$i.recode.vcf out=imp_chr$i nthreads=4
done

# convert the data from vcf2hmp
gunzip *gz
for i in {1..10}
do
$vcf2hmp -VCF imp_chr$i.vcf -export -exportType Hapmap -runfork1
done
