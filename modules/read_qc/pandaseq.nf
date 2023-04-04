/*
 * Author: Schuyler Smith <schuyler-smith.github.io>
 */

process PANDASEQ {
    tag "$meta.id"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.merged.fastq"),       emit: merged_reads
    tuple val(meta), path("*.unaligned.txt"),      emit: unmerged_reads

    script:
    def args    = task.ext.args   ?: ''
    def prefix  = task.ext.prefix ?: "${meta.id}"

    """
    pandaseq \\
        -T $task.cpus \\
        -f ${reads[0]} \\
        -r ${reads[1]} \\
        -d rbfkms \\
        -u ${prefix}_unmerged_pandaseq.fa \\
        $args \\
        2> ${prefix}_pandastat.txt \\
        1> ${prefix}_merged_pandaseq.fastq \\
    """
}