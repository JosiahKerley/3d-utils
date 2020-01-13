[[ -f printer.conf ]] || (
  echo "no printer.conf created, cp one from printers/ to ./"
  exit 1
)

source printer.conf

function begin(){
  echo M117 > gcode.tmp
}

function finish(){
cat >> gcode.tmp << GCODE
M104 S0
M140 S0
M84
M117 finished
GCODE
  steps=`wc -l gcode.tmp | cut -d' ' -f1`
  c=0
  while read line
  do
    c=$(( $c + 1 ))
    percent=$(( $(( $c*100 ))/steps ))
    echo "M117 ${percent}% complete"
    echo $line
  done < gcode.tmp > $*
}

function gcode(){
  echo $* >> gcode.tmp
  echo M400 >> gcode.tmp
}

function beep(){
  M300 S440 P200
  M300 S660 P250
  M300 S880 P300
}

function G28(){
  gcode G28 $*
}

function M105(){
  gcode M105 $*
}

function M104(){
  gcode M104 $*
}

function M109(){
  gcode M109 $*
}

function M82(){
  gcode M82 $*
}

function M300(){
  gcode M300 $*
}

function M0(){
  gcode M0 $*
}

function M117(){
  gcode M117 $*
}

function M140(){
  gcode M140 $*
}

function M190(){
  gcode M190 $*
}

function G90(){
  gcode G90 $*
}

function G92(){
  gcode G92 $*
}

function G1(){
  gcode G1 $*
}

function G0(){
  gcode G0 $*
}

