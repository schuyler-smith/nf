/*
 * Author: Schuyler schuyler.smith@nutrien.com
 */

process BRACKEN {
    tag     "$meta.id"

    input:
        tuple val(meta), path(kraken_report)
        path database

    output:
        tuple val(meta), path(bracken_report),      emit: report
        tuple val(meta), path(bracken_out),         emit: classifications
        tuple val(meta), path('*.log'),             emit: log

    script:
        def threshold       = meta.threshold ?: 0
        def taxonomic_level = meta.taxonomic_level ?: 'S'
        def read_length     = meta.read_length ?: 100
        def args            = task.ext.args ?: "-l ${taxonomic_level} -t ${threshold} -r ${read_length}"
        def prefix          = task.ext.prefix ?: "${meta.id}"
        bracken_out         = "${prefix}_classified.txt"
        bracken_report      = "${prefix}_${taxonomic_level}.tsv"

    """
    bracken \\
        -d '${database}' \\
        -i '${kraken_report}' \\
        -o '${bracken_out}' \\
        -w '${bracken_report}' \\
        ${args} > ${prefix}.bracken.log
    """
}