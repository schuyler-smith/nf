/*
 * Author: Schuyler schuyler.smith@nutrien.com
 */

process DIAMOND_BLASTX {
    tag     "$meta.id"

    input:
        tuple   val(meta), path(reads)
        path    '*'
        val     db_name
        val     out_ext
        val     blast_columns

    output:
        tuple val(meta), path('*.blast'), optional: true, emit: blast
        tuple val(meta), path('*.xml')  , optional: true, emit: xml
        tuple val(meta), path('*.txt')  , optional: true, emit: txt
        tuple val(meta), path('*.daa')  , optional: true, emit: daa
        tuple val(meta), path('*.sam')  , optional: true, emit: sam
        tuple val(meta), path('*.tsv')  , optional: true, emit: tsv
        tuple val(meta), path('*.paf')  , optional: true, emit: paf
        tuple val(meta), path("*.log")                  , emit: log
        tuple val(meta), path("*_query_count.txt")      , emit: count

    script:
        def args = task.ext.args ?: ''
        def prefix = task.ext.prefix ?: "${meta.id}"
        def columns = blast_columns ? "${blast_columns}" : ''
        switch ( out_ext ) {
            case "blast": outfmt = 0; break
            case "xml": outfmt = 5; break
            case "txt": outfmt = 6; break
            case "daa": outfmt = 100; break
            case "sam": outfmt = 101; break
            case "tsv": outfmt = 102; break
            case "paf": outfmt = 103; break
            default:
                outfmt = '6';
                out_ext = 'txt';
                log.warn("Unknown output file format provided (${out_ext}): selecting DIAMOND default of tabular BLAST output (txt)");
                break
        }
        """
        diamond blastx \\
            --db $db_name \\
            --query $reads \\
            --out ${prefix}.${out_ext} \\
            --outfmt ${outfmt} ${columns} \\
            --verbose \\
            $args 2> diamond.log
        tail -1 diamond.log > ${prefix}_query_count.txt
        mv diamond.log ${prefix}.log
        """
}