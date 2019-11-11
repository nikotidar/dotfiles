#!/bin/sh

lowbat-notify &
xrdb ~/.Xresources
xcalib ~/.x230.icm &

exec Wmderland
