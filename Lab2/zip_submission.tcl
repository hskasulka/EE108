cd [file dirname [file normalize [info script]]]

set FILES {src/design/float_add.v \
    src/design/big_number_first.v \
    src/design/shifter.v \
    src/design/adder.v \
    src/sim/float_add_tb.v \
    src/sim/big_number_first_tb.v \
    src/sim/shifter_tb.v \
    src/sim/adder_tb.v \
    src/lab2.xdc \
    lab2.runs/impl_1/lab2_top.bit \
    lab2.runs/impl_1/lab2_top_timing_summary_routed.rpt \
    lab2.runs/synth_1/lab2_top.vds}


set archive_name "lab2_submission.tar.gz"

file delete -force $archive_name

set tar_command "tar -czf $archive_name"
set failed_files {}
append failed_files "\n                      "

foreach file $FILES {
        if {[file exists $file]} {
                append tar_command " $file"
        } else {
                puts "Warning: File not found - $file"
                append failed_files "$file\n                      "
        }
}


if {[catch {exec {*}$tar_command} result]} {
    puts "Error creating tar archive: $result"
} else {
    puts "\n \n \n \n \n~~~~~~Generated $archive_name. Please make sure that all of your files are in the .tar.gz zip folder. Congrats on finishing!~~~~~~ \n     List of failed files: $failed_files"
}
