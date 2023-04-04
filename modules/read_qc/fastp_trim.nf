/*
 * Author: Schuyler schuyler.smith@nutrien.com
 */

process FASTP_TRIM {
    tag "$meta.id"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path('*.trimmed.fastq.gz'), optional:true, emit: trimmed_reads
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
        --out1 ${prefix}_1.trimmed.fastq.gz \\
        --out2 ${prefix}_2.trimmed.fastq.gz \\
        --json ${prefix}.fastp.json \\
        --html ${prefix}.fastp.html \\
        --detect_adapter_for_pe \\
        $args \\
        2> ${prefix}.fastp.log
    """
}