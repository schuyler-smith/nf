/*
 * Author: Schuyler Smith <schuyler-smith.github.io>
 */

process TRIMMOMATIC {
    tag "$meta.id"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.paired.trim*.fastq.gz")    , emit: trimmed_reads
    tuple val(meta), path("*.unpaired.trim_*.fastq.gz") , optional:true, emit: unpaired_reads
    tuple val(meta), path("*.summary")                  , emit: summary

    script:
    def args    = task.ext.args   ?: ''
    def prefix  = task.ext.prefix ?: "${meta.id}"
    def type    = meta.single_end ? "SE" : "PE"
    def output  = meta.single_end 
        ? "${prefix}.SE.paired.trim.fastq.gz"
        : "${prefix}.paired.trim_1.fastq.gz ${prefix}.unpaired.trim_1.fastq.gz ${prefix}.paired.trim_2.fastq.gz ${prefix}.unpaired.trim_2.fastq.gz"
    """
    trimmomatic \\
        $type \\
        -threads $task.cpus \\
        -summary ${prefix}.summary \\
        $reads \\
        $output \\
        $args
    """
}