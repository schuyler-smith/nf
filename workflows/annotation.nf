/*
 * Author: Schuyler schuyler.smith@nutrien.com
 */

include { DIAMOND_BLASTX }   from "${baseDir}/modules/protein_annotation/diamond"
include { MEGAN }            from "${baseDir}/modules/protein_annotation/megan"

workflow PROTEIN_ANNOTATION {
  take:
    reads
    diamond_db
    diamond_db_path
    dmnd_out_fmt
    dmnd_blast_cols
    megan_db
        
  main:
    PROTEIN_DB = Channel.fromPath("${diamond_db_path}/*").collect()
    DIAMOND_BLASTX (reads, PROTEIN_DB, diamond_db, dmnd_out_fmt, dmnd_blast_cols)
    DAA = DIAMOND_BLASTX.out.daa
    MEGAN (DAA, megan_db)
    
}