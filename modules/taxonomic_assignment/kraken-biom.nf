/*
 * Author: Schuyler Smith <schuyler-smith.github.io>
 */

process KRAKEN_BIOM {
    tag     "$meta.id"

    input:
    tuple val(meta), path(classifications)

    output:
    tuple val(meta), path('*_biom.tsv')

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    kraken-biom $classifications
    biom convert -i table.biom -o ${prefix}_biom.tsv --to-tsv --header-key taxonomy
    sed -i 's/.__//g' ${prefix}_biom.tsv
    sed -i 's/; /\t/g' ${prefix}_biom.tsv
    # sed 's/\t/,/g' ${prefix}_biom.tsv > ${prefix}_biom.csv
    """
}