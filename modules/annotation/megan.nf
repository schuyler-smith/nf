process MEGAN {
    tag     "$meta.id"

    input:
        tuple val(meta), path(daa)
        path megan_map

    output:
        tuple val(meta), path("*_taxonomy.tsv"),        emit: taxa
        tuple val(meta), path("*_GDTB_taxonomy.tsv"),   emit: GDTB
        tuple val(meta), path("*_EC.tsv"),              emit: EC
        tuple val(meta), path("*_KEGG.tsv"),            emit: KEGG

    script:
        def args    = task.ext.args ?: ''
        def prefix  = task.ext.prefix ?: "${meta.id}"
        """
        daa-meganizer \\
            -i $daa \\
            -t $task.cpus \\
            -mdb $megan_map \\
            -tsm TRUE
        daa2info \\
            -i $daa \\
            -o ${prefix}_taxonomy.tsv \\
            -c2c Taxonomy \\
            -n true \\
            -u false \\
            -mro true \\
            -p true
        daa2info \\
            -i $daa \\
            -o ${prefix}_GDTB_taxonomy.tsv \\
            -c2c GTDB \\
            -n true \\
            -u false \\
            -mro true \\
            -p true
        daa2info \\
            -i $daa \\
            -o ${prefix}_KEGG.tsv \\
            -c2c KEGG \\
            -n true \\
            -u false \\
            -p true
        daa2info \\
            -i $daa \\
            -o ${prefix}_EC.tsv \\
            -c2c EC \\
            -n true  \\
            -u false \\
            -s true
        """
}