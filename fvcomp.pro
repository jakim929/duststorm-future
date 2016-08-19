device, decompose=0
device, retain=2

free_lun, 20
free_lun, 21
openr, 20, '/home2/sunwoo/final_output/point_output_southern_saudi/point_ust_current.csv'
openr, 21, '/home2/sunwoo/final_output/point_output_southern_saudi/point_ust_future.csv'

vdf1 = fltarr(365)
vdf2 = fltarr(365)
DAY = FINDGEN(365)
readf,20,vdf1
readf,21,vdf2
;print,stddev(vdf1)
;print,stddev(vdf2)
print, mean(vdf1)
print, mean(vdf2)

!p.multi = [0, 1, 2]
window, xsize =1200, ysize=3000

plot, DAY, vdf1, background=fsc_color('white'), title='Friction Velocity 2001', color=fsc_color('black'), thick=3, xstyle=3, ystyle=19, $
      yrange=[0.2, 1.2], charsize=3.4, xrange = [0,366], xtitle='Day of the Year', xtickinterval=31, xminor=1, $
      ytitle='Friction Velocity!c(ms-1)', linestyle=2, xmargin=13, xthick=2, ytickinterval=1*10^(-7), ythick=2, charthick=2
oplot, DAY, vdf1, color=fsc_color('black'), thick=2 

plot, DAY, vdf2, background=fsc_color('white'), title='Friction Velocity 2081', color=fsc_color('black'), thick=3,xstyle=3, ystyle=19, $
      yrange=[0.2, 1.2], charsize=3.4, xrange = [0,366], xtitle='Day of the Year',xtickinterval=31, xminor=1, $
      ytitle='Friction Velocity!c(ms-1)', linestyle=2, xmargin=13, xthick=2, ytickinterval=1*10^(-7), ythick=2, charthick=2
oplot, DAY, vdf2, color=fsc_color('black'), thick=2 

snapshot=tvrd(true=1)
;Write_png, '/home2/sunwoo/point_comparison/ustcomp_lks.png', snapshot ; Save the pop-up window image

close,20
close,21
end