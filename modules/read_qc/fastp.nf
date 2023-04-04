/*
 * Author: Schuyler schuyler.smith@nutrien.com
 */

process FASTP {
    tag "$meta.id"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path('*.merged.fastq.gz')    , optional:true, emit: merged_reads
    tuple val(meta), path('*_1.unmerged.fastq.gz'), optional:true, emit: unmerged_R1_reads
    tuple val(meta), path('*_2.unmerged.fastq.gz'), optional:true, emit: unmerged_R2_reads
    tuple val(meta), path('*_1.unpaired.fastq.gz'), optional:true, emit: unpaired_R1_reads
    tuple val(meta), path('*_2.unpaired.fastq.gz'), optional:true, emit: unpaired_R2_reads
    tuple val(meta), path('*.json')               , emit: json
    tuple val(meta), path('*.html')               , emit: html
    tuple val(meta), path('*.log')                , emit: log

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    [ ! -f  ${prefix}_1.fastq.gz ] && ln -sf ${reads[0]} ${prefix}_1.fastq.gz
    [ ! -f  ${prefix}_2.fastq.gz ] && ln -sf ${reads[1]} ${prefix}_2.fastq.gz
    fastp \\
        --thread $task.cpus \\
        --in1 ${prefix}_1.fastq.gz \\
        --in2 ${prefix}_2.fastq.gz \\
        --out1 ${prefix}_1.unmerged.fastq.gz \\
        --out2 ${prefix}_2.unmerged.fastq.gz \\
        --merge \\
        --merged_out ${prefix}.merged.fastq.gz \\
        --unpaired1 ${prefix}_1.unpaired.fastq.gz \\
        --unpaired2 ${prefix}_2.unpaired.fastq.gz \\
        --json ${prefix}.fastp.json \\
        --html ${prefix}.fastp.html \\
        --detect_adapter_for_pe \\
        $args \\
        2> ${prefix}.fastp.log
    """
}