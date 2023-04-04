/*
 * Author: Schuyler Smith <schuyler-smith.github.io>
 */

include { FASTQC }          from "${baseDir}/modules/read_qc/fastqc"
include { FASTP }           from "${baseDir}/modules/read_qc/fastp"
include { FASTP_TRIM }      from "${baseDir}/modules/read_qc/fastp_trim"
include { BBMERGE }         from "${baseDir}/modules/read_qc/bbtools"
include { PANDASEQ }        from "${baseDir}/modules/read_qc/pandaseq"
include { TRIMMOMATIC }     from "${baseDir}/modules/read_qc/trimmomatic"

workflow READ_QC {
  take:
    samples
    path
  
  main:
    def sample_list = []
    samples.each{ sample ->
      sample_list << "${path}/${sample}*_R{1,2}*fastq.gz"
    }

    SAMPLES_CH = Channel.fromFilePairs(sample_list)     
      .map{ id, reads -> 
        meta = [:]
        meta.id = id
        meta.single_end = false 
        [meta, reads]
      }
    FASTQC          (SAMPLES_CH)
    TRIMMOMATIC     (SAMPLES_CH)
    FASTP           (SAMPLES_CH)
    // BBMERGE         (SAMPLES_CH)
    // PANDASEQ        (SAMPLES_CH)
    // SEQ_SPLIT       (FASTP.out.reads_merged)
    TRIMMED_READS = TRIMMOMATIC.out.trimmed_reads

    MERGED_READS = 
      FASTP.out.merged_reads
        .map{ meta, reads -> 
          merged    = [:]
          merged.id = "${meta.id}_merged"
          [merged, reads]
        }
        .concat(
          FASTP.out.unpaired_R1_reads
            .map{ meta, reads -> 
              unpaired1 = [:]
              unpaired1.id = "${meta.id}_unpaired1"
              [unpaired1, reads]
            },
          FASTP.out.unpaired_R2_reads
            .map{ meta, reads -> 
              unpaired2 = [:]
              unpaired2.id = "${meta.id}_unpaired2"
              [unpaired2, reads]
            }
        )
        // .groupTuple()
    UNMERGED_READS = 
      FASTP.out.unmerged_R1_reads
        .map{ meta, reads -> 
          unmerged1 = [:]
          unmerged1.id = "${meta.id}_unmerged1"
          [unmerged1, reads]
      }

  emit:
    trimmed_reads   = TRIMMED_READS
    merged_reads    = MERGED_READS
    unmerged_reads  = UNMERGED_READS
}