#!/bin/bash

# Function to filter and symlink FASTQ files matching selected BAMs
filter_and_symlink_fastqs() {
    local bam_dir="$1"
    local fastq_dir="$2"
    local destination="$3"
    local plate_name="$4"

    for bam in "$bam_dir"/*.bam; do
        id=$(basename "$bam" | cut -d'.' -f1)
        fastq1="${fastq_dir}/${id}.1.fastq.gz"
        fastq2="${fastq_dir}/${id}.2.fastq.gz"

        if [ -f "$fastq1" ] && [ -f "$fastq2" ]; then
            # Create the symlinks for both paired FASTQ files using the plate name as prefix
            ln -s "$fastq1" "${destination}/${plate_name}_${id}.1.fastq.gz"
            ln -s "$fastq2" "${destination}/${plate_name}_${id}.2.fastq.gz"
        fi
    done
}


# Function to process each pool and create symbolic links
process_pool() {
    local pool_name="$1"
    local pool_dirs="$2"
    
    # Create the destination directory for this pool
    mkdir -p "${destination_base}/${pool_name}"

    # For each directory in the pool
    for dir in ${pool_dirs}; do
        # Extract the plate name
        plate_name=$(basename $(dirname "$dir") | cut -d'-' -f4)

        # Define the selected BAM directory (the "selected" folder within the pool directory)
        bam_dir="${dir}/selected"
        
        # Symlink the fastq files based on matching BAMs
        filter_and_symlink_fastqs "$bam_dir" "$dir/fastq" "$destination_base/$pool_name" "$plate_name"
    done
}

# Define the destination directory for organized fastqs
destination_base="/g/korbel2/tsapalou/Strand_Seq_Pools"

# Process all pools
process_pool "pool1_old" "/scratch/tweber/DATA/MC_DATA/STOCKS/2022-11-15-H33JMAFX5/HGSVCpool1xulOPxEcho /scratch/tweber/DATA/MC_DATA/STOCKS/2022-11-15-H33JMAFX5/HGSVCpool1xulOPxmanual /scratch/tweber/DATA/MC_DATA/STOCKS/2021-07-29-HWYJ2AFX2/HGSVCxpool1x01 /scratch/tweber/DATA/MC_DATA/STOCKS/2022-11-25-H37MNAFX5/HGSVCpool1quadrant2KAPA"

process_pool "pool2_old" "/scratch/tweber/DATA/MC_DATA/STOCKS/2021-08-03-H22VWAFX3/HGSVCxpool2x02 /scratch/tweber/DATA/MC_DATA/STOCKS/2023-02-08-HCN3VAFX5/HGSVCpool2 /scratch/tweber/DATA/MC_DATA/STOCKS/2023-02-08-HCN3VAFX5/HGSVCpool2iTRUE5 /scratch/tweber/DATA/MC_DATA/STOCKS/2023-03-08-HCNGHAFX5/HGSVCpool2OPSfromFrozen2ul /scratch/tweber/DATA/MC_DATA/STOCKS/2023-03-08-HCNGHAFX5/HGSVCpool2inWell2ul /scratch/tweber/DATA/MC_DATA/STOCKS/2023-03-08-HCNGHAFX5/HGSVCpool2inWell5ul /scratch/tweber/DATA/MC_DATA/STOCKS/2023-04-21-HGF2CAFX5/LanexHGSVCpool2500nlEcho /scratch/tweber/DATA/MC_DATA/STOCKS/2023-04-26-HCMMNAFX5/HGSVCpool2iinWell2ulLS /scratch/tweber/DATA/MC_DATA/STOCKS/2023-04-26-HCMMNAFX5/HGSVCpool2OPS500nl"

process_pool "pool3_old" "/scratch/tweber/DATA/MC_DATA/STOCKS/2021-08-03-H22VWAFX3/HGSVCxpool3x01 /scratch/tweber/DATA/MC_DATA/STOCKS/2023-06-23-HGFLGAFX5/HGSVCpool3UVled"

process_pool "pool1_new" "/scratch/tweber/DATA/MC_DATA/STOCKS/2023-11-09-HW5NFAFX5/HGSVCpool1NEW"

process_pool "pool2_new" "/scratch/tweber/DATA/MC_DATA/STOCKS/2023-11-09-HW3YVAFX5/LanexHGSVCpool2NEW /scratch/tweber/DATA/MC_DATA/STOCKS/2024-01-30-AACT75KM5/HGSVCpool1NEWp2 /scratch/tweber/DATA/MC_DATA/STOCKS/2024-01-29-H33YJAFX7/LanexHGSVCpool2NEW96wellUVLED /scratch/tweber/DATA/MC_DATA/STOCKS/2024-02-05-H33YHAFX7/HGSVCpool2NEW96wellUVLED"

process_pool "pool3_new" "/scratch/tweber/DATA/MC_DATA/STOCKS/2024-01-30-AACT75KM5/HGSVCpool3NEWp2"
