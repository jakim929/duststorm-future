pro multi_plot_sunwoo

PRECIP = [0.5,0.7,1.2,1.8,2.5,1.6,1.9,1.5,1.2,1.0,0.8,0.6]
TEMP = [30, 34, 38, 47, 57, 67, 73, 71, 63, 52, 39, 33]
DAY = FINDGEN(12) * 30 + 15
 
; Plot #1: In position #1 on the grid defined by LAYOUT
    myPlot = PLOT(DAY, PRECIP, "ro--",$
    TITLE="Denver Precipitation", $
    YTITLE="Inches", XTITLE="Day of Year", $
    LAYOUT=[1,2,1])
 
; Plot #2: In position #4 on the grid defined by LAYOUT
    myPlotToo = PLOT(DAY, TEMP, "bS:", $
    TITLE="Denver Temperature", $
    XTITLE="Day of Year", $
    YTITLE="Degrees Fahrenheit", /CURRENT, $
    LAYOUT=[1,2,2])
    
end
