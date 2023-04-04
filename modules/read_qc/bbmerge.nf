process BBMERGE {
    tag "$meta.id"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.merged.fastq"),                   emit: merged_reads
    tuple val(meta), path("*.unpaired1.fastq"), optional:true, emit: unpaired1_reads
    tuple val(meta), path("*.unpaired2.fastq"), optional:true, emit: unpaired2_reads

    script:
    def args    = task.ext.args   ?: ''
    def prefix  = task.ext.prefix ?: "${meta.id}"
    def input   = meta.single_end ? "in=${reads[0]}" : "in1=${reads[0]} in2=${reads[1]}"
    def output  = meta.single_end ? "out=${prefix}.merged.fastq" 
                : "out=${prefix}.merged.fastq out1=${prefix}.unpaired1.fastq out2=${prefix}.unpaired2.fastq" 
    """
    bbmerge.sh \
        $input \\
        $output \\
        $args
    """
}