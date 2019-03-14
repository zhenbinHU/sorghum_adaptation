#!/bin/bash
#SBATCH --job-name=admix_1
#SBATCH --output=admix_1.txt
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=4
#SBATCH --partition=killable.q
#SBATCH --mem-per-cpu=20GB
#SBATCH --mail-user=zhenbin@ksu.edu

cd /bulk/zhenbin/sorghum_adaptation/ADMIXTURE
plink="/homes/zhenbin/packages/plink"
admixture="/homes/zhenbin/admixture_linux-1.23/admixture"
$plink --vcf SNP.recode.vcf --geno 1 --make-bed --out SNP_admixture # convert the data format from vcf to bed
for i in {2..20}
do
$admixture --cv SNP_admixture.bed $i | tee log${i}.out
done
