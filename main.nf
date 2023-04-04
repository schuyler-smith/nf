/*
 * Author: Schuyler Smith <schuyler-smith.github.io>
 */

log.info """
    Schuyler's NF Workflows!
    """
    .stripIndent()

workflow BIOME_GENES{
    READ_QC (
      reads,
      seq_data_path
    )

    QC_READS = READ_QC.out.merged_reads
      .concat(READ_QC.out.unmerged_reads)

    READ_ANNOTATION (
      QC_READS,
      protein_database,
      megan_database
    )

    TAXONOMIC_ASSIGNMENT (
      READ_QC.out.trimmed_reads,
      kraken_database
    )

}