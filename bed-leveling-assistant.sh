#!/bin/bash
source shell-functions.sh
source bed-levelling-assistant.conf

begin gcode/${NAME}_bed-leveling-assistant.gcode

function move_to(){
  M117 Moving to X${1} Y${2}
  G0 X${1} Y${2}
  G0 Z0
  M0 Test with paper
  G1 Z1
}

function decompress(){
  for i in {0..3}
  do
    G0 X${1} Y${2} Z5
    G0 Z0
  done
  G28 Z
  G0 Z10
}


## Initial homing and geometry
G1 F100000000
G1 Z1
G90
M140 S70
M190 S70
M104 S0
G28 X
G28 Y
G28 Z
G1 Z1


## Run through leveling routine
for i in {0..3}
do
  move_to ${LOWERX} ${LOWERY}
  move_to ${UPPERX} ${LOWERY}
  move_to ${UPPERX} ${UPPERY}
  move_to ${LOWERX} ${UPPERY}
done


## Decompress routine
if [ "${DECOMPRESS}" == "true" ]
then
  G0 Z20
  M0 Place coin on each corner
  for i in {0..1}
  do
    decompress ${LOWERX} ${LOWERY}
    decompress ${UPPERX} ${LOWERY}
    decompress ${UPPERX} ${UPPERY}
    decompress ${LOWERX} ${UPPERY}
  done
  G0 Z20
  M0 Remove coins
  for i in {0..1}
  do
    move_to ${LOWERX} ${LOWERY}
    move_to ${UPPERX} ${LOWERY}
    move_to ${UPPERX} ${UPPERY}
    move_to ${LOWERX} ${UPPERY}
  done
fi


## Finish up
G0 X100 Y100
G0 Z10
finish gcode/${NAME}_bed-levelling-assistant.gcode
