/*
 * Author: Schuyler schuyler.smith@nutrien.com
 */

include { KRAKEN }          from "${baseDir}/modules/taxonomic_assignment/kraken"
include { BRACKEN }         from "${baseDir}/modules/taxonomic_assignment/bracken"
include { KRAKEN_BIOM }     from "${baseDir}/modules/taxonomic_assignment/kraken-biom"

workflow TAXONOMIC_ASSIGNMENT {
  take:
    reads
    kraken_db
    kraken_fastq
    kraken_assign
        
  main:
    KRAKEN (reads, kraken_db, kraken_fastq, kraken_assign)
    BRACKEN (KRAKEN.out.report, kraken_db)
    KRAKEN_BIOM (BRACKEN.out.report)

}